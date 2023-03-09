import 'dart:convert';
import 'dart:math';

import 'package:cleversell_booking/core/constants/colors.dart';
import 'package:cleversell_booking/core/data/model/check_in.dart';
import 'package:cleversell_booking/core/data/model/customer.dart';
import 'package:cleversell_booking/core/data/model/product.dart';
import 'package:cleversell_booking/core/data/model/promo_code.dart';
import 'package:cleversell_booking/core/data/model/staff.dart';
import 'package:cleversell_booking/core/data/repository/addon_product_repository.dart';
import 'package:cleversell_booking/core/data/repository/branch_repository.dart';
import 'package:cleversell_booking/core/data/repository/customer_repository.dart';
import 'package:cleversell_booking/core/data/repository/promo_code_repository.dart';
import 'package:cleversell_booking/core/data/repository/staff_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/data/model/booking.dart';
import '../../core/data/model/room.dart';
import '../../core/data/repository/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/widgets/common/loader.dart';
import '../data/model/addon_product.dart';
import '../data/model/branch.dart';
import '../data/model/check_out.dart';
import '../data/repository/check_in_repository.dart';
import '../data/repository/product_repository.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart'
    as overlay_loader;

class DashboardController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  RoomModel? selectedRoom;
  String gender = 'Male';
  TextEditingController searchTerm = TextEditingController();
  List<String> genders = <String>['Male', 'Female'];
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  SharedPreferences? prefs;
  List<RoomModel> rooms = [];
  List<CustomerModel> customers = [];
  List<BookingModel> bookings = [];
  List<ProductModel> products = [];
  List<PromoCodeModel> promoCodes = [];
  List<AddonProductModel> addonProducts = [];
  List<BookingModel> allBookings = [];
  List<BookingModel> searchBookings = [];
  List<BranchModel> branches = [];
  List<StaffModel> staffUsers = [];
  TextEditingController searchNumber = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  CheckInModel? checkIn;
  CheckOutModel? checkOut;
  int prevIndex = 0;
  int nextIndex = 1;
  bool scan = false;
  String timeSpent = '';
  String moneyDiff = '';
  bool showCustomers = false;
  bool showRooms = false;
  bool showProducts = false;
  bool inAdvance = false;
  CustomerModel? selectedCustomer;
  ProductModel? selectedProduct;
  PromoCodeModel? selectedPromoCode;

  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final scrollDuration = const Duration(milliseconds: 500);

  final formKey = GlobalKey<FormState>();
  final childrenFormKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final childName = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final area = TextEditingController();
  final quantity = TextEditingController();
  String childBirthDate = "";
  String checkInDate = "";
  String checkInTime = "";

  int page = 1;
  int perPage = 8;
  int pages = 0;
  double price = 0;
  String? branchId = '';

  bool loading = true;
  bool newCheckIn = true;
  bool showChildrenForm = false;

  List<dynamic> children = [];

  final BookingRepository _bookingRepository;
  final CustomerRepository _customerRepository;
  final ProductRepository _productRepository;
  final PromoCodeRepository _promoCodeRepository;
  final AddonProductRepository _addonProductRepository;
  final BranchRepository _branchRepository;
  final StaffRepository _staffRepository;
  final CheckInRepository _checkInRepository;

  DashboardController(
      this._bookingRepository,
      this._customerRepository,
      this._productRepository,
      this._promoCodeRepository,
      this._addonProductRepository,
      this._branchRepository,
      this._staffRepository,
      this._checkInRepository);

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    branchId = prefs?.getString("branch");
    startDate = now.subtract(const Duration(days: 10));
    quantity.text = '0';
    await getRooms();
    await getBookings();
    await getCustomers('');
    await getProducts();
    await getPromoCodes();
    await getBranches();
    await getStaff();

    super.onInit();
  }

  getBranches() async {
    var response = await _branchRepository.getBranches();
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var branchesList = body?["rows"];
      List<BranchModel> branchesData = branchesList
          ?.map<BranchModel>((u) => BranchModel.fromJson(u))
          ?.toList();
      branches = branchesData;
      update();
    }
  }

  getStaff() async {
    var branch = prefs?.getString("branch");
    var response = await _staffRepository.getStaff();
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var staffList = body?["rows"];
      staffList = staffList?.where((element) =>
          element?["value"]?["isDeleted"] == null &&
          element["value"]?["branch"]?["_id"] == branch);
      staffUsers = staffList.map<StaffModel>((u) {
        return StaffModel.fromJson(u);
      })?.toList();
      update();
    }
  }

  updateInAdvance(value) {
    inAdvance = value;
    update();
  }

  calculateTimeSpent(CheckInModel checkIn) {
    var from = DateTime.parse('${checkIn.date} ${checkIn.time}');
    var to = DateTime.now();
    if (checkIn.checkOutId != null) {
      to = DateTime.parse('${checkIn.checkOutDate} ${checkIn.checkOutTime}');
    }
    timeSpent = roundDouble(to.difference(from).inMinutes / 60, 1).toString();
    update();
    return (to.difference(from).inHours / 24).round();
  }

  double roundDouble(value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  checkRemainingMoney(CheckInModel checkIn) {
    moneyDiff = '';
    var productName = checkIn.productName;
    if (productName == 'Full Day' || checkIn.checkOutId != null) {
      moneyDiff = '';
      update();
      return;
    }
    var productHours = '';
    if (productName.contains('Hours')) {
      productHours = productName.replaceAll(' Hours', '');
    } else {
      productHours = productName.replaceAll(' Hour', '');
    }

    if (double.parse(timeSpent) > double.parse(productHours)) {
      if (double.parse(timeSpent) <= 1) {
        ProductModel product =
            products.firstWhere((element) => element.name == '1 Hour');
        if (product != null) {
          var price = double.parse('${product.price}');
          if (checkIn.promoCode != null) {
            price = price -
                (price * (int.parse('${checkIn.promoCodeValue}') / 100));
          }
          if (double.parse('${checkIn.price}') < price) {
            moneyDiff = (price - double.parse('${checkIn.price}')).toString();
          }
        }
      } else if (double.parse(timeSpent) > 1 && double.parse(timeSpent) <= 2) {
        ProductModel product =
            products.firstWhere((element) => element.name == '2 Hours');
        if (product != null) {
          var price = double.parse('${product.price}');
          if (checkIn.promoCode != null) {
            price = price -
                (price * (int.parse('${checkIn.promoCodeValue}') / 100));
          }
          if (double.parse('${checkIn.price}') < price) {
            moneyDiff = (price - double.parse('${checkIn.price}')).toString();
          }
        }
      } else if (double.parse(timeSpent) > 2 && double.parse(timeSpent) <= 3) {
        ProductModel product =
            products.firstWhere((element) => element.name == '3 Hours');
        if (product != null) {
          var price = double.parse('${product.price}');
          print('price');
          print(price);
          if (checkIn.promoCode != null) {
            price = price -
                (price * (int.parse('${checkIn.promoCodeValue}') / 100));
          }
          if (double.parse('${checkIn.price}') < price) {
            moneyDiff = (price - double.parse('${checkIn.price}')).toString();
          }
        }
      } else if (double.parse(timeSpent) > 3) {
        ProductModel product =
            products.firstWhere((element) => element.name == 'Full Day');
        if (product != null) {
          var price = double.parse('${product.price}');
          if (checkIn.promoCode != null) {
            price = price -
                (price * (int.parse('${checkIn.promoCodeValue}') / 100));
          }
          if (double.parse('${checkIn.price}') < price) {
            moneyDiff = (price - double.parse('${checkIn.price}')).toString();
          }
        }
      }
      update();
    } else {
      return;
    }
  }

  changeQty(type) {
    if (type == 'sub' && quantity.text == '0') {
      return;
    }
    quantity.text = type == 'add'
        ? (int.parse(quantity.text) + 1).toString()
        : (int.parse(quantity.text) - 1).toString();
    update();
  }

  submitCheckIn(type, context) async {
    if (selectedProduct == null) {
      Get.snackbar("Check In", "Please select product first",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedRoom == null) {
      Get.snackbar("Check In", "Please select room first",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedCustomer == null) {
      Get.snackbar("Check In", "Please select customer first",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    showLoader(context);
    var timestamps = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    var id = generateBookingId();
    var branchId = prefs?.get("branch");
    var staffId = jsonDecode("${prefs?.get("staff")}")['id'];
    var staff = staffUsers.firstWhere((user) => user.id == staffId);
    var branch = branches.firstWhere((bran) => bran.id == branchId);
    var user = selectedCustomer?.toJson();
    var product = selectedProduct?.toJson();
    var room = selectedRoom?.toJson();
    var promo = selectedPromoCode != null ? selectedPromoCode?.toJson() : {};
    var time = checkInTime != '' ? DateFormat('HH:mm:ss').format(DateTime.now()) : DateFormat('HH:mm:ss').format(DateTime.parse(checkInTime));
    var date = checkInDate != '' ? DateFormat('yyyy-MM-dd').format(DateTime.now()) : DateFormat('HH:mm:ss').format(DateTime.parse(checkInDate));
    print('time');
    print(time);
    var pay = {
      "amount": price,
      "method": type,
      "Date": timestamps,
      "serial": getRandomString(9)
    };
    var body = {
      "_id": id,
      "branch": branch.toJson(),
      "user": user,
      "time": time,
      "date": date,
      "product": product,
      "room": room,
      "promo": promo,
      "quantity": quantity.text,
      "staff": staff.toJson(),
      "paid": inAdvance ? [pay] : [],
      "in_advance": inAdvance,
      "status": 1
    };

    var response = await _checkInRepository.createCheckIn(body);
    if (response.statusCode == 201) {
      hideLoader();
      Get.snackbar("Check in", "Created successfully",
          backgroundColor: success, colorText: primary);

      body = {"value": body};

      newCheckIn = false;
      selectedPromoCode = null;
      selectedProduct = null;
      selectedRoom = null;
      selectedCustomer = null;
      showCustomers = false;
      showProducts = false;
      inAdvance = false;
      quantity.text = '0';
      price = 0;
      checkIn = CheckInModel.fromJson(body);
      update();
    }
  }

  submitCheckOut(type, context) async {
    showLoader(context);
    var timestamps = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    var id = generateBookingId();
    var branchId = prefs?.get("branch");
    var staffId = jsonDecode("${prefs?.get("staff")}")['id'];
    var staff = staffUsers.firstWhere((user) => user.id == staffId);
    var branch = branches.firstWhere((bran) => bran.id == branchId);
    var user = {
      'id': checkIn?.customerId,
      'name': checkIn?.customerName,
      'phone': checkIn?.customerPhone,
    };
    var product = {
      'id': checkIn?.productId,
      'name': checkIn?.productName,
      'price': checkIn?.productPrice,
    };

    var room = {
      "id": checkIn?.roomId,
      "name": checkIn?.roomName,
      "slotDuration": checkIn?.roomSlotDuration,
      "capacity": checkIn?.roomCapacity
    };

    var promo = {
      'code': checkIn?.promoCode,
      'value': checkIn?.promoCodeValue,
    };
    var checkInData = checkIn?.toJson();
    var time = DateFormat('HH:mm:ss').format(DateTime.now());
    var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var pay = null;
    if (moneyDiff != '') {
      pay = {
        "amount": moneyDiff,
        "method": type,
        "Date": timestamps,
        "serial": getRandomString(9)
      };
    }

    var body = {
      "_id": id,
      "branch": branch.toJson(),
      "user": user,
      "time": time,
      "date": date,
      "product": product,
      "room": room,
      "promo": promo,
      "staff": staff.toJson(),
      "paid": pay != null ? [pay] : [],
      "status": 1
    };

    var checkInUpdate = checkIn?.toJson();
    checkInUpdate?['check_out'] = body;
    var responseUpdate =
        await _checkInRepository.updateCheckIn(checkInUpdate, checkIn?.id);
    body['check_in'] = checkInData;
    var response = await _checkInRepository.createCheckOut(body);
    if (response.statusCode == 201) {
      hideLoader();
      Get.snackbar("Check Out", "Created successfully",
          backgroundColor: success, colorText: primary);

      body = {"value": body};

      newCheckIn = false;
      selectedPromoCode = null;
      selectedProduct = null;
      selectedRoom = null;
      selectedCustomer = null;
      showCustomers = false;
      showProducts = false;
      scan = false;
      moneyDiff = '';
      timeSpent = '';
      checkIn = null;
      price = 0;
      checkOut = CheckOutModel.fromJson(body);
      update();
    }
  }

  initNewCheckIn() {
    newCheckIn = false;
    checkIn = null;
    scan = false;
    price = 0;
    update();
  }

  generateBookingId() {
    var newDate = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    var randomNumber = int.parse(getRandomNumber(3)) + 100;
    return '$newDate$randomNumber';
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  String getRandomNumber(int length) {
    const _chars = '1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  selectProduct(product) {
    selectedProduct = product;
    price = double.parse(product.price);
    update();
  }

  toggleShowCustomers() {
    showCustomers = !showCustomers;
    showProducts = false;
    update();
  }

  toggleShowProducts() {
    showProducts = !showProducts;
    showCustomers = false;
    update();
  }

  toggleShowRooms() {
    showRooms = !showRooms;
    update();
  }

  getRooms() async {
    var response = await _bookingRepository.getRooms();

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var roomList = body?["rows"];

      roomList = roomList?.where((element) =>
          element?["value"]?["isDeleted"] == null &&
          element?["value"]?["branch"]["_id"] == branchId);

      rooms = roomList.map<RoomModel>((u) {
        return RoomModel.fromJson(u);
      })?.toList();
      update();
    }
  }

  getCheckIn(context) async {
    showLoader(context);
    var response = await _checkInRepository.getCheckIn(invoiceNumber.text);
    if (response.statusCode == 200) {
      hideLoader();
      Get.back();
      scan = true;
      var body = jsonDecode(response.body);
      checkIn = CheckInModel.fromJson({"value": body});
      update();
      calculateTimeSpent(checkIn!);
      checkRemainingMoney(checkIn!);
    } else {
      hideLoader();
      Get.snackbar("CheckIn", "Please enter right invoice number",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  showLoader(context) {
    overlay_loader.Loader.show(context,
        isSafeAreaOverlay: false,
        isBottomBarOverlay: false,
        overlayFromBottom: 80,
        overlayColor: Colors.black26,
        progressIndicator: const Loader(),
        themeData: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.green)));
  }

  hideLoader() {
    overlay_loader.Loader.hide();
  }

  getCustomers(search) async {
    var query = search ?? searchTerm;
    var filters = 'start_key=%22$query%22&';
    var response = await _customerRepository.getCustomers(filters);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var customerList = body?["rows"];

      customers = customerList.map<CustomerModel>((u) {
        return CustomerModel.fromJson(u);
      })?.toList();

      // rooms.insert(0, all);
      // selectedRoom = rooms[0];

      update();
    }
  }

  getProducts() async {
    var response = await _productRepository.getProducts();

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var productList = body?["rows"];

      print("productList");
      print(productList);
      products = productList.map<ProductModel>((u) {
        return ProductModel.fromJson(u);
      })?.toList();
      update();
    }
  }

  getAddonProducts() async {
    var response = await _addonProductRepository.getAddonProducts();

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var productList = body?["rows"];

      print("addon productList");
      print(productList);
      addonProducts = productList.map<AddonProductModel>((u) {
        return AddonProductModel.fromJson(u);
      })?.toList();
      update();
    }
  }

  getPromoCodes() async {
    var response = await _promoCodeRepository.getPromoCodes();

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var promoList = body?["rows"];

      print("promoList");
      print(promoList);
      promoCodes = promoList.map<PromoCodeModel>((u) {
        return PromoCodeModel.fromJson(u);
      })?.toList();
      update();
    }
  }

  showScanDialog(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: const Text(
          'Please enter invoice number',
          style: TextStyle(color: primary),
        ),
        content: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            width: 300,
            child: TextFormField(
              controller: invoiceNumber,
              style: const TextStyle(color: background),
              decoration: InputDecoration(
                filled: true,
                fillColor: primaryDim,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Invoice Number',
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => getCheckIn(context),
            child: const Text(
              'Find',
              style: TextStyle(color: highlight),
            ),
          ),
        ],
      ),
    );
  }

  showPromoCodeDialog(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: Container(
          padding: const EdgeInsets.only(left: 70),
          child: Row(
            children: [
              const Text('SELECT A PROMOCODE',
                  style: TextStyle(color: success, fontSize: 25)),
              const SizedBox(
                width: 200,
              ),
              IconButton(
                iconSize: 35.0,
                padding: const EdgeInsets.only(top: 8.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.close_rounded,
                  color: primary,
                ),
                onPressed: () => Get.back(),
              )
            ],
          ),
        ),
        content: Container(
            width: 300,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(0),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: promoCodes
                        .map((promo) => _promoWrapper(context, promo))
                        .toList(),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _promoWrapper(context, promo) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 40, bottom: 100, left: 50),
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  if (promo.id == selectedPromoCode?.id) {
                    return highlight;
                  }
                  return Colors.black;
                }
                if (promo.id == selectedPromoCode?.id) {
                  return Colors.transparent;
                }
                return placeholder;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: BorderSide(
                  color: promo.id == selectedPromoCode?.id
                      ? highlight
                      : background,
                  // color: placeholder,
                  width: promo.id == selectedPromoCode?.id ? 3 : 2,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: () => selectPromoCode(promo),
        child: Text("${promo.code}",
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.w400, color: primary)),
      ),
    );
  }

  selectPromoCode(promo) {
    if (selectedProduct == null) {
      Get.snackbar("Promo code", "Please select product first",
          backgroundColor: Colors.red, colorText: Colors.white);
      Get.back();
      return;
    }
    selectedPromoCode = promo;
    double discount = price * double.parse(promo.value) / 100;
    price = price - discount;
    update();
    Get.back();
  }

  selectCustomer(customer) {
    selectedCustomer = customer;
    update();
  }

  selectRoom(room) {
    selectedRoom = room;
    update();
  }

  void next() {
    scrollTo(nextIndex);
    nextIndex++;
    prevIndex++;
    update();
  }

  void prev() {
    if (prevIndex != 0) {
      scrollTo(prevIndex);
      if (nextIndex != 1 || nextIndex != 2) {
        nextIndex--;
      }
      prevIndex--;
      update();
    }
  }

  void scrollTo(index) => scrollController.scrollTo(
      index: index,
      duration: scrollDuration,
      curve: Curves.easeInOutCubic,
      alignment: 0);

  showAddCustomerDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => GetBuilder<DashboardController>(
              builder: (controller) => AlertDialog(
                backgroundColor: surface,
                title: Container(
                  padding: const EdgeInsets.only(left: 80),
                  child: Row(
                    children: [
                      const Text('ADD NEW CUSTOMER',
                          style: TextStyle(color: success, fontSize: 25)),
                      const SizedBox(
                        width: 220,
                      ),
                      IconButton(
                        iconSize: 20.0,
                        padding: const EdgeInsets.only(top: 10.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: secondaryDim,
                        ),
                        onPressed: () => Get.back(),
                      )
                    ],
                  ),
                ),
                content: Container(
                  width: 550,
                  height: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: 400,
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          _nameField(context),
                          _children(context),
                          _phoneField(context),
                          _emailField(context),
                          _genderField(context),
                          _areaField(context),
                          _submitBtn(context)
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ));
  }

  showAddChildDialog(context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => GetBuilder<DashboardController>(
              builder: (controller) => AlertDialog(
                backgroundColor: surface,
                title: Container(
                  padding: const EdgeInsets.only(left: 80),
                  child: Row(
                    children: [
                      const Text('ADD NEW CHILD',
                          style: TextStyle(color: success, fontSize: 25)),
                      const SizedBox(
                        width: 100,
                      ),
                      IconButton(
                        iconSize: 20.0,
                        padding: const EdgeInsets.only(top: 10.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: secondaryDim,
                        ),
                        onPressed: () => Get.back(),
                      )
                    ],
                  ),
                ),
                content: Container(
                  width: 150,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: 150,
                    child: Form(
                      key: childrenFormKey,
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          _childrenForm(context),
                          Container(
                            width: 100,
                            height: 30,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return null;
                                      }
                                      return success; // Use the component's default.
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ))),
                              onPressed: () => addChild(context),
                              child: const Text("ADD",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                            ),
                          )
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ));
  }

  void _showIOSDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 250,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          childBirthDate =
                              "${val.year}-${val.month}-${val.day}";
                          update();
                          print(childBirthDate);
                        }),
                  ),
                ],
              ),
            ));
  }
  void showCheckInDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 250,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          checkInDate =
                              "${val.year}-${val.month}-${val.day}";
                          update();
                        }),
                  ),
                ],
              ),
            ));
  }
  void showCheckInTimePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 250,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          checkInTime = "${val.hour}:${val.minute}";
                          update();
                        }),
                  ),
                ],
              ),
            ));
  }

  Widget _childrenForm(context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(30.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(border: Border.all(color: primaryDim)),
      child: Column(
        children: [
          _childNameField(context),
          _childBirthDateField(context),
        ],
      ),
    );
  }

  Widget _nameField(context) {
    return Row(
      children: [
        Container(
          width: 250,
          padding: const EdgeInsets.only(left: 100),
          child: const Text(
            "NAME",
            style: TextStyle(color: primary, fontSize: 20),
          ),
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: username,
            style: const TextStyle(color: primary),
            decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryDim),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryDim),
                ),
                labelText: 'Name',
                labelStyle: TextStyle(color: primaryDim)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name field is required';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _children(context) {
    return Row(
      children: [
        Container(
          width: 250,
          padding: const EdgeInsets.only(left: 100),
          child: const Text(
            "Children",
            style: TextStyle(color: primary, fontSize: 20),
          ),
        ),
        Row(
          children: [
            children.length > 0
                ? Container(
                    width: 230,
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(border: Border.all(color: primaryDim)),
                    child: Column(
                      children: children.map((e) {
                        var index = children.indexOf(e);
                        return SizedBox(
                          width: 210,
                          child: Row(
                            children: [
                              Container(
                                  width: 150,
                                  padding: const EdgeInsets.only(
                                      left: 45.0, top: 10.0, bottom: 10.0),
                                  margin: const EdgeInsets.only(
                                      left: 10.0, top: 8.0, bottom: 10.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primaryDim)),
                                  child: Text(e['name'],
                                      style:
                                          const TextStyle(color: primaryDim))),
                              IconButton(
                                iconSize: 15.0,
                                padding: const EdgeInsets.only(top: 8.0),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                icon: const Icon(
                                  Icons.remove,
                                  color: highlight,
                                ),
                                onPressed: () => removeChild(index, context),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : SizedBox(
                    width: 0,
                  ),
            IconButton(
                onPressed: () => showAddChildDialog(context),
                icon: const Icon(
                  Icons.add,
                  color: highlight,
                ))
          ],
        )
      ],
    );
  }

  Widget _childNameField(context) {
    return Row(
      children: [
        Container(
          width: 100,
          padding: const EdgeInsets.only(left: 20),
          child: const Text(
            "CHILD NAME",
            style: TextStyle(color: primary, fontSize: 15),
          ),
        ),
        SizedBox(
          width: 150,
          height: 30,
          child: TextFormField(
            controller: childName,
            style: const TextStyle(color: primary, fontSize: 15),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryDim),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryDim),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: 'Child Name',
              labelStyle: TextStyle(color: primaryDim, fontSize: 15),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name field is required';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _childBirthDateField(context) {
    return Row(
      children: [
        Container(
          width: 100,
          padding: const EdgeInsets.only(left: 20),
          child: const Text(
            "Date of Birth",
            style: TextStyle(color: primary, fontSize: 15),
          ),
        ),
        SizedBox(
            width: 150,
            child: GestureDetector(
              onTap: () => _showIOSDatePicker(context),
              child: Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1.0, color: primaryDim))),
                  child: Text(
                    childBirthDate,
                    style: const TextStyle(color: primaryDim),
                  )),
            ))
      ],
    );
  }

  Widget _phoneField(context) {
    return Row(
      children: [
        Container(
          width: 250,
          padding: const EdgeInsets.only(left: 100),
          child: const Text(
            "PHONE NUMBER",
            style: TextStyle(color: primary, fontSize: 20),
          ),
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: phoneNumber,
            style: const TextStyle(color: primary),
            decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryDim),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryDim),
                ),
                labelText: 'PHONE NUMBER',
                labelStyle: TextStyle(color: primaryDim)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone Number field is required';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _emailField(context) {
    return Row(
      children: [
        Container(
          width: 250,
          padding: const EdgeInsets.only(left: 100),
          child: const Text(
            "EMAIL",
            style: TextStyle(color: primary, fontSize: 20),
          ),
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: email,
            style: const TextStyle(color: primary),
            decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryDim),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryDim),
                ),
                labelText: 'EMAIL',
                labelStyle: TextStyle(color: primaryDim)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email field is required';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _genderField(context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.only(left: 100),
            child: const Text(
              "Gender",
              style: TextStyle(color: primary, fontSize: 20),
            ),
          ),
          Container(
            width: 200,
            height: 60,
            child: DropdownButton(
              dropdownColor: drawer,
              value: 'Male',
              icon: const Icon(Icons.keyboard_arrow_down, color: secondary),
              elevation: 16,
              style: const TextStyle(color: secondary),
              underline: Container(
                padding: const EdgeInsets.only(top: 70),
                height: 1,
                color: primaryDim,
              ),
              onChanged: (String? value) => selectGender(value),
              selectedItemBuilder: (BuildContext context) {
                return genders.map<Widget>((item) {
                  return Container(
                    margin: const EdgeInsets.only(right: 70),
                    alignment: Alignment.centerLeft,
                    constraints: const BoxConstraints(minWidth: 100),
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15, color: primary),
                    ),
                  );
                }).toList();
              },
              items: genders.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem(
                  alignment: Alignment.centerLeft,
                  value: item,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item,
                        style: const TextStyle(color: primary),
                      ),
                      const Divider(
                        color: primary,
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _areaField(context) {
    return Row(
      children: [
        Container(
          width: 250,
          padding: const EdgeInsets.only(left: 100),
          child: const Text(
            "AREA",
            style: TextStyle(color: primary, fontSize: 20),
          ),
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: area,
            style: const TextStyle(color: primary),
            decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryDim),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryDim),
                ),
                labelText: 'AREA',
                labelStyle: TextStyle(color: primaryDim)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Area field is required';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _submitBtn(context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: 150,
      height: 70,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return null;
                }
                return success; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ))),
        onPressed: () => createCustomer(context),
        child: const Text("CREATE",
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
      ),
    );
  }

  addChild(context) {
    if (childName.text == '') {
      Get.snackbar("Add Child", "Please enter child name!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    children.add({
      "name": childName.text,
      "birth_date": childBirthDate,
    });
    childName.text = '';
    childBirthDate = '';
    update();
    Get.back();
  }

  removeChild(index, context) {
    children.removeAt(index);
    update();
  }

  createCustomer(context) async {
    if (username.text == '') {
      Get.snackbar("Create Customer", "Please enter customer name!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (phoneNumber.text == '') {
      Get.snackbar("Create Customer", "Please enter customer phone number!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    showLoader(context);
    var data = {
      "name": username.text,
      "phone": phoneNumber.text,
      "email": email.text,
      "gender": gender,
      "area": area.text,
      "children": children,
    };
    var response = await _customerRepository.createCustomer(data);

    if (response.statusCode == 201) {
      hideLoader();
      Get.back();
      Get.snackbar("Create Customer", "Customer created successfully",
          backgroundColor: success, colorText: Colors.white);
      await getCustomers(phoneNumber.text);
      searchTerm.text = phoneNumber.text;
      update();
    } else {
      hideLoader();
      Get.snackbar("Create Customer", "Something went wrong!",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  selectGender(value) {}

  changeRoom(value) async {
    selectedRoom = rooms.firstWhere((element) => element.id == value);
    update();

    await getBookings();
  }

  getBookings() async {
    String filter = '';
    allBookings = [];
    bookings = [];
    page = 1;
    loading = true;
    pages = 0;
    update();

    var startDateMoment =
        DateTime(startDate.year, startDate.month, startDate.day, 12)
            .add(const Duration(hours: 3))
            .toUtc()
            .millisecondsSinceEpoch
            .toString();
    var endDateMoment = DateTime(endDate.year, endDate.month, endDate.day, 24)
        .add(const Duration(hours: 3))
        .toUtc()
        .millisecondsSinceEpoch
        .toString();

    if (selectedRoom?.name == "All") {
      filter =
          '?startkey=[%22$branchId%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22$endDateMoment%22]';
    } else {
      filter =
          '?startkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$endDateMoment%22]';
    }

    var response = await _bookingRepository.getBookingsByDate(filter);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var bookingList = body?["rows"];

      allBookings = bookingList
          ?.map<BookingModel>((u) => BookingModel.fromJson(u))
          ?.toList();

      pages = (allBookings.length / perPage).round();

      if (pages > 1) {
        bookings = getCurrentData(allBookings);
      } else {
        bookings = allBookings;
      }
      loading = false;

      update();
    }
  }

  search(value) {
    searchBookings = allBookings
        .where((booking) =>
            booking.id.contains(value) || booking.userPhone.contains(value))
        .toList();
    if (searchBookings.isNotEmpty && searchBookings.length > perPage) {
      bookings = getCurrentData(searchBookings);
    } else {
      bookings = searchBookings;
    }
    update();
  }

  updatePage(type) {
    if ((page - 1 == 0 && type == 'prev') ||
        (type == 'next' && page + 1 == pages)) {
      return;
    }
    page = type == 'next' ? page + 1 : page - 1;
    update();

    bookings = getCurrentData(
        searchBookings.isNotEmpty ? searchBookings : allBookings);
    update();
  }

  List<BookingModel> getCurrentData(allData) {
    var currentIndex = (page * perPage);
    List<BookingModel> data = [];
    for (var x = 0; x < pages; x++) {
      if (page == x + 1) {
        for (var i = 0; i < perPage; i++) {
          data.add(allData[currentIndex]);
          currentIndex++;
        }
      }
    }
    return data;
  }

  nextDate() {
    endDate = endDate.add(const Duration(days: 1));
    update();
    getBookings();
  }

  prevDate() {
    startDate = startDate.subtract(const Duration(days: 1));
    update();
    getBookings();
  }

  pickDateRange(DateTimeRange? picked) {
    startDate = picked?.start as DateTime;
    endDate = picked?.end as DateTime;
    update();
    getBookings();
  }
}

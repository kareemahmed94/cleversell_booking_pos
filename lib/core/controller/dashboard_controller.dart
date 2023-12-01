import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
import 'package:cleversell_booking/ui/widgets/dashboard/staff_admin_dialog.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../core/data/model/booking.dart';
import '../../core/data/model/room.dart';
import '../../core/data/repository/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/widgets/common/loader.dart';
import '../constants/route_names.dart';
import '../constants/urls.dart';
import '../data/model/addon_product.dart';
import '../data/model/branch.dart';
import '../data/model/check_out.dart';
import '../data/repository/check_in_repository.dart';
import '../data/repository/product_repository.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart'
    as overlay_loader;
import 'package:barcode_image/barcode_image.dart' as barcode_image;

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
  TextEditingController paymentAmount = TextEditingController();
  TextEditingController refundAmount = TextEditingController();
  CheckInModel? checkIn;
  CheckOutModel? checkOut;
  int prevIndex = 0;
  int nextIndex = 1;
  bool scan = false;
  String timeSpent = '';
  String timeSpentString = '';
  String timeSpentInHours = '';
  String timeSpentInMinutes = '';
  String moneyDiff = '';
  bool showCustomers = false;
  bool showRooms = false;
  bool showProducts = false;
  bool showAddonProducts = false;
  bool inAdvance = false;
  bool fullPayment = true;
  bool showPayment = false;
  int addonQuantity = 0;
  ScrollController formScrollController = ScrollController();
  CustomerModel? selectedCustomer;
  ProductModel? selectedProduct;
  List<dynamic> selectedAddonProducts = [];
  PromoCodeModel? selectedPromoCode;
  List<dynamic> calendar = [];
  final staffId = TextEditingController();
  final password = TextEditingController();
  String adminAction = '';
  String refundType = '';

  Future<dynamic> _customerForm(context, {customer}) => showDialog(
      context: context,
      builder: (BuildContext context) => GetBuilder<DashboardController>(
            builder: (controller) => AlertDialog(
              backgroundColor: surface,
              title: Container(
                padding: const EdgeInsets.only(left: 80),
                child: Row(
                  children: [
                    Text(editCustomer ? 'UPDATE CUSTOMER' : 'ADD NEW CUSTOMER',
                        style: const TextStyle(color: success, fontSize: 25)),
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
                        _submitBtn(context, customer: customer)
                      ],
                    )),
                  ),
                ),
              ),
            ),
          ));

  var doNfocusNode = FocusNode();
  var doPFocusNode = FocusNode();

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
  final doName = TextEditingController();
  final doPhone = TextEditingController();
  final deposit = TextEditingController();
  String bookingType = "check_in";
  String childBirthDate = "";
  String checkInDateTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  // String checkInDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // String checkInTime = DateFormat('HH:mm:ss').format(DateTime.now());
  String checkInDate = '';
  String checkInTime = '';

  int page = 1;
  int perPage = 8;
  int pages = 0;
  double price = 0;
  String? branchId = '';

  bool loading = true;
  bool newCheckIn = true;
  bool showChildrenForm = false;
  bool printerConnected = false;
  List<dynamic> children = [];
  bool reservationNotCheckedIn = false;
  bool editCustomer = false;

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
    deposit.text = '0';
    generateCalendar();
    await checkPrinter();
    await getRooms();
    await getBookings();
    await getCustomers('');
    await getProducts();
    await getPromoCodes();
    await getBranches();
    await getStaff();
    await getAddonProducts();

    super.onInit();
  }

  showPaymentInfo() {
    showPayment = !showPayment;
    update();
  }

  changeType(String type) {
    if (checkIn != null) {
      return;
    }
    bookingType = type;
    update();
  }

  generateCalendar() async {
    print('calendar');
    // print(DateFormat);

    var currentHour = DateFormat.H().format(DateTime.now());
    var addHours = 24 - int.parse(currentHour);
    var h = 3;
    var data = await getTodayBookings();

    if (data.isNotEmpty) {
      for (var x = 0; x < 24; x++) {
        var time = DateFormat.jm().format(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day, h));
        var items = data.map((item) =>
            DateTime.parse(item.time).add(const Duration(hours: 3)).hour == h);
        calendar.add({
          "time": {
            "start_value": "$h:00",
            "end_value": "$h:59",
            "text": time,
            "is_active": h >= int.parse(currentHour)
          },
          "data": items
        });
        h++;
      }
    }

    print(calendar);
  }

  getTodayBookings() async {
    var now = DateTime.now();
    var endHour = now.hour;
    var endMin = now.minute;
    var endDay = endDate.day;
    var startDateMoment = DateTime(now.year, now.month, now.day, 12)
        .add(const Duration(hours: 3))
        .toUtc()
        .millisecondsSinceEpoch
        .toString();

    // var endDiff = DateTime(endDate.year, endDate.month, endDate.day).difference(DateTime(now.year, now.month, now.day )).inDays;
    // if (endDiff != 0) {
    //   endHour = 03;
    //   endMin = 00;
    //   endDay = endDate.day + 1;
    // }

    var endDateMoment = DateTime(endDate.year, endDate.month, now.day + 1, 2)
        .add(const Duration(hours: 3))
        .toUtc()
        .millisecondsSinceEpoch
        .toString();

    var filter =
        '$checkInsLisPath?startkey=[%22$branchId%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22$endDateMoment%22]';
    var response = await _checkInRepository.getCheckInsByDate(filter);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var checkInList = body?["rows"];
      return checkInList;
      // update();
    }
    return [];
  }

  checkPrinter() async {
    String? printerIp = prefs?.get("printer_ip").toString();
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    // if (printerIp != null && printerIp != '') {
    // final PosPrintResult res = await printer.connect(printerIp, port: 9100);
    final PosPrintResult res = await printer.connect('192.168.1.9', port: 9100);

    if (res == PosPrintResult.success) {
      printerConnected = true;
    }
    // }

    printerConnected = false;
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

  bool checkInAdvance() {
    final checkIn = this.checkIn;
    if (checkIn != null) {
      return checkIn.inAdvance && checkIn.checkedIn;
    }
    return false;
  }

  bool isBookingTypeActive(String type) {
    if (checkIn == null) {
      return bookingType == type;
    } else {
      return type == checkIn?.type;
    }
  }

  updateInAdvance(value) {
    inAdvance = value;
    update();
  }

  calculateTimeSpent(CheckInModel checkIn) {
    print("checkIn.checkedIn");
    print(checkIn.checkedIn);
    var to = DateTime.now().toLocal();

    if (checkIn.checkedOut) {
      to = DateTime.parse("${checkIn.checkOutDate} ${checkIn.checkOutTime}");
    }
    var from = DateTime.parse('${checkIn.checkInDate} ${checkIn.checkInTime}');
    print(from);
    print(to);
    Duration difference = to.difference(from);
    timeSpent = roundDouble(difference.inMinutes / 60, 1).toString();
    timeSpentInHours = (difference.inHours % 24).toString();
    timeSpentInMinutes = (difference.inMinutes % 60).toString();
    timeSpentString =
        '$timeSpentInHours Hours ${int.parse(timeSpentInMinutes) > 0 ? ' $timeSpentInMinutes Minutes' : ''}';
    print(timeSpent);

    update();
    return (to.difference(from).inHours / 24).round();
  }

  String calculatePrice() {
    num price = 0;
    // if (checkIn != null && checkIn!.checkedOut) {
    //   return '${checkIn?.paid}';
    // }
    if (selectedProduct != null) {
      var productsCost = int.parse(quantity.text) *
          (selectedProduct != null
              ? double.parse('${selectedProduct?.price}')
              : 0);
      price = productsCost;
      if (selectedPromoCode != null && checkIn == null) {
        double discount =
            price * double.parse("${selectedPromoCode?.value}") / 100;
        price = price - discount;
      }
    }
    if (selectedAddonProducts.isNotEmpty) {
      num addonProductsCost = 0;
      for (var i = 0; selectedAddonProducts.length > i; i++) {
        var quantity = selectedAddonProducts[i]['quantity'];
        var prod = selectedAddonProducts[i]['product'];
        addonProductsCost += quantity * double.parse('${prod?.price}');
      }
      price = price + addonProductsCost;
    }
    if (moneyDiff != '') {
      price = price + double.parse(moneyDiff);
    }
    if (selectedPromoCode != null) {
      price =
          price - (price * (int.parse('${selectedPromoCode?.value}') / 100));
    }
    return price.toString();
  }

  bool checkCheckedOut() {
    if (checkIn != null && checkIn!.checkedOut) {
      return true;
    }
    return false;
  }

  bool checkCheckInBtn(type) {
    if (checkIn != null && checkIn!.payments![0]['method'] == type) {
      return true;
    }
    return false;
  }

  String calculateAddonsPrice() {
    num addonProductsCost = 0;
    for (var i = 0; selectedAddonProducts.length > i; i++) {
      var quantity = selectedAddonProducts[i]['quantity'];
      var prod = selectedAddonProducts[i]['product'];
      addonProductsCost += quantity * double.parse('${prod?.price}');
    }
    return addonProductsCost.toString();
  }

  String calculateCheckInAddonCost(checkIn) {
    num addonProductsCost = 0;
    for (var i = 0; checkIn.addons.length > i; i++) {
      var quantity = checkIn.addons[i]['quantity'];
      var price = checkIn.addons[i]['price'];
      addonProductsCost += int.parse('$quantity') * double.parse('$price');
    }
    return addonProductsCost.toString();
  }

  bool checkProdInSelectedAddons(product) {
    var found = selectedAddonProducts
        .firstWhereOrNull((e) => e['product'].id == product.id);
    return found != null;
  }

  bool checkSelectedAddonProduct() {
    var found =
        selectedAddonProducts.firstWhereOrNull((e) => e['quantity'] != 0);
    return found != null;
  }

  double roundDouble(value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  checkRemainingMoney(CheckInModel checkIn) {
    moneyDiff = '';
    var productName = checkIn.productName;

    var checkInProduct =
        products.firstWhere((element) => element.id == checkIn.productId);
    var productHours = checkInProduct.period;

    var spent = double.parse(timeSpent) > double.parse(timeSpent).round()
        ? double.parse(timeSpent).round() + 1
        : double.parse(timeSpent).round();
    print(double.parse(timeSpent).round());
    // print(double.parse(productHours!).round());
    print("time");
    print(spent);
    if (spent > double.parse(productHours!).round()) {
      if (productName == 'Full Day') {
        moneyDiff = '';
        update();
        return;
      }
      for (var product in products) {
        bool check = false;
        if (product.period == '1') {
          check = double.parse(timeSpent) <= 1;
        } else if (product.period == '2') {
          check = double.parse(timeSpent) > 1 && double.parse(timeSpent) <= 2;
        } else if (product.period == '3') {
          check = double.parse(timeSpent) > 2 && double.parse(timeSpent) <= 3;
        } else {
          check = double.parse(timeSpent) > 3;
        }
        if (check) {
          print("product");
          print(product);
          var price = double.parse('${product.price}');
          if (checkIn.promoCode != null) {
            price = price -
                (price * (int.parse('${checkIn.promoCodeValue}') / 100));
          }
          if (double.parse('${checkIn.productPrice}') < price) {
            moneyDiff = ((price - double.parse('${checkIn.productPrice}')) *
                    int.parse('${checkIn.quantity}'))
                .toString();
          }
        }
      }
      if (selectedPromoCode != null &&
          (checkIn.promoCodeValue == null || checkIn.promoCodeValue == '')) {
        double discount = double.parse(moneyDiff) *
            double.parse('${selectedPromoCode!.value}') /
            100;
        moneyDiff = (double.parse(moneyDiff) - discount).toString();
      }
      update();
    } else if (spent < double.parse(productHours).round()) {
      var spentHours = roundDouble(double.parse(timeSpent), 1);

      var prod = products.firstWhere((element) {
        if (element.period != null) {
          var productPeriod = int.parse("${element.period}");
          if (spentHours <= productPeriod) {
            return true;
          }
        } else {
          return true;
        }
        return false;
      });
      var purchasedProductQPrice = double.parse(checkIn.productPrice!) * int.parse(checkIn.quantity!);
      var productQPrice = double.parse(prod.price!) * int.parse(checkIn.quantity!);

      print("prod");
      print(prod.name);
      print(prod.period);
      print("spentHours");
      print(spentHours);
      print("'${prod.price}'");
      print('${prod.price}');
      print("productQPrice");
      print(productQPrice);


      moneyDiff =  (productQPrice - purchasedProductQPrice).toString();
      return;
    }
  }

  getAddonCostDiff(checkIn) {
    var currentAddonsCost = calculateAddonsPrice();
    var checkInAddonCost = calculateCheckInAddonCost(checkIn);
    return (double.parse(currentAddonsCost) - double.parse(checkInAddonCost))
        .toString();
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

  showConfirmPaymentDialog(type, context) {
    Get.back();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: const Text(
          'Customer Will Pay Now?',
          style: TextStyle(color: primary),
        ),
        content: Container(
          height: 70,
          child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 120,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => showPaymentDialog(type, context),
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text("YES",
                                  style: TextStyle(
                                      fontSize: 20.0, color: primary)),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => submitCheckIn(type, context),
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text("NO",
                                  style: TextStyle(
                                      fontSize: 20.0, color: primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  showStaffAdminDialog(context) {
    return staffAdminDialog(this, context);
  }

  confirmStaffAdmin(context) async {
    if (loading == true) {
      return;
    }
    loading = true;
    update();
    if (staffId.text == '') {
      loading = false;
      update();
      Get.snackbar("Login", "Please enter staff id",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (password.text == '') {
      loading = false;
      update();
      Get.snackbar("Login", "Please enter password",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    var branchId = prefs?.getString("branch");
    String passwordValue = password.text;
    String staffIdValue = staffId.text;
    var response =
        await _staffRepository.login(branchId, staffIdValue, passwordValue);

    if (response?.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body["rows"]?.length > 0) {
        loading = false;
        update();
        print(jsonEncode(body["rows"][0]));
        var staffMember = body["rows"][0];
        StaffModel selectedStaffMember = StaffModel.fromJson(staffMember);

        if (selectedStaffMember != null && selectedStaffMember.canRefund!) {
          Get.back();
          if (adminAction == 'promocode') {
            return showPromoCodeDialog(context);
          } else {
            confirmRefund(context, refundType);
            // refund(refundType, context);
            return;
          }
        }
        // prefs?.setString("staff", jsonEncode(selectedStaffMember));
        // Get.toNamed(dashboardRoute);
      } else {
        loading = false;
        update();
        Get.snackbar("Login", "Wrong Credentials",
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    }
    loading = false;
    update();
    return;
  }

  showPaymentDialog(type, context) {
    Get.back();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: const Text(
          'Please Enter The Amount?',
          style: TextStyle(color: primary),
        ),
        content: Container(
          height: 150,
          child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 200,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      controller: paymentAmount,
                      style: const TextStyle(color: background),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: primaryDim,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Amount',
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => submitCheckIn(type, context),
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text("YES",
                                  style: TextStyle(
                                      fontSize: 20.0, color: primary)),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text("NO",
                                  style: TextStyle(
                                      fontSize: 20.0, color: primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  checkRefund(type, context) {
    if (refundAmount.text == '') {
      Get.snackbar("Refund", "Please Put Refund Amount",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    refundType = type;
    update();
    var staffUser = jsonDecode("${prefs?.get("staff")}");
    print("staffUser");
    print(staffUser);
    var staff = StaffModel.fromJson(staffUser);

    print(staff);
    if (staff.canRefund!) {
      return confirmRefund(context, type);
    } else {
      return showStaffAdminDialog(context);
    }
  }

  confirmRefund(context, type) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: const Text(
          'Do You Want To Confirm This Refund?',
          style: TextStyle(color: primary),
        ),
        content: Container(
          height: 70,
          child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 120,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => refund(type, context),
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text("YES",
                                  style: TextStyle(
                                      fontSize: 20.0, color: primary)),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text("NO",
                                  style: TextStyle(
                                      fontSize: 20.0, color: primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  validateCheckIn() {
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
    if (doName.text == '') {
      Get.snackbar("Check In", "Drop off customer name can't be empty!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (doPhone.text == '') {
      Get.snackbar("Check In", "Drop off customer phone can't be empty!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (quantity.text == '0') {
      Get.snackbar("Check In", "Quantity can't be 0",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedProduct == null) {
      Get.snackbar("Check In", "Please select product first",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (bookingType == 'reservation' && checkInDateTime == '') {
      Get.snackbar("Check In", "Please select date first",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
  }

  validateProductCheckIn() {
    if (selectedCustomer == null) {
      Get.snackbar("Check In", "Please select customer first",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
  }

  confirmSubmitCheckIn(type, context) {
    bool showCheckInConfirm = true;
    String remainingHours = '';
    if (checkIn != null) {
      if (checkIn?.type == 'product'){
        return;
      }
      calculateTimeSpent(checkIn!);
      checkRemainingMoney(checkIn!);
      var productName = checkIn?.productName;
      var productHours = '';

      if (productName!.contains('Hours')) {
        productHours = productName.replaceAll(' Hours', '');
      } else {
        productHours = productName.replaceAll(' Hour', '');
      }

      // if (double.parse(timeSpent) >= double.parse(productHours)) {
      if (moneyDiff == '') {
        showCheckInConfirm = true;
      } else {
        showCheckInConfirm = false;
      }
    }
    if (checkIn != null && checkIn!.checkedOut) {
      return;
    }
    if (checkIn != null && checkIn!.type == 'reservation') {
      var reservationDateTime =
          DateTime.parse('${checkIn?.reserveDate} ${checkIn?.reserveTime}');
      var to = DateTime.now().toLocal();
      print(reservationDateTime);
      print(to);
      var diff = to.difference(reservationDateTime).inMinutes;
      if (diff < 0) {
        Get.snackbar("Check In", "This reservation hasn't started yet!",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    }
    if (bookingType == 'product') {
      validateProductCheckIn();
    } else {
      validateCheckIn();
    }

    var title = bookingType == 'product'
        ? 'Payment'
        : checkIn != null
            ? 'Check Out'
            : 'Check In';
    var userTimeSpent = '${timeSpentInHours} Hours';
    userTimeSpent +=
        timeSpentInMinutes != '0' ? ' and ${timeSpentInMinutes} Minutes' : '';
    var text = showCheckInConfirm
        ? 'DO you want to confirm this ${title}?'
        : 'This User Spent ${userTimeSpent} And Remaining ${remainingHours} Payment will be ${moneyDiff} Do you want to confirm Check Out?';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: Text(
          text,
          style: TextStyle(color: primary),
        ),
        content: Container(
          height: 70,
          child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 120,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          if (reservationNotCheckedIn) {
                            showConfirmPaymentDialog(type, context);
                          } else {
                            submitCheckIn(type, context);
                          }
                        },
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text("YES",
                                  style: TextStyle(
                                      fontSize: 20.0, color: primary)),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text("NO",
                                  style: TextStyle(
                                      fontSize: 20.0, color: primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  checkForCheckInReservation() {
    if (checkIn != null) {
      return true;
    }
    return false;
  }

  submitCheckIn(type, context) async {
    showLoader(context);
    var timestamps = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    var id = checkIn == null ? generateBookingId() : checkIn?.id;
    var branchId = prefs?.get("branch");
    var staffId = jsonDecode("${prefs?.get("staff")}")['id'];
    var staff = staffUsers.firstWhere((user) => user.id == staffId);
    var branch = branches.firstWhere((bran) => bran.id == branchId);
    print('selectedCustomer');
    print(selectedCustomer?.id);
    var user = selectedCustomer?.toJson();
    print(user);
    var product = selectedProduct?.toJson();
    var room = selectedRoom?.toJson();
    var promo = selectedPromoCode != null ? selectedPromoCode?.toJson() : {};
    var time = DateFormat('HH:mm:ss').format(DateTime.now());
    var date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    print(checkInDateTime);
    var reservation = null;

    if (bookingType == 'reservation') {
      var reservationDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(checkInDateTime));
      var reservationTime =
          DateFormat('HH:mm:ss').format(DateTime.parse(checkInDateTime));
      reservation = {
        "time": reservationTime,
        "date": reservationDate,
      };
    }

    List<dynamic> pay = [];
    List<dynamic> addons = [];
    if (selectedAddonProducts.isNotEmpty) {
      for (var item in selectedAddonProducts) {
        addons.add({
          '_id': item['product'].id,
          'name': item['product'].name,
          'quantity': item['quantity'].toString(),
          'price': item['product'].price
        });
      }
    }

    print('product');
    print(product);
    if (checkIn == null) {
      if (bookingType == 'product') {
        fullPayment = true;
        update();
      }
      if (fullPayment) {
        pay.add({
          "amount": calculatePrice(),
          "method": type,
          "type": 'full_payment',
          "Date": timestamps,
          "serial": getRandomString(9)
        });
      } else {
        if (deposit.text != '' && deposit.text != '0') {
          pay.add({
            "amount": deposit.text,
            "method": type,
            "type": 'deposit',
            "Date": timestamps,
            "serial": getRandomString(9)
          });
        }
      }
    } else {
      pay = checkIn?.payments as List<dynamic>;
      if (moneyDiff != null && moneyDiff != '') {
        pay.add({
          "amount": moneyDiff,
          "method": type,
          "type": 'diff',
          "Date": timestamps,
          "serial": getRandomString(9)
        });
      }
      if (paymentAmount.text != '') {
        pay.add({
          "amount": paymentAmount.text,
          "method": type,
          "type": 'check_in_amount',
          "Date": timestamps,
          "serial": getRandomString(9)
        });
      }
    }

    var checkInDate = bookingType == 'reservation' && checkIn == null
        ? null
        : {
            "time": bookingType == 'reservation' ? time : checkInTime,
            "date": date,
          };
    var checkOutDate = (bookingType == 'reservation' && checkIn == null) ||
            (bookingType == 'reservation' &&
                checkIn != null &&
                !checkIn!.checkedIn) ||
            (bookingType == 'check_in' && checkIn == null)
        ? null
        : {
            "time": time,
            "date": date,
          };

    print("checkOutDate");
    print(checkOutDate);
    print((bookingType == 'reservation' && checkIn == null) ||
        (bookingType == 'reservation' &&
            checkIn != null &&
            !checkIn!.checkedIn));
    var dropOff = {
      "name": doName.text,
      "phone": doPhone.text,
    };

    var checkedIn =
        bookingType == 'reservation' && checkIn == null ? false : true;
    var checkedOut = checkIn != null && checkIn!.checkedIn ? true : false;

    var body = {
      "_id": id,
      "branch": branch.toJson(),
      "type": bookingType,
      "addOns": addons,
      "user": user,
      "reservation": bookingType == 'reservation' ? reservation : null,
      "check_in": checkInDate,
      "check_out": checkOutDate,
      "time": checkIn != null ? checkIn?.time : time,
      "date": checkIn != null ? checkIn?.date : date,
      "product": product,
      "room": room,
      "promo": promo,
      "quantity": quantity.text,
      "drop_off": dropOff,
      "staff": staff.toJson(),
      "paid": pay,
      "checked_in": checkedIn,
      "checked_out": checkedOut,
      "status": 1
    };

    print(pay);
    print(jsonEncode(body));
    if (checkIn != null) {
      body['_rev'] = checkIn?.rev;
    }
    print('body');
    print(body);
    // return;
    final response;
    if (checkIn == null) {
      print('we are here');
      response = await _checkInRepository.createCheckIn(body);
      print(response.statusCode);
    } else {
      print('we are here update');
      response = await _checkInRepository.updateCheckIn(body, id);
      print(response);
      print(response.statusCode);
    }

    if (response.statusCode == 201) {
      hideLoader();
      Get.snackbar("Check in", "Created successfully",
          backgroundColor: success, colorText: primary);

      body = {"value": body};

      // checkIn = null;
      // newCheckIn = false;
      // selectedPromoCode = null;
      // selectedProduct = null;
      // checkInTime = '';
      // checkInDate = '';
      // selectedAddonProducts = [];
      // selectedRoom = null;
      // selectedCustomer = null;
      // showCustomers = false;
      // showProducts = false;
      // inAdvance = false;
      // quantity.text = '0';
      // deposit.text = '0';
      // price = 0;
      checkIn = CheckInModel.fromJson(body);
      invoiceNumber.text = id;
      getCheckIn(context);
      // setCheckInValues(checkIn!);
      update();
    }
    Navigator.pop(context);
  }

  Form checkAdminForm(context) {
    return Form(
        child: Container(
      child: TextField(
        style: const TextStyle(fontSize: 20.0, height: 2.0, color: background),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          filled: true,
          fillColor: inputBackground,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: highlight, width: 10.0),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: highlight, width: 10.0),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: 'Type Here Amount',
        ),
      ),
    ));
  }

  refund(type, context) async {
    // Get.back();
    showLoader(context);

    var timestamps = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    var id = checkIn == null ? generateBookingId() : checkIn?.id;
    var branchId = prefs?.get("branch");
    var staffId = jsonDecode("${prefs?.get("staff")}")['id'];
    var staff = staffUsers.firstWhere((user) => user.id == staffId);
    var branch = branches.firstWhere((bran) => bran.id == branchId);
    var user = selectedCustomer?.toJson();
    var product = selectedProduct?.toJson();
    var room = selectedRoom?.toJson();
    var promo = selectedPromoCode != null ? selectedPromoCode?.toJson() : {};
    var time = DateFormat('HH:mm:ss').format(DateTime.now());
    var date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    var pay = [
      ...?checkIn?.payments,
      {
        "amount": refundAmount.text,
        "method": type,
        "type": "refund",
        "Date": timestamps,
        "serial": getRandomString(9)
      }
    ];

    var body = {
      "_id": id,
      "_rev": checkIn?.rev,
      "branch": branch.toJson(),
      "type": bookingType,
      "addOns": checkIn?.addons,
      "user": user,
      "reservation": {
        "time": checkIn?.reserveTime,
        "date": checkIn?.reserveDate
      },
      "check_in": {"time": checkIn?.checkInTime, "date": checkIn?.checkInDate},
      "check_out": {
        "time": checkIn?.checkOutTime,
        "date": checkIn?.checkOutDate
      },
      "time": checkIn?.time,
      "date": checkIn?.date,
      "product": product,
      "room": room,
      "promo": promo,
      "quantity": checkIn?.quantity,
      "drop_off": {
        "name": checkIn?.dropOffName,
        "phone": checkIn?.dropOffPhone
      },
      "staff": staff.toJson(),
      "paid": pay,
      "checked_in": checkIn?.checkedIn,
      "checked_out": checkIn?.checkedOut,
      "status": 1,
      "refunded": true
    };

    final response = await _checkInRepository.updateCheckIn(body, id);
    print(response.statusCode);

    if (response.statusCode == 201) {
      hideLoader();
      Get.snackbar("Check in", "Created successfully",
          backgroundColor: success, colorText: primary);

      body = {"value": body};

      invoiceNumber.text = id;
      update();
    }
    Navigator.pop(context);
  }

  showTimeCalendar() {
    showCustomers = false;
    showProducts = false;
    showAddonProducts = false;
    update();
  }

  confirmSubmitCheckOut(type, context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: const Text(
          'DO you want to confirm this check out?',
          style: TextStyle(color: primary),
        ),
        content: Container(
          height: 100,
          child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 100,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => submitCheckOut(type, context),
                    child: Container(
                      width: 50,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Text("YES",
                              style: TextStyle(fontSize: 20.0, color: primary)),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Container(
                      width: 50,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Text("NO",
                              style: TextStyle(fontSize: 20.0, color: primary)),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  submitCheckOut(type, context) async {
    // testReceipt();
    // return;
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

    final checkInObj = checkIn!;
    bool checkedInValue = true;
    bool checkedOutValue = inAdvance && checkInObj.checkedIn ? true : false;

    if (moneyDiff != '') {
      pay = {
        "amount": moneyDiff,
        "method": type,
        "Date": timestamps,
        "serial": getRandomString(9)
      };
    }

    var dropOff = {
      "name": checkIn?.dropOffName,
      "phone": checkIn?.dropOffPhone,
    };
    var reservation = {
      "time": checkIn?.reserveTime,
      "date": checkIn?.reserveDate,
    };

    var checkInTime = {
      "time": checkIn?.checkInTime,
      "date": checkIn?.checkInDate,
    };

    var checkOutTime = {
      "time": checkedOutValue ? time : null,
      "date": checkedOutValue ? date : null,
    };
    var body = {
      "_id": id,
      "_rev": checkIn != null ? checkIn?.rev : null,
      "branch": branch.toJson(),
      "user": user,
      "time": time,
      "date": date,
      "reservation": reservation,
      "quantity": checkIn?.quantity,
      "drop_off": dropOff,
      "check_in": checkInTime,
      "check_out": checkOutTime,
      "product": product,
      "room": room,
      "promo": promo,
      "staff": staff.toJson(),
      "drop_off": dropOff,
      "in_advance": inAdvance,
      "checked_in": checkedInValue,
      "checked_out": checkedOutValue,
      "paid": pay != null ? [pay] : [],
      "status": 1
    };

    var checkInUpdate = checkIn?.toJson();
    checkInUpdate = body;
    var responseUpdate =
        await _checkInRepository.updateCheckIn(checkInUpdate, checkIn?.id);
    // body['check_in'] = checkInData;
    if (checkedOutValue) {
      await _checkInRepository.createCheckOut(body);
    }
    if (responseUpdate.statusCode == 201) {
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
      timeSpentInHours = '';
      timeSpentInMinutes = '';
      timeSpentString = '';
      checkIn = null;
      price = 0;
      checkOut = CheckOutModel.fromJson(body);
      update();
    }
    Navigator.pop(context);
    printInvoice();
  }

  confirmNewCheckIn(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: const Text(
          'Do you want to create new check in?',
          style: TextStyle(color: primary),
        ),
        content: Container(
          height: 100,
          child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 100,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      checkIn = null;
                      update();
                      initNewCheckIn(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Text("YES",
                              style: TextStyle(fontSize: 20.0, color: primary)),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Container(
                      width: 50,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Text("NO",
                              style: TextStyle(fontSize: 20.0, color: primary)),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  initNewCheckIn(context) {
    if (checkIn != null) {
      confirmNewCheckIn(context);
      return;
    }
    showPayment = false;
    newCheckIn = false;
    bookingType = 'check_in';
    checkIn = null;
    scan = false;
    price = 0;
    selectedRoom = null;
    showCustomers = false;
    selectedCustomer = null;
    searchTerm.text = '';
    doName.text = '';
    doPhone.text = '';
    quantity.text = '0';
    selectedProduct = null;
    selectedAddonProducts = [];
    checkInTime = '';
    checkInDate = '';
    checkInDateTime = '';
    inAdvance = false;
    selectedPromoCode = null;
    reservationNotCheckedIn = false;
    paymentAmount.text = '';
    deposit.text = '';
    fullPayment = true;
    moneyDiff = '';
    update();
  }

  updateFullPayment(value) {
    fullPayment = value;
    update();
    if (!value) {
      formScrollController.animateTo(650.0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  generateBookingId() {
    var newDate = DateTime.now()
        .toUtc()
        .millisecondsSinceEpoch
        .toString()
        .substring(0, 9);
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

    // price = double.parse(product.price);
    if (checkIn != null) {
      calculateTimeSpent(checkIn!);
    }
    update();
  }

  toggleShowCustomers() {
    if (checkIn != null) {
      return;
    }
    showCustomers = true;
    showProducts = false;
    showAddonProducts = false;
    update();
  }

  toggleShowProducts() {
    showProducts = true;
    showCustomers = false;
    showAddonProducts = false;
    update();
  }

  toggleShowAddonProducts() {
    showCustomers = false;
    showProducts = false;
    showAddonProducts = true;
    update();
  }

  removePromo() {
    if (checkIn != null && checkIn?.promoCodeValue != null) {
      return;
    }
    if (checkIn != null && checkIn!.checkedOut) {
      return;
    }
    selectedPromoCode = null;

    if (checkIn != null) {
      checkRemainingMoney(checkIn!);
    }
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

  String getTypeTitle(type) {
    if (type == 'check_in') {
      return 'Walk-In';
    } else if (type == 'reservation') {
      return 'Reservation';
    } else {
      return 'Product';
    }
  }

  getCheckIn(context) async {
    if (invoiceNumber.text == '') {
      return;
    }
    showLoader(context);
    var response = await _checkInRepository.getCheckIn(invoiceNumber.text);
    if (response.statusCode == 200) {
      hideLoader();
      Get.back();
      scan = true;
      var body = jsonDecode(response.body);
      print(body);
      checkIn = CheckInModel.fromJson({"value": body});
      inAdvance = checkIn?.inAdvance ?? false;
      // invoiceNumber.text = '';
      print(checkIn!.type);

      update();
      if (checkIn!.checkedIn && checkIn?.type != 'product') {
        calculateTimeSpent(checkIn!);
        checkRemainingMoney(checkIn!);
      }

      final checkInObj = checkIn!;
      // if (checkInObj.inAdvance && !checkInObj.checkedIn) {
      setCheckInValues(checkIn!);
      // }
    } else {
      hideLoader();
      Get.snackbar("CheckIn", "Please enter right invoice number",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  printInvoice() async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    String? printerIp = prefs?.get("printer_ip").toString();

    // String? printerIp = '192.168.1.9';
    // final PosPrintResult res = await printer.connect(printerIp, port: 9100);
    // final PosPrintResult res = await printer
    //     .connect('$printerIp', port: 9100)
    //     .timeout(const Duration(seconds: 3));
    final PosPrintResult res = await printer.connect('$printerIp', port: 9100);
    print('res');
    print(res.msg);
    if (res == PosPrintResult.success) {
      await testReceipt(printer, checkIn!);
      printer.disconnect();
    }
    print('Print result: ${res.msg}');
    // var _timer = Timer(const Duration(seconds: 10), () async {
    //   final PosPrintResult res = await printer
    //       .connect('$printerIp', port: 9100)
    //       .timeout(const Duration(seconds: 10));
    //   print('res');
    //   print(res.msg);
    //   if (res == PosPrintResult.success) {
    //     await testReceipt(printer, checkIn!);
    //     printer.disconnect();
    //   }
    //   print('Print result: ${res.msg}');
    // });
  }

  Future<void> testReceipt(
      NetworkPrinter printer, CheckInModel checkInItem) async {
    var request = await Permission.storage.request();

    var paymentSum = checkInItem.paid;
    var paymentMethod = checkInItem.payments!.isNotEmpty
        ? checkInItem.payments![0]['method']
        : 'cash';

    var branchName = checkInItem.branchName;
    var refund = '0';
    var customerName = checkInItem.customerName;
    var customerPhone = checkInItem.customerPhone;
    var total = checkInItem.price;
    var currentDate = checkInDate;
    var currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    var bookingDate = checkInItem.type == 'reservation'
        ? '${checkInItem.reserveDate} ${checkInItem.reserveTime}'
        : '${checkInItem.checkInDate} ${checkInItem.checkInTime}';

    var remaining = (double.parse(calculatePrice().toString()) -
            double.parse(checkInItem.paid.toString()))
        .toString();
    print("remaining");
    print(remaining);
    final imgLogo = image.Image(300, 150);
    image.fill(imgLogo, 000000);

    final Directory directory = await getApplicationDocumentsDirectory();

    final ByteData data =
        await rootBundle.load('assets/images/airzone-logo.png');
    if (data.lengthInBytes > 0) {
      final Uint8List imageBytes = data.buffer.asUint8List();
      final decodedImage = image.decodeImage(imageBytes)!;
      printer.image(decodedImage);
    }

    printer.text('$branchName',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('Booking',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.row([
      PosColumn(
        text: 'Customer',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: 'Drop Off',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.right),
      ),
    ]);
    printer.row([
      PosColumn(
        text: '$customerName',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '${checkInItem.dropOffName}',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.right),
      ),
    ]);
    printer.row([
      PosColumn(
        text: '$customerPhone',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '${checkInItem.dropOffPhone}',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.right),
      ),
    ]);

    printer.text('$paymentMethod',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('----------------------------------',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.row([
      PosColumn(
        text: 'Current Time',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '$currentTime',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.text('----------------------------------',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.row([
      PosColumn(
        text: 'Booking Date',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '$bookingDate',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.text('=====================================',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    if (checkIn?.productId != null) {
      printer.row([
        PosColumn(
          text: '${checkIn?.quantity} ${checkIn?.productName}',
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.center),
        ),
        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.center),
        ),
        PosColumn(
          text: (int.parse('${checkIn?.quantity}') *
                  double.parse('${checkIn?.productPrice}'))
              .toString(),
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.center),
        ),
      ]);
    }

    if (checkIn?.addons != null && checkIn!.addons!.isNotEmpty) {
      for (var prodAddon in checkIn!.addons!) {
        printer.row([
          PosColumn(
            text: '${prodAddon['quantity']} ${prodAddon['name']}',
            width: 6,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center),
          ),
          PosColumn(
            text: '',
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center),
          ),
          PosColumn(
            text: '${prodAddon['price']}',
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center),
          ),
        ]);
      }
    }
    printer.row([
      PosColumn(
        text: '',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '-----',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: calculatePrice(),
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.row([
      PosColumn(
        text: '',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '-----',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.row([
      PosColumn(
        text: 'Paid',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '${checkIn?.paid}',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);
    printer.row([
      PosColumn(
        text: '',
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
      PosColumn(
        text: '-----',
        width: 3,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center),
      ),
    ]);

    if (remaining != '') {
      printer.row([
        PosColumn(
          text: 'Remaining',
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.center),
        ),
        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.center),
        ),
        PosColumn(
          text: '$remaining',
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.center),
        ),
      ]);
    }

    printer.text('===========================================',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));

    printer.text('Prices include Taxes',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('CrNo.193591 / TaxCardNo.699452074',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    printer.text('                     ',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    // printer.text('#AW$serial',
    //     styles: const PosStyles(align: PosAlign.center,
    //         height: PosTextSize.size1, width: PosTextSize.size1));

    // barcode print
    final barcodeImg = image.Image(300, 150);
    image.fill(barcodeImg, 000000);
    barcode_image.drawBarcode(
        barcodeImg, barcode_image.Barcode.code128(), '${checkIn?.id}');

    // final Directory directory = await getApplicationDocumentsDirectory();
    final File barcodeFile = File('${directory.path}/barcode.png');
    barcodeFile.writeAsBytesSync(image.encodePng(barcodeImg));
    final barcodeBytes = barcodeFile.readAsBytesSync();

    final imgBarcode = image.decodeImage(barcodeBytes);
    print("imgBarcode");
    print(imgBarcode);
    printer.image(imgBarcode!, align: PosAlign.center);

    printer.feed(2);
    printer.cut();
  }

  setCheckInValues(CheckInModel checkIn) async {
    reservationNotCheckedIn = false;
    paymentAmount.text = '';
    // final sCustomer;

    // await getCustomers(checkIn.customerPhone);

    var query = checkIn.customerId;
    var filters = 'start_key=%22$query%22&';
    var response = await _customerRepository.getCustomer(filters);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var customerList = body?["rows"];
      selectedCustomer = CustomerModel.fromJson(customerList[0]);
    }

    if (checkIn.type != 'product') {
      selectedRoom = rooms.firstWhere((room) => room.id == checkIn.roomId);
      selectedProduct =
          products.firstWhere((product) => product.id == checkIn.productId);
      doName.text = checkIn.dropOffName.toString();
      doPhone.text = checkIn.dropOffPhone.toString();
      quantity.text = checkIn.quantity.toString();
      checkInDateTime = checkIn.type == 'reservation'
          ? '${checkIn.reserveDate} ${checkIn.reserveTime}'
          : '';
      deposit.text = checkIn.deposit.toString();
    }
    selectedPromoCode = checkIn.promoCodeId != null
        ? promoCodes.firstWhere((promo) => promo.id == checkIn.promoCodeId)
        : null;
    // deposit.text = checkIn.deposit != null ? checkIn.deposit.toString() : '0';
    bookingType = checkIn.type ?? 'check_in';
    if (checkIn.deposit != null &&
        checkIn.deposit.toString() != '' &&
        checkIn.deposit.toString() != '0') {
      print('full payment is false');
      print(checkIn.deposit);
      fullPayment = false;
    } else {
      fullPayment = true;
    }
    if (checkIn.addons != null && checkIn.addons!.isNotEmpty) {
      selectedAddonProducts = [];
      for (var addon in checkIn.addons!) {
        var quantity = int.parse(addon['quantity']);
        addon = {
          "value": {
            "_id": addon["_id"],
            "name": addon["name"],
            "price": addon["price"]
          }
        };
        var addonProduct = AddonProductModel.fromJson(addon);

        selectedAddonProducts
            .add({'quantity': quantity, 'product': addonProduct});
      }
    }

    if (checkIn.checkedIn && checkIn.type != 'product') {
      checkInDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse('${checkIn.checkInDate}'));
      checkInTime = DateFormat('HH:mm:ss').format(
          DateTime.parse('${checkIn.checkInDate} ${checkIn.checkInTime}'));
    } else {
      if (checkIn.type == 'reservation') {
        reservationNotCheckedIn = true;
      }
    }
    if (checkIn.type == 'product') {
      fullPayment = true;
    }

    update();
  }

  getCheckInDateTime() {
    if (checkIn != null) {
      if (checkIn!.type == 'reservation') {
        return '${checkIn?.reserveDate} ${checkIn?.reserveTime}';
      } else if (checkIn!.type == 'reservation') {
        return '${checkIn?.checkInDate} ${checkIn?.checkInTime}';
      } else {
        return '${checkIn?.date} ${checkIn?.time}';
      }
    }
    return '${checkIn?.time} ${checkIn?.date}';
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

  updateQuantity(type) {
    quantity.text = type
        ? (int.parse(quantity.text) + 1).toString()
        : (int.parse(quantity.text) - 1).toString();
    final checkIn = this.checkIn;
    if (checkIn != null) {
      checkIn.quantity = quantity.text;
      print(checkIn.quantity);
      checkRemainingMoney(checkIn);
    }
    update();
  }

  selectTime(time) {
    if (checkIn != null) {
      return;
    }
    var hour = time['time']['start_value'];
    int idx = hour.indexOf(":");
    List parts = [
      hour.substring(0, idx).trim(),
      hour.substring(idx + 1).trim()
    ];
    checkInTime = DateFormat('HH:mm:ss')
        .format(DateTime(now.year, now.month, now.day, int.parse(parts[0])));
    print(checkInTime);
    update();
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

      print("customers[0].id");
      print(customers[0].id);
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

      promoCodes = promoList.map<PromoCodeModel>((u) {
        return PromoCodeModel.fromJson(u);
      })?.toList();
      update();
    }
  }

  scanBarcode(context) async {
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.location,
    //   Permission.camera,
    //   //add more permission to request here.
    // ].request();
    // bool isShown = await Permission.camera.shouldShowRequestRationale;
    // print(statuses);
    // print(isShown);
    var request = await Permission.camera.request();
    print("isGranted: ${request.isGranted}");
    print("isRestricted: ${request.isRestricted}");
    print("isDenied: ${request.isDenied}");
    print("isLimited: ${request.isLimited}");
    print("isPermanentlyDenied: ${request.isPermanentlyDenied}");
    print(await Permission.camera.request());
    if (await Permission.camera.request().isDenied) {
      print('not granted');
      return;
    }
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ));
    if (res is String) {
      print('result');
      print(res);
      invoiceNumber.text = res != '-1' ? res : '';
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
          child: Row(
            children: [
              SizedBox(
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
              IconButton(
                icon: const Icon(
                  Icons.qr_code_scanner,
                  color: primary,
                  size: 30.0,
                ),
                tooltip: 'Increase volume by 10',
                onPressed: () => scanBarcode(context),
              ),
            ],
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

  confirmPromoCodeDialog(context) {
    if (checkIn != null && checkIn!.checkedOut) {
      return;
    }
    var staffUser = jsonDecode("${prefs?.get("staff")}");
    print("staffUser");
    print(staffUser);
    var staff = StaffModel.fromJson(staffUser);

    print(staff);
    if (staff.canRefund!) {
      return showPromoCodeDialog(context);
    } else {
      return showStaffAdminDialog(context);
    }
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
    if (selectedProduct == null && selectedAddonProducts.isEmpty) {
      Get.snackbar("Promo code", "Please select product first",
          backgroundColor: Colors.red, colorText: Colors.white);
      // Get.back();
      return;
    }
    selectedPromoCode = promo;
    if (checkIn != null) {
      checkRemainingMoney(checkIn!);
    }
    // double discount = price * double.parse(promo.value) / 100;
    // price = price - discount;
    update();
    Get.back();
  }

  selectAddonProduct(product) {
    var found = selectedAddonProducts.firstWhereOrNull((e) {
      print("e");
      print(e);
      return e['product'].id == product.id;
    });
    if (found != null) {
      selectedAddonProducts.removeWhere((e) => e['product'].id == product.id);
    } else {
      selectedAddonProducts.add({'quantity': 0, 'product': product});
    }
    if (checkIn != null) {
      checkRemainingMoney(checkIn!);
    }
    // selectedAddonProduct = product;
    // addonQuantity = 0;
    // double discount = price * double.parse(product.price) / 100;
    // price = price - discount;
    calculatePrice();
    update();
  }

  selectCustomer(CustomerModel customer) {
    if (checkIn != null) {
      return;
    }
    selectedCustomer = customer;
    doName.text = customer.name!;
    doPhone.text = customer.phone!;
    update();
  }

  updateAddonQuantity(product, type) {
    var item = selectedAddonProducts
        .firstWhere((element) => element['product'].id == product.id);
    var quantity = type ? item['quantity'] + 1 : item['quantity'] != 0 ? item['quantity'] - 1 : item['quantity'];
    var updatedProduct = {'quantity': quantity, 'product': product};
    selectedAddonProducts[selectedAddonProducts.indexWhere(
        (element) => element['product'].id == product.id)] = updatedProduct;
    if (checkIn != null) {
      checkRemainingMoney(checkIn!);
    }
    calculatePrice();
    update();
  }

  String getAddonProdQty(product) {
    if (selectedAddonProducts.isNotEmpty) {
      var item = selectedAddonProducts
          .firstWhere((element) => element['product'].id == product.id);
      return item != null ? item['quantity'].toString() : '0';
    }
    return '0';
  }

  openEditCustomerDialog(context, CustomerModel customer) {
    username.text = customer.name!;
    phoneNumber.text = customer.phone!;
    email.text = customer.email!;
    gender = customer.gender!;
    area.text = customer.area!;
    children = customer.children ?? [];
    editCustomer = true;
    update();
    _customerForm(context, customer: customer);
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

  checkPaymentIsDone() {
    if (checkIn != null) {
      return (checkIn!.checkedIn && checkIn!.checkedOut) || checkIn!.type == 'product';
    }
    return false;
  }

  showAddCustomerDialog(context) {
    username.text = '';
    phoneNumber.text = '';
    email.text = '';
    gender = 'Male';
    area.text = '';
    children = [];
    editCustomer = false;
    update();
    _customerForm(context);
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
                          checkInDate = "${val.year}-${val.month}-${val.day}";
                          update();
                        }),
                  ),
                ],
              ),
            ));
  }

  void showCheckInDateTimePicker(ctx) {
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
                        mode: CupertinoDatePickerMode.dateAndTime,
                        initialDateTime: checkInDateTime != ''
                            ? DateTime.parse(checkInDateTime)
                            : DateTime.now(),
                        onDateTimeChanged: (val) {
                          checkInDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(DateTime.parse(val.toString()));
                          update();
                        }),
                  ),
                ],
              ),
            ));
  }

  void showCheckInTimePicker(ctx) {
    print(DateTime.now());
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
                        initialDateTime: checkInTime != ''
                            ? DateTime.parse("$today ${checkInTime.toString()}")
                            : DateTime.now(),
                        onDateTimeChanged: (val) {
                          checkInTime = DateFormat('HH:mm:ss')
                              .format(DateTime.parse(val.toString()));
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

  Widget _submitBtn(context, {customer}) {
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
        onPressed: () => editCustomer
            ? updateCustomer(context, customer!)
            : createCustomer(context),
        child: Text(editCustomer ? "UPDATE" : "CREATE",
            style: const TextStyle(
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

  updateCustomer(context, CustomerModel customer) async {
    if (username.text == '') {
      Get.snackbar("Update Customer", "Please enter customer name!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (phoneNumber.text == '') {
      Get.snackbar("Update Customer", "Please enter customer phone number!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    showLoader(context);
    var data = {
      "_rev": customer.rev,
      "name": username.text,
      "phone": phoneNumber.text,
      "email": email.text,
      "gender": gender,
      "area": area.text,
      "children": children,
    };
    var response = await _customerRepository.updateCustomer(data, customer.id);

    if (response.statusCode == 201) {
      hideLoader();
      Get.back();
      Get.snackbar("Update Customer", "Customer updated successfully",
          backgroundColor: success, colorText: Colors.white);
      await getCustomers(phoneNumber.text);
      searchTerm.text = phoneNumber.text;
      update();
    } else {
      hideLoader();
      Get.snackbar("Update Customer", "Something went wrong!",
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

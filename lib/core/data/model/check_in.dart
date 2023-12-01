import 'dart:convert';
import 'dart:ffi';

List<CheckInModel> checkInModelFromJson(String str) => List<CheckInModel>.from(
    json.decode(str).map((x) => CheckInModel.fromJson(x)));

String checkInModelToJson(List<CheckInModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckInModel {
  CheckInModel({
    required this.id,
    this.rev,
    this.roomId,
    this.roomName,
    this.roomSlotDuration,
    this.roomCapacity,
    this.branchId,
    this.branchName,
    this.date,
    this.time,
    this.staffId,
    this.staffName,
    this.staffUserId,
    this.staffBranchName,
    this.customerId,
    this.customerName,
    required this.customerPhone,
    this.dropOffName,
    this.dropOffPhone,
    this.price,
    this.paid,
    this.refundedAmount,
    this.paymentMethod,
    this.payments,
    this.quantity,
    this.deposit,
    required this.productName,
    this.addons,
    this.productId,
    this.productPrice,
    this.promoCodeId,
    this.promoCode,
    this.promoCodeValue,
    this.checkOutId,
    this.reserveDate,
    this.reserveTime,
    this.checkInDate,
    this.checkInTime,
    this.checkOutDate,
    this.checkOutTime,
    this.status,
    this.type,
    this.refunded,
    required this.inAdvance,
    required this.checkedIn,
    required this.checkedOut,
  });

  late String id;
  late String? rev;
  late String? roomId;
  late String? roomName;
  late String? roomSlotDuration;
  late String? roomCapacity;
  late String? branchId;
  late String? branchName;
  late String? date;
  late String? time;
  late String? staffId;
  late String? staffName;
  late String? staffUserId;
  late String? staffBranchName;
  late String? customerId;
  late String? customerName;
  late String customerPhone;
  late String? dropOffName;
  late String? dropOffPhone;
  late String? price;
  late String? paid;
  late String? refundedAmount;
  late String? paymentMethod;
  late String? type;
  late List<dynamic>? addons;
  late List<dynamic>? payments;
  late String? quantity;
  late String? deposit;
  late String? productId;
  late String productName;
  late String? productPrice;
  late String? promoCodeId;
  late String? promoCode;
  late String? promoCodeValue;
  late String? checkOutId;
  late String? reserveDate;
  late String? reserveTime;
  late String? checkInDate;
  late String? checkInTime;
  late String? checkOutDate;
  late String? checkOutTime;
  late int? status;
  late bool inAdvance;
  late bool checkedIn;
  late bool checkedOut;
  late bool? refunded;

  CheckInModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    rev = json['value']['_rev'];
    roomId = json['value']?['room']?['_id'];
    roomName = json['value']?['room']?['name'];
    roomSlotDuration = json['value']?['room']?['slotDuration'];
    roomCapacity = json['value']?['room']?['capacity'];
    date = json['value']['date'];
    time = json['value']['time'];
    branchId = json['value']?['branch']?['id'];
    branchName = json['value']?['branch']?['name'];
    customerId = json['value']?['user']?['id'];
    customerName = json['value']?['user']?['name'] ?? '';
    customerPhone = json['value']?['user']?['phone'] ?? '';
    dropOffName = json['value']?['drop_off']?['name'] ?? '';
    dropOffPhone = json['value']?['drop_off']?['phone'] ?? '';
    staffId = json['value']?['staff']['id'];
    staffName = json['value']?['staff']['name'];
    staffUserId = json['value']?['staff']['staffId'];
    staffBranchName = json['value']?['staff']['branchName'];
    quantity = json['value']?['quantity'];
    type = json['value']?['type'];
    paid = '0';
    deposit = '0';
    payments = json['value']?['paid'];
    if (!json['value']?['paid'].isEmpty) {
      var pricesObj = json['value']?['paid'];
      var pricePaid = 0.0;
      var refundPaid = 0.0;
      var depositPaid = 0;
      for (var x = 0; x < pricesObj.length; x++) {
        if (pricesObj[x] != null) {
          if (pricesObj[x]?['type'] != null && pricesObj[x]?['type'] == 'deposit') {
            deposit = pricesObj[x]['amount'];
          }

          if (pricesObj?[x]?['amount'] != null && pricesObj[x]?['type'] != null && pricesObj[x]?['type'] != 'refund') {
            double amount = double.parse("${pricesObj[x]['amount']}");
            pricePaid += amount;
          }
          if (pricesObj[x]?['type'] != null && pricesObj[x]?['type'] == 'refund') {
            double refamount = double.parse("${pricesObj[x]['amount']}");
            pricePaid -= refamount;
            refundPaid += refamount;
          }
        }
      }
      for (var payment in pricesObj) {
        paymentMethod = payment['method'];
        break;
      }
      paid = pricePaid.toString();
      refundedAmount = refundPaid.toString();
    }
    inAdvance = json['value']?['in_advance'] != null && json['value']?['in_advance'] == true ? true : false;
    checkedIn = json['value']?['checked_in'] != null && json['value']?['checked_in'] == true ? true : false;
    checkedOut = json['value']?['checked_out'] != null && json['value']?['checked_out'] == true ? true : false;
    price = (int.parse(json['value']?['product']?['price'] ?? '0') * int.parse(json['value']?['quantity']) ?? 1).toString();
    addons = json['value']?['addOns'];
    productId = json['value']?['product']?['_id'];
    productName = json['value']?['product']?['name'] ?? '';
    productPrice = json['value']?['product']?['price'];
    promoCodeId = json['value']?['promo']?['id'];
    promoCode = json['value']?['promo']?['code'];
    promoCodeValue = json['value']?['promo']?['value'];
    checkOutId = json['value']?['check_out']?['_id'];
    reserveDate = json['value']?['reservation']?['date'];
    reserveTime = json['value']?['reservation']?['time'];
    checkInDate = json['value']?['check_in']?['date'];
    checkInTime = json['value']?['check_in']?['time'];
    checkOutDate = json['value']?['check_out']?['date'];
    checkOutTime = json['value']?['check_out']?['time'];
    status = json['value']?['status'];
    refunded = json['value']?['refunded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['_rev'] = rev;
    data['branch'] = {"id": branchId, "name": branchName};
    data['user'] = {
      'id': customerId,
      'name': customerName,
      'phone': customerPhone,
    };
    data['type'] = type;
    data['time'] = time;
    data['date'] = date;
    data['product'] = {
      '_id': productId,
      'name': productName,
      'price': productPrice,
    };
    data['addOns'] = addons;
    data['reservation'] = {
      'date': reserveDate,
      'time': reserveTime,
    };
    data['check_in'] = {
      'date': checkInDate,
      'time': checkInTime,
    };
    data['check_out'] = {
      'date': checkOutDate,
      'time': checkOutTime,
    };
    data['room'] = {
      "_id": roomId,
      "name": roomName,
      "slotDuration": roomSlotDuration,
      "capacity": roomCapacity
    };
    data['promo'] = {
      'id': promoCodeId,
      'code': promoCode,
      'value': promoCodeValue,
    };
    data['staff'] = {
      'id': staffId,
      'name': staffName,
      'staffId': staffUserId,
      'branchName': branchName
    };
    data['paid'] = [
      {'amount': price}
    ];
    data['status'] = status;
    data['refunded'] = refunded;
    return data;
  }
}

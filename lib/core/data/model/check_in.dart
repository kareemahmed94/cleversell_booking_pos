import 'dart:convert';

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
    this.price,
    required this.productName,
    this.productId,
    this.productPrice,
    this.promoCode,
    this.promoCodeValue,
    this.checkOutId,
    this.checkOutDate,
    this.checkOutTime,
    this.status,
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
  late String? price;
  late String? productId;
  late String productName;
  late String? productPrice;
  late String? promoCode;
  late String? promoCodeValue;
  late String? checkOutId;
  late String? checkOutDate;
  late String? checkOutTime;
  late int? status;

  CheckInModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    rev = json['value']['_rev'];
    roomId = json['value']?['room']?['id'];
    roomName = json['value']?['room']?['name'];
    roomSlotDuration = json['value']?['room']?['slotDuration'];
    roomCapacity = json['value']?['room']?['capacity'];
    date = json['value']['date'];
    time = json['value']['time'];
    branchId = json['value']?['branch']?['id'];
    branchName = json['value']?['branch']?['name'];
    customerId = json['value']?['user']?['id'];
    customerName = json['value']?['user']['name'];
    customerPhone = json['value']?['user']['phone'];
    staffId = json['value']?['staff']['id'];
    staffName = json['value']?['staff']['name'];
    staffUserId = json['value']?['staff']['staffId'];
    staffBranchName = json['value']?['staff']['branchName'];
    price = json['value']?['paid']?[0]?['amount'].toString();
    productId = json['value']?['product']?['id'];
    productName = json['value']?['product']?['name'];
    productPrice = json['value']?['product']?['price'];
    promoCode = json['value']?['promo']?['code'];
    promoCodeValue = json['value']?['promo']?['value'];
    checkOutId = json['value']?['check_out']?['_id'];
    checkOutDate = json['value']?['check_out']?['date'];
    checkOutTime = json['value']?['check_out']?['time'];
    status = json['value']?['status'];
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
    data['time'] = time;
    data['date'] = date;
    data['product'] = {
      'id': productId,
      'name': productName,
      'price': productPrice,
    };
    data['room'] = {
      "id": roomId,
      "name": roomName,
      "slotDuration": roomSlotDuration,
      "capacity": roomCapacity
    };
    data['promo'] = {
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
    return data;
  }
}

import 'dart:convert';

List<CheckOutModel> customerModelFromJson(String str) => List<CheckOutModel>.from(
    json.decode(str).map((x) => CheckOutModel.fromJson(x)));

String customerModelToJson(List<CheckOutModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckOutModel {
  CheckOutModel({
    required this.id,
    this.roomName,
    this.date,
    this.time,
    this.customerId,
    this.customerName,
    required this.customerPhone,
    this.price,
    required this.productName,
    this.productId,
    this.productPrice,
    this.promoCode,
    this.promoCodeValue,
  });

  late String id;
  late String? roomName;
  late String? date;
  late String? time;
  late String? customerId;
  late String? customerName;
  late String customerPhone;
  late String? price;
  late String? productId;
  late String productName;
  late String? productPrice;
  late String? promoCode;
  late String? promoCodeValue;

  CheckOutModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    roomName = json['value']?['room']?['name'];
    date = json['value']['date'];
    time = json['value']['time'];
    customerId = json['value']?['user']?['id'];
    customerName = json['value']?['user']?['name'] ?? '';
    customerPhone = json['value']?['user']?['phone'] ?? '';
    price = '';
    productId = json['value']?['product']?['id'];
    productName = json['value']?['product']?['name'] ?? '';
    productPrice = json['value']?['product']?['price'] ?? '';
    promoCode = json['value']?['promo']?['code'];
    promoCodeValue = json['value']?['promo']?['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['room'] = {"name": roomName};
    data['date'] = date;
    data['time'] = time;
    data['user'] = {
      'id': customerId,
      'name': customerName,
      'phone': customerPhone,
    };
    data['paid'] = [
      {'amount': price}
    ];
    data['product'] = {
      'id': productId,
      'name': productName,
      'price': productPrice,
    };
    data['promo'] = {
      'code': promoCode,
      'value': promoCodeValue,
    };
    return data;
  }
}
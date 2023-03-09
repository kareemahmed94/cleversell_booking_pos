import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) => List<OrderModel>.from(
    json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  OrderModel({
    required this.id,
    this.productName,
    this.branchName,
    this.roomId,
    this.roomName,
    this.type,
    this.userName,
    required this.userPhone,
    this.userEmail,
    this.userGender,
    this.staffName,
    this.quantity,
    this.date,
    this.time,
    this.method,
    this.amount,
    this.status,
  });

  late String id;
  late String? productName;
  late String? branchName;
  late String? roomId;
  late String? roomName;
  late String? type;
  late String? userName;
  late String userPhone;
  late String? userEmail;
  late String? userGender;
  late String? staffName;
  late int? quantity;
  late String? date;
  late String? time;
  late String? method;
  late String? amount;
  late int? status;

  OrderModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['_id'];
    productName = json['product']?['name'];
    branchName = json['branch']?['name'];
    roomId = json['product']?['room']?[0]?['_id'];
    roomName = json['product']?['room']?[0]?['name'];
    type = json['type'];
    userName = json['user']?['name'];
    userPhone = json['user']?['phone'];
    userEmail = json['user']?['email'];
    userGender = json['user']?['gender'];
    staffName = json['staff']?['name'];
    quantity = json['quantity'];
    date = json['date'];
    time = json['time'];
    method = json['paid']?[0]?['method'];
    amount = json['paid']?[0]?['amount'].toString();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

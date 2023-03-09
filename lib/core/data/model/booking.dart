import 'dart:convert';

List<BookingModel> bookingModelFromJson(String str) => List<BookingModel>.from(
    json.decode(str).map((x) => BookingModel.fromJson(x)));

String bookingModelToJson(List<BookingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingModel {
  BookingModel({
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

  BookingModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    productName = json['value']?['product']?['name'];
    branchName = json['value']?['branch']?['name'];
    roomId = json['value']?['product']?['room']?[0]?['_id'];
    roomName = json['value']?['product']?['room']?[0]?['name'];
    type = json['value']?['type'];
    userName = json['value']?['user']?['name'];
    userPhone = json['value']?['user']?['phone'];
    userEmail = json['value']?['user']?['email'];
    userGender = json['value']?['user']?['gender'];
    staffName = json['value']?['staff']?['name'];
    quantity = json['value']?['quantity'];
    date = json['value']?['date'];
    time = json['value']?['time'];
    method = json['value']?['paid']?[0]?['method'];
    amount = json['value']?['paid']?[0]?['amount'].toString();
    status = json['value']?['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

import 'dart:convert';

List<CustomerModel> customerModelFromJson(String str) =>
    List<CustomerModel>.from(json.decode(str).map((x) => CustomerModel.fromJson(x)));

String customerModelToJson(List<CustomerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerModel {
  CustomerModel({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.area,
    this.gender,
    this.age,
  });

  late String? id;
  late String? email;
  late String? name;
  late String? phone;
  late String? area;
  late String? gender;
  late String? age;

  CustomerModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    email = json['value']['email'];
    name = json['value']['name'];
    phone = json['value']?['phone'] ?? '';
    area = json['value']?['area'] ?? '';
    gender = json['value']?['gender'] ?? '';
    age = json['value']?['age'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone?.replaceAll('-', '');
    data['name'] = name;
    return data;
  }
}

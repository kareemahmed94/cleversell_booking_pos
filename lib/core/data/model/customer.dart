import 'dart:convert';

List<CustomerModel> customerModelFromJson(String str) =>
    List<CustomerModel>.from(json.decode(str).map((x) => CustomerModel.fromJson(x)));

String customerModelToJson(List<CustomerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerModel {
  CustomerModel({
    this.id,
    this.rev,
    this.email,
    this.name,
    this.phone,
    this.area,
    this.gender,
    this.age,
    this.children,
  });

  late String? id;
  late String? rev;
  late String? email;
  late String? name;
  late String? phone;
  late String? area;
  late String? gender;
  late String? age;
  List<dynamic>? children = [];

  CustomerModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    rev = json['value']['_rev'];
    email = json['value']['email'];
    name = json['value']['name'];
    phone = json['value']?['phone'] ?? '';
    area = json['value']?['area'] ?? '';
    gender = json['value']?['gender'] ?? '';
    age = json['value']?['age'] ?? '';
    children = json['value']?['children'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone?.replaceAll('-', '');
    data['name'] = name;
    data['children'] = children;
    return data;
  }
}

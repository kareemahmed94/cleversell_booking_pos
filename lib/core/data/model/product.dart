import 'dart:convert';

List<ProductModel> productModelFromJson(String str) =>
    List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    this.id,
    this.rev,
    this.name,
    this.period,
    this.price,
    this.adds,
    this.room,
    this.staff,
    this.active,
  });

  late String? id;
  late String? rev;
  late String? name;
  late String? period;
  late String? price;
  late List<dynamic>? room;
  late List<dynamic>? adds;
  late Map? staff;
  late Map? branch;
  late bool? active;

  ProductModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    rev = json['value']['_rev'];
    name = json['value']['name'];
    period = json['value']['period'];
    price = json['value']['price'];
    branch = json['value']['branch'];
    room = json['value']['room'];
    adds = json['value']['adds'];
    staff = json['value']['staff'];
    active = json['value']['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['_rev'] = rev;
    data['name'] = name;
    data['period'] = period;
    data['price'] = price;
    data['branch'] = branch;
    data['room'] = room;
    data['adds'] = adds;
    data['active'] = active;
    return data;
  }
}

import 'dart:convert';

List<AddonProductModel> addonProductModelFromJson(String str) =>
    List<AddonProductModel>.from(json.decode(str).map((x) => AddonProductModel.fromJson(x)));

String addonProductModelToJson(List<AddonProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddonProductModel {
  AddonProductModel({
    this.id,
    this.name,
    this.price,
  });

  late String? id;
  late String? name;
  late String? price;

  AddonProductModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    name = json['value']['name'];
    price = json['value']['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

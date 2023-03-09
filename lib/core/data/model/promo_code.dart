import 'dart:convert';

List<PromoCodeModel> promoModelFromJson(String str) =>
    List<PromoCodeModel>.from(json.decode(str).map((x) => PromoCodeModel.fromJson(x)));

String promoModelToJson(List<PromoCodeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PromoCodeModel {
  PromoCodeModel({
    this.id,
    this.code,
    this.value,
  });

  late String? id;
  late String? code;
  late String? value;

  PromoCodeModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    code = json['value']['code'];
    value = json['value']['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['value'] = value;
    return data;
  }
}

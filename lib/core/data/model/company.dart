import 'dart:convert';

List<CompanyModel> companyModelFromJson(String str) =>
    List<CompanyModel>.from(json.decode(str).map((x) => CompanyModel.fromJson(x)));

String companyModelToJson(List<CompanyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompanyModel {
  CompanyModel({
    this.id,
  });

  late String? id;

  CompanyModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

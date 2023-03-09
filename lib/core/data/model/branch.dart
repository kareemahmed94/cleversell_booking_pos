import 'dart:convert';

List<BranchModel> questionModelFromJson(String str) => List<BranchModel>.from(
    json.decode(str).map((x) => BranchModel.fromJson(x)));

String questionModelToJson(List<BranchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BranchModel {
  BranchModel({
    this.id,
    this.active,
    this.name,
    this.staffName,
    this.staffId,
  });

  late String? id;
  late bool? active;
  late String? name;
  late String? staffName;
  late String? staffId;

  BranchModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    active = json['value']['active'];
    name = json['value']['name'];
    staffName = json['value']['staff']['name'];
    staffId = json['value']['staff']['staffId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

import 'dart:convert';

List<StaffModel> staffModelFromJson(String str) => List<StaffModel>.from(
    json.decode(str).map((x) => StaffModel.fromJson(x)));

String staffModelToJson(List<StaffModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StaffModel {
  StaffModel({
    this.id,
    this.type,
    this.name,
    this.staffId,
    this.pin,
    this.branchId,
    this.branchName,
  });

  late String? id;
  late String? type;
  late String? name;
  late String? staffId;
  late String? pin;
  late String? branchName;
  late String? branchId;

  StaffModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    type = json['value']?['type'];
    name = json['value']['name'];
    staffId = json['value']['staff_id'];
    pin = json['value']['pin'];
    branchName = json['value']?['branch']?['name'];
    branchId = json['value']?['branch']?['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['staffId'] = staffId;
    data['branchName'] = branchName;
    return data;
  }
}

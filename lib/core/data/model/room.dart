import 'dart:convert';

List<RoomModel> roomModelFromJson(String str) => List<RoomModel>.from(
    json.decode(str).map((x) => RoomModel.fromJson(x)));

String roomModelToJson(List<RoomModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoomModel {
  RoomModel({
    this.id,
    this.name,
    this.slotDuration,
    this.capacity,
  });

  late String? id;
  late String? name;
  late String? slotDuration;
  late String? capacity;

  RoomModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['value']['_id'];
    name = json['value']['name'];
    slotDuration = json['value']['slotDuration'];
    capacity = json['value']['capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slotDuration'] = slotDuration;
    data['capacity'] = capacity;
    return data;
  }
}

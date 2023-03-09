import 'dart:convert';

import 'package:cleversell_booking/core/constants/urls.dart';
import 'package:cleversell_booking/core/data/repository/repository.dart';
import 'package:cleversell_booking/core/services/client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInRepository extends Repository {
  CheckInRepository();

  getRooms() async {
    return await Client().get(roomsListPath);
  }

  getCheckInsByDate(url) async {
    return await Client().get(url);
  }

  getCheckOutsByDate(url) async {
    return await Client().get(url);
  }

  getCheckIns(filters) async {
    var path = customersListPath;
    if(filters != null) {
      path = customersListPath.replaceAll('%FILTERS%', filters);
    }
    return await Client().get(path);
  }

  createCheckIn(data) async {
    return await Client().post(checkInPath, jsonEncode(data));
  }

  updateCheckIn(data,id) async {
    return await Client().put('$checkInPath$id', jsonEncode(data));
  }

  createCheckOut(data) async {
    return await Client().post(checkOutPath, jsonEncode(data));
  }

  getCheckIn(id) async {
    return await Client().get('$checkInDetailsPath$id');
  }
}

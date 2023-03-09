import 'dart:convert';

import 'package:cleversell_booking/core/data/model/check_in.dart';
import 'package:cleversell_booking/core/data/repository/check_in_repository.dart';

import '../../core/data/model/room.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/urls.dart';
import '../data/model/check_out.dart';

class CheckOutController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  RoomModel? selectedRoom;
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  SharedPreferences? prefs;
  List<RoomModel> rooms = [];
  List<CheckOutModel> checkOuts = [];
  List<CheckOutModel> allCheckOuts = [];
  List<CheckOutModel> searchCheckOuts = [];
  TextEditingController searchNumber = TextEditingController();
  int page = 1;
  int perPage = 8;
  int pages = 0;
  String? branchId = '';

  bool loading = true;

  final CheckInRepository _checkInRepository;

  CheckOutController(this._checkInRepository);

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    branchId = prefs?.getString("branch");
    startDate = now.subtract(const Duration(days: 10));
    await getRooms();
    await getCheckOuts();

    super.onInit();
  }

  getRooms() async {
    var response = await _checkInRepository.getRooms();

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var roomList = body?["rows"];

      roomList = roomList?.where((element) =>
      element?["value"]?["isDeleted"] == null &&
          element?["value"]?["branch"]["_id"] == branchId);

      RoomModel all = RoomModel();
      all.id = 'All';
      all.name = 'All';

      rooms = roomList.map<RoomModel>((u) {
        return RoomModel.fromJson(u);
      })?.toList();

      rooms.insert(0, all);
      selectedRoom = rooms[0];

      update();
    }
  }

  changeRoom(value) async {
    selectedRoom = rooms.firstWhere((element) => element.id == value);
    update();

    await getCheckOuts();
  }

  findCheckIn() async {

  }

  getCheckOuts() async {
    String filter = '';
    allCheckOuts = [];
    checkOuts = [];
    page = 1;
    loading = true;
    pages = 0;
    update();

    var startDateMoment =
    DateTime(startDate.year, startDate.month, startDate.day, 12)
        .add(const Duration(hours: 3))
        .toUtc()
        .millisecondsSinceEpoch
        .toString();
    var endDateMoment = DateTime(endDate.year, endDate.month, endDate.day, 24)
        .add(const Duration(hours: 3))
        .toUtc()
        .millisecondsSinceEpoch
        .toString();

    if (selectedRoom?.name == "All") {
      filter =
      '$checkOutsLisPath?startkey=[%22$branchId%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22$endDateMoment%22]';
      print(filter);
    } else {
      filter =
      '$checkOutsListByDatePath?startkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$endDateMoment%22]';
    }
    var response = await _checkInRepository.getCheckOutsByDate(filter);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var checkOutList = body?["rows"];

      allCheckOuts = checkOutList
          ?.map<CheckOutModel>((u) => CheckOutModel.fromJson(u))
          ?.toList();

      pages = (allCheckOuts.length / perPage).round();

      if (pages > 1) {
        checkOuts = getCurrentData(allCheckOuts);
      } else {
        checkOuts = allCheckOuts;
      }
      loading = false;

      update();
    }
  }

  search(value) {
    searchCheckOuts = allCheckOuts
        .where((checkOut) =>
    checkOut.id.contains(value) || checkOut.customerPhone.contains(value))
        .toList();
    if (searchCheckOuts.isNotEmpty && searchCheckOuts.length > perPage) {
      checkOuts = getCurrentData(searchCheckOuts);
    } else {
      checkOuts = searchCheckOuts;
    }
    update();
  }

  updatePage(type) {
    if ((page - 1 == 0 && type == 'prev') ||
        (type == 'next' && page + 1 == pages)) {
      return;
    }
    page = type == 'next' ? page + 1 : page - 1;
    update();

    checkOuts = getCurrentData(
        searchCheckOuts.isNotEmpty ? searchCheckOuts : allCheckOuts);
    update();
  }

  List<CheckOutModel> getCurrentData(allData) {
    var currentIndex = (page * perPage);
    print('currentIndex');
    print(currentIndex);
    print(pages);

    List<CheckOutModel> data = [];
    for (var x = 0; x < pages; x++) {
      if (page == x + 1) {
        for (var i = 0; i < perPage; i++) {
          // data.add(allData[currentIndex]);
          data.add(allData[i]);
          currentIndex++;
        }
      }
    }
    return data;
  }

  nextDate() {
    endDate = endDate.add(const Duration(days: 1));
    update();
    getCheckOuts();
  }

  prevDate() {
    startDate = startDate.subtract(const Duration(days: 1));
    update();
    getCheckOuts();
  }

  pickDateRange(DateTimeRange? picked) {
    startDate = picked?.start as DateTime;
    endDate = picked?.end as DateTime;
    update();
    getCheckOuts();
  }
}

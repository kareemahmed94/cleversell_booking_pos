import 'dart:convert';
import 'dart:math';

import 'package:cleversell_booking/core/data/model/check_in.dart';
import 'package:cleversell_booking/core/data/repository/check_in_repository.dart';
import 'package:cleversell_booking/ui/widgets/bookings/check_in_details.dart';
import 'package:intl/intl.dart';

import '../../core/data/model/room.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/urls.dart';

class CheckInController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  RoomModel? selectedRoom;
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  String timeSpent = '';
  SharedPreferences? prefs;
  List<RoomModel> rooms = [];
  List<CheckInModel> checkIns = [];
  List<CheckInModel> allCheckIns = [];
  List<CheckInModel> searchCheckIns = [];
  TextEditingController searchNumber = TextEditingController();
  int page = 1;
  int perPage = 8;
  int pages = 0;
  String? branchId = '';

  bool loading = true;

  final CheckInRepository _checkInRepository;

  CheckInController(this._checkInRepository);

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    branchId = prefs?.getString("branch");
    startDate = now.subtract(const Duration(days: 10));
    await getRooms();
    await getCheckIns();

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

    await getCheckIns();
  }

  findCheckIn() async {}

  getCheckIns() async {
    String filter = '';
    allCheckIns = [];
    checkIns = [];
    page = 1;
    loading = true;
    pages = 0;
    update();

    var startDateMoment =
        DateTime(startDate.year, startDate.month, startDate.day, 00)
            .toUtc()
            .millisecondsSinceEpoch
            .toString()
            .substring(0, 9);
    var endDateMoment = DateTime(endDate.year, endDate.month, endDate.day, 24)
        .toUtc()
        .millisecondsSinceEpoch
        .toString()
        .substring(0, 9);

    if (selectedRoom?.name == "All") {
      filter =
          '$checkInsLisPath?startkey=[%22$branchId%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22$endDateMoment%22]';
    } else {
      filter =
          '$checkInsListByDatePath?startkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$endDateMoment%22]';
    }
    var response = await _checkInRepository.getCheckInsByDate(filter);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var checkInList = body?["rows"];

      print("checkInList");
      print(checkInList);
      allCheckIns = checkInList
          ?.map<CheckInModel>((u) => CheckInModel.fromJson(u))
          ?.toList();

      print(allCheckIns.length);
      pages = (allCheckIns.length / perPage).round();
      print("pages");
      print(pages);
      if (pages > 1) {
        print('we are here');
        checkIns = getCurrentData(allCheckIns);
      } else {
        checkIns = allCheckIns;
      }
      loading = false;

      update();
    }
  }

  search(value) {
    searchCheckIns = allCheckIns
        .where((checkIn) =>
            checkIn.id.contains(value) || checkIn.customerPhone.contains(value))
        .toList();
    if (searchCheckIns.isNotEmpty && searchCheckIns.length > perPage) {
      checkIns = getCurrentData(searchCheckIns);
    } else {
      checkIns = searchCheckIns;
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

    checkIns = getCurrentData(
        searchCheckIns.isNotEmpty ? searchCheckIns : allCheckIns);
    update();
  }

  double roundDouble(value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  showCheckInDialog(context, checkIn) {
    var from = DateTime.parse('${checkIn.date} ${checkIn.time}');
    var to = DateTime.now();
    if (checkIn.checkOutId != null) {
      to = DateTime.parse('${checkIn.checkOutDate} ${checkIn.checkOutTime}');
    }
    timeSpent = roundDouble(to.difference(from).inMinutes / 60, 1).toString();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: Text(
          '${checkIn.id}',
          style: const TextStyle(color: primary),
        ),
        content: checkInDetails(this, context, checkIn),
      ),
    );
  }

  List<CheckInModel> getCurrentData(allData) {
    var currentIndex = (page * perPage);
    print('currentIndex');
    print(currentIndex);
    print(pages);

    currentIndex = currentIndex - page - 1;
    List<CheckInModel> data = [];
    for (var x = 0; x < pages; x++) {
      if (page == x + 1) {
        for (var i = 0; i < perPage; i++) {
          data.add(allData[currentIndex]);
          print(i);
          print(allData[i]);
          // data.add(allData[i]);
          currentIndex++;
        }
      }
    }
    return data;
  }

  nextDate() {
    endDate = endDate.add(const Duration(days: 1));
    update();
    getCheckIns();
  }

  prevDate() {
    startDate = startDate.subtract(const Duration(days: 1));
    update();
    getCheckIns();
  }

  pickDateRange(DateTimeRange? picked) {
    startDate = picked?.start as DateTime;
    endDate = picked?.end as DateTime;
    update();
    getCheckIns();
  }
}

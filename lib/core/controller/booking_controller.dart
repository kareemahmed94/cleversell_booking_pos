import 'dart:convert';

import '../../core/data/model/booking.dart';
import '../../core/data/model/room.dart';
import '../../core/data/repository/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingsController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  RoomModel? selectedRoom;
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  SharedPreferences? prefs;
  List<RoomModel> rooms = [];
  List<BookingModel> bookings = [];
  List<BookingModel> allBookings = [];
  List<BookingModel> searchBookings = [];
  TextEditingController searchNumber = TextEditingController();
  int page = 1;
  int perPage = 8;
  int pages = 0;
  String? branchId = '';

  bool loading = true;

  final BookingRepository _bookingRepository;

  BookingsController(this._bookingRepository);

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    branchId = prefs?.getString("branch");
    startDate = now.subtract(const Duration(days: 10));
    await getRooms();
    await getBookings();

    super.onInit();
  }

  getRooms() async {
    var response = await _bookingRepository.getRooms();

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

    await getBookings();
  }

  findCheckIn() async {

  }

  getBookings() async {
    String filter = '';
    allBookings = [];
    bookings = [];
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
          '?startkey=[%22$branchId%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22$endDateMoment%22]';
      // filter =
      //     '?startkey=[%22$branchId%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22$endDateMoment%22]';
      print(filter);
    } else {
      filter =
          '?startkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$endDateMoment%22]';
    }
    var response = await _bookingRepository.getBookingsByDate(filter);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var bookingList = body?["rows"];

      allBookings = bookingList
          ?.map<BookingModel>((u) => BookingModel.fromJson(u))
          ?.toList();

      pages = (allBookings.length / perPage).round();

      if (pages > 1) {
        bookings = getCurrentData(allBookings);
      } else {
        bookings = allBookings;
      }
      loading = false;

      update();
    }
  }

  search(value) {
    searchBookings = allBookings
        .where((booking) =>
            booking.id.contains(value) || booking.userPhone.contains(value))
        .toList();
    if (searchBookings.isNotEmpty && searchBookings.length > perPage) {
      bookings = getCurrentData(searchBookings);
    } else {
      bookings = searchBookings;
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

    bookings = getCurrentData(
        searchBookings.isNotEmpty ? searchBookings : allBookings);
    update();
  }

  List<BookingModel> getCurrentData(allData) {
    var currentIndex = (page * perPage);
    List<BookingModel> data = [];
    for (var x = 0; x < pages; x++) {
      if (page == x + 1) {
        for (var i = 0; i < perPage; i++) {
          data.add(allData[currentIndex]);
          currentIndex++;
        }
      }
    }
    return data;
  }

  nextDate() {
    endDate = endDate.add(const Duration(days: 1));
    update();
    getBookings();
  }

  prevDate() {
    startDate = startDate.subtract(const Duration(days: 1));
    update();
    getBookings();
  }

  pickDateRange(DateTimeRange? picked) {
    startDate = picked?.start as DateTime;
    endDate = picked?.end as DateTime;
    update();
    getBookings();
  }
}

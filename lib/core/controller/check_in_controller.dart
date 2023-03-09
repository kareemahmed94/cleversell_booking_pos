import 'dart:convert';
import 'dart:math';

import 'package:cleversell_booking/core/data/model/check_in.dart';
import 'package:cleversell_booking/core/data/repository/check_in_repository.dart';
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

  findCheckIn() async {

  }

  getCheckIns() async {
    String filter = '';
    allCheckIns = [];
    checkIns = [];
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
      '$checkInsLisPath?startkey=[%22$branchId%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22$endDateMoment%22]';
      // filter =
      //     '?startkey=[%22$branchId%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22$endDateMoment%22]';
      print(filter);
    } else {
      filter =
      '$checkInsListByDatePath?startkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$startDateMoment%22]&endkey=[%22$branchId%22,%22${selectedRoom?.id}%22,%22$endDateMoment%22]';
    }
    var response = await _checkInRepository.getCheckInsByDate(filter);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var checkInList = body?["rows"];

      allCheckIns = checkInList
          ?.map<CheckInModel>((u) => CheckInModel.fromJson(u))
          ?.toList();

      print(allCheckIns.length);
      pages = (allCheckIns.length / perPage).round();

      print(pages);
      if (pages > 1) {
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
  double roundDouble(value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
  showCheckInDialog(context, checkIn) {
    var from = DateTime.parse('${checkIn.date} ${checkIn.time}');
    var to = DateTime.now();
    if(checkIn.checkOutId != null) {
      to = DateTime.parse('${checkIn.checkOutDate} ${checkIn.checkOutTime}');
    }
    timeSpent =  roundDouble(to.difference(from).inMinutes / 60, 1).toString();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: surface,
        title: Text(
          '${checkIn.id}',
          style: const TextStyle(color: primary),
        ),
        content: Container(
          height: 500,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 400,
                    padding: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Wrap(
                              spacing: 30, // set spacing here
                              children: [
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "INVOICE NUMBER",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 11.0),
                                      child: Text(
                                        "${checkIn?.id}",
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            Wrap(
                              spacing: 30, // set spacing here
                              children: [
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "ROOM",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 11.0),
                                      child: Text(
                                        "${checkIn?.roomName}",
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            Wrap(
                              spacing: 30, // set spacing here
                              children: [
                                Container(
                                  width: 60,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "DATE",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 180,
                                    padding: const EdgeInsets.only(bottom: 11.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "[${checkIn?.date}] "
                                            "[${DateFormat().add_jm().format(DateTime.parse('${checkIn?.date} ${checkIn?.time}'))}]",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              width: double.infinity,
                              child: Divider(
                                thickness: 5,
                                color: background,
                              ),
                            ),
                            Wrap(
                              spacing: 30, // set spacing here
                              children: [
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "CUSTOMER",
                                    style: TextStyle(
                                        color: secondaryDim,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 11.0),
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            Wrap(
                              spacing: 30, // set spacing here
                              children: [
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "NAME",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 11.0),
                                      child: Text(
                                        "${checkIn?.customerName}",
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            Wrap(
                              spacing: 30, // set spacing here
                              children: [
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "PHONE",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 11.0),
                                      child: Text(
                                        "${checkIn?.customerPhone}",
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              width: double.infinity,
                              child: Divider(
                                thickness: 5,
                                color: background,
                              ),
                            ),
                            Wrap(
                              spacing: 60, // set spacing here
                              children: [
                                Container(
                                  width: 110,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "PRODUCT",
                                    style: TextStyle(
                                        color: secondaryDim,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 100,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            Wrap(
                              spacing: 30, // set spacing here
                              children: [
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "${checkIn?.productName}",
                                    style: const TextStyle(
                                        color: primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 11.0),
                                      child: Text(
                                        "${checkIn?.productPrice}",
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              width: 270,
                              height: 0,
                              child: Divider(
                                thickness: 1,
                                color: primary,
                              ),
                            ),
                            Wrap(
                              spacing: 30, // set spacing here
                              children: [
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "TOTAL",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 11.0),
                                      child: Text(
                                        "L.E ${checkIn?.productPrice}",
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            checkIn?.promoCode != null ?  const SizedBox(
                              width: double.infinity,
                              child: Divider(
                                thickness: 5,
                                color: background,
                              ),
                            ) : const Center(),
                            checkIn?.promoCode != null ? Wrap(
                              spacing: 60, // set spacing here
                              children: [
                                Container(
                                  width: 100,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "PROMOCODE",
                                    style: TextStyle(
                                        color: secondaryDim,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 100,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ) : const Center(),
                            checkIn?.promoCode != null ? Wrap(
                              spacing: 30, // set spacing here
                              children: [
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    "PROMOCODE",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 11.0),
                                      child: Text(
                                        "${checkIn?.promoCode}",
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ) : const Center(),
                          ],
                        ))),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  // width: MediaQuery.of(context).size.width / 3.4,
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                padding: const EdgeInsets.all(5.0),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(
                                    color: highlight,
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    const Text(
                                      'TOTAL',
                                      style: TextStyle(color: primary, fontSize: 30.0),
                                    ),
                                    const SizedBox(width: 80),
                                    Text(
                                      'L.E ${checkIn?.price}',
                                      style: const TextStyle(
                                          color: primary, fontSize: 30.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      checkIn.checkOutId != null ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                padding: const EdgeInsets.all(5.0),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(
                                    color: secondaryDim,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    const Text(
                                      'TIME SPENT',
                                      style: TextStyle(
                                          color: primary, fontSize: 30.0),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      '${timeSpent} Hours',
                                      style: const TextStyle(
                                          color: primary, fontSize: 30.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ) : const Center()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<CheckInModel> getCurrentData(allData) {
    var currentIndex = (page * perPage);
    print('currentIndex');
    print(currentIndex);
    print(pages);

    List<CheckInModel> data = [];
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

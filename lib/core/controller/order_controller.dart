import 'dart:convert';

import '../../core/data/model/booking.dart';
import '../../core/data/model/room.dart';
import '../../core/data/repository/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/order.dart';
import '../data/repository/order_repository.dart';

class OrdersController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  RoomModel? selectedRoom;
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  SharedPreferences? prefs;
  List<RoomModel> rooms = [];
  List<OrderModel> orders = [];
  List<OrderModel> allOrders = [];
  List<OrderModel> searchOrders = [];
  TextEditingController searchNumber = TextEditingController();
  int page = 1;
  int perPage = 8;
  int pages = 0;
  String? branchId = '';

  bool loading = true;

  final OrderRepository _orderRepository;

  OrdersController(this._orderRepository);

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    branchId = prefs?.getString("branch");
    startDate = now.subtract(const Duration(days: 10));
    await getOrders();

    super.onInit();
  }

  getOrders() async {
    String filter = '';
    allOrders = [];
    orders = [];
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
    filter = '?startkey=%22$startDateMoment%22&endkey=%22$endDateMoment%22';


    var response = await _orderRepository.getOrdersByDate(filter);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var ordersList = body?["rows"];
      ordersList = ordersList?.map((order) => order["value"][1])?.toList();
      allOrders = ordersList?.map<OrderModel>((u) => OrderModel.fromJson(u))?.toList();

      pages = (allOrders.length / perPage).round();

      if (pages > 1) {
        orders = getCurrentData(allOrders);
      } else {
        orders = allOrders;
      }
      loading = false;
      update();
    }
  }

  search(value) {
    searchOrders = allOrders
        .where((booking) =>
    booking.id.contains(value) || booking.userPhone.contains(value))
        .toList();
    if (searchOrders.isNotEmpty && searchOrders.length > perPage) {
      orders = getCurrentData(searchOrders);
    } else {
      orders = searchOrders;
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

    orders = getCurrentData(
        searchOrders.isNotEmpty ? searchOrders : allOrders);
    update();
  }

  List<OrderModel> getCurrentData(allData) {
    var currentIndex = (page * perPage);

    List<OrderModel> data = [];
    for (var x = 0; x < pages; x++) {
      if (page == x + 1) {
        for (var i = 0; i < perPage; i++) {
          data.add(allData[currentIndex-1]);
          currentIndex++;
        }
      }
    }
    return data;
  }

  nextDate() {
    endDate = endDate.add(const Duration(days: 1));
    update();
    getOrders();
  }

  prevDate() {
    startDate = startDate.subtract(const Duration(days: 1));
    update();
    getOrders();
  }

  pickDateRange(DateTimeRange? picked) {
    if (picked?.start != null) {
      startDate = picked?.start as DateTime;
    }
    if (picked?.end != null) {
      endDate = picked?.end as DateTime;
    }
    if (picked?.start != null && picked?.end != null) {
      update();
      getOrders();
    }
  }
}

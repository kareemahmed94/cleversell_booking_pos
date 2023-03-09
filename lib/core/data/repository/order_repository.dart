import 'package:cleversell_booking/core/constants/urls.dart';
import 'package:cleversell_booking/core/data/repository/repository.dart';
import 'package:cleversell_booking/core/services/client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepository extends Repository {
  OrderRepository();

  getOrdersByDate(query) async {
    return await Client().get(ordersOfRangePath+query);
  }
}

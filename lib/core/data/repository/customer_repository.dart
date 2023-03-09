import 'dart:convert';

import 'package:cleversell_booking/core/constants/urls.dart';
import 'package:cleversell_booking/core/data/repository/repository.dart';
import 'package:cleversell_booking/core/services/client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerRepository extends Repository {
  CustomerRepository();

  getCustomers(filters) async {
    var path = customersListPath;
    if(filters != null) {
      path = customersListPath.replaceAll('%FILTERS%', filters);
    }
    return await Client().get(path);
  }

  createCustomer(data) async {
    print(jsonEncode(data));
    return await Client().post(addCustomerPath, jsonEncode(data));
  }
}

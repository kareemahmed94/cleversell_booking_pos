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
  getCustomer(id) async {
    var path = getCustomerPath;
    if(id != null) {
      path = getCustomerPath.replaceAll('%FILTERS%', id);
    }
    return await Client().get(path);
  }

  createCustomer(data) async {
    print(jsonEncode(data));
    return await Client().post(addCustomerPath, jsonEncode(data));
  }

  updateCustomer(data,id) async {
    print(id);
    print(jsonEncode(data));
    return await Client().put('$addCustomerPath$id', jsonEncode(data));
  }
}

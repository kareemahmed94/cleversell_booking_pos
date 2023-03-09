import 'package:cleversell_booking/core/constants/urls.dart';
import 'package:cleversell_booking/core/data/repository/repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cleversell_booking/core/services/client.dart';

class StaffRepository extends Repository {

  staffLogin(username, password) async {
    Object formData = {
      "username": username,
      "password": password,
    };
    return await Client().post(companyLoginPath, formData);
  }

  getStaff() async {
    return await Client().get(staffListPath);
  }

  login(branchId, staffId, pin) async {
    return await Client()
        .get('$loginPath?key=[%22$branchId%22,%22$staffId%22,%22$pin%22]');
  }
}

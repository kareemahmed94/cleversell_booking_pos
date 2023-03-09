import 'package:cleversell_booking/core/constants/urls.dart';
import 'package:cleversell_booking/core/data/repository/repository.dart';
import 'package:get/get.dart';
import 'package:cleversell_booking/core/services/client.dart';

class CompanyRepository extends Repository {
  CompanyRepository();

  companyLogin(username, password) async {
    return await Client().post(
        companyLoginPath,
        {
          "username": username,
          "password": password,
        },
        baseUrl: companyApiUrl);
  }
}

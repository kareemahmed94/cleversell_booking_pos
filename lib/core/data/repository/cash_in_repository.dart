import 'package:cleversell_booking/core/constants/urls.dart';
import 'package:cleversell_booking/core/data/repository/repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cleversell_booking/core/services/client.dart';


class CashInRepository extends Repository {
  CashInRepository();

  getCheckInsByDate(url) async {
    return await Client().get(url);
  }
}

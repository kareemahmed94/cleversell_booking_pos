import 'package:cleversell_booking/core/constants/urls.dart';
import 'package:cleversell_booking/core/data/repository/repository.dart';
import 'package:cleversell_booking/core/services/client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddonProductRepository extends Repository {
  AddonProductRepository();

  getAddonProducts() async {
    return await Client().get(promoCodesListPath);
  }
}

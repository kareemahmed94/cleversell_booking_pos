import 'package:cleversell_booking/core/constants/urls.dart';
import 'package:cleversell_booking/core/data/repository/repository.dart';
import 'package:cleversell_booking/core/services/client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepository extends Repository {
  ProductRepository();

  getProducts() async {
    return await Client().get(checkInProductList);
  }

  getRoomProducts(roomId) async {
    return await Client().get('$productsOfRoomListPath?startkey=%22${roomId}%22&endkey=%22${roomId}%22');
  }
}

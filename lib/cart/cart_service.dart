import 'dart:convert';
import 'package:frontend/core/services/storage_manager.dart';
import 'package:frontend/home/models/home_model.dart';

class CartService {
  static const String _cartKey = 'cart_items';

  List<HomeModel> getCartItems() {
    final String? cartData = StorageManager.getStringValue(_cartKey);
    if (cartData != null) {
      final List<dynamic> jsonList = jsonDecode(cartData);
      return jsonList.map((json) => HomeModel.fromJson(json)).toList();
    }
    return [];
  }

  void saveCartItems(List<HomeModel> items) {
    final String jsonString = jsonEncode(
      items.map((item) => item.toJson()).toList(),
    );
    StorageManager.setStringValue(key: _cartKey, value: jsonString);
  }
}

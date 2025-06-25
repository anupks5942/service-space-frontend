import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/cart/cart_service.dart';
import 'package:frontend/home/services/home_service.dart';
import '../models/home_model.dart';

class HomeProvider with ChangeNotifier {
  final HomeService _homeService = HomeService();
  final CartService _cartService = CartService();

  String _errorMessage = '';
  final bool _isLoading = false;
  List<HomeModel> _services = [];
  List<HomeModel> _cartItems = [];

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<HomeModel> get services => _services;
  List<HomeModel> get cartItems => _cartItems;

  HomeProvider() {
    _loadCart();
  }

  Future<Either<String, List<HomeModel>>> fetchServices() async {
    _errorMessage = '';
    notifyListeners();

    final result = await _homeService.getServices();

    result.match(
      (err) => _errorMessage = err,
      (services) => _services = services,
    );

    notifyListeners();
    return result;
  }

  void _loadCart() {
    _cartItems = _cartService.getCartItems();
    notifyListeners();
  }

  bool isInCart(HomeModel service) {
    return _cartItems.any((item) => item.id == service.id);
  }

  void addToCart(HomeModel service) {
    if (!isInCart(service)) {
      _cartItems.add(service);
      _cartService.saveCartItems(_cartItems);
      notifyListeners();
    }
  }

  void removeFromCart(HomeModel service) {
    _cartItems.removeWhere((item) => item.id == service.id);
    _cartService.saveCartItems(_cartItems);
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    _cartService.saveCartItems(_cartItems);
    notifyListeners();
  }
}

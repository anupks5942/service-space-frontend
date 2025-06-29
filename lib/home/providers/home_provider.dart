import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/cart/cart_service.dart';
import 'package:frontend/home/services/home_service.dart';
import '../models/home_model.dart';

class HomeProvider with ChangeNotifier {
  final HomeService _homeService = HomeService();
  final CartService _cartService = CartService();

  String _errorMessage = '';
  bool _isLoading = false;
  List<HomeModel> _services = [];
  List<HomeModel> _cartItems = [];
  final Map<HomeModel, int> _quantities = {};
  String _searchQuery = '';
  String? _selectedLocation;
  List<String> uniqueLocations = [
    'Arera Colony',
    'Samrat Colony Ashoka Garden',
    'Amarnath Colony Kolar Rd',
    'Shahpura',
    'Sahajnish Homes Kolar Rd',
    'Aakriti eco city',
    'MP Nagar',
    'Jahangirabad',
    'Sudama Nagar Govindpura',
    'Shamla Hills',
    'Bhopal',
    'Karond',
    'Kolar Road',
    'Main Road',
    'Govindpura',
    'Kotra Sultanabad',
    'Tulsi Nagar',
    'Abbas Nagar',
    'Kolua Kalan',
    'Lalghati',
    'Citywide',
    'MP Nagar & Lalghati',
    'Awadhpuri',
    'Peer Gate Area',
    'Saket Nagar',
    'Malviya Nagar',
    'Kalpana Nagar Huzur',
    'Bhopal MP Nagar',
    'Lucky Plaza Malviya Nagar',
    'Bairagarh',
    'Zama Masjid New Jail Rd',
    'Rusalli Karond',
    'Indrapuri',
    'Arya Samaj Bhawan',
    'Panchwati Colony Kailash Ngr',
    'Taparia Estate Nayapura',
    'Siddharth Enclave',
    '27 Noble Plaza MP Nagar',
    'Gulmohar Lalghati',
    'Silicon City',
    'Vidya Nagar MP Nagar',
    'Bhopal Lalghati',
    'Gulmohar Colony',
    'Shivaji Nagar',
    'Peer Gate',
    'Ashok Vihar',
    'Kohefiza',
    'Semra',
    'Amrai parisar Bagsewaniya',
    'Kotra Road',
    '10 No. Stop',
    'DB City Mall',
    'Koh-e-Fiza',
    'Bittan Market',
    'Ashima Mall',
    'Bagmugaliya',
  ];

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<HomeModel> get services => _services;
  List<HomeModel> get cartItems => _cartItems;
  Map<HomeModel, int> get quantities => _quantities;
  String get searchQuery => _searchQuery;
  String? get selectedLocation => _selectedLocation;

  HomeProvider() {
    _loadCart();
  }

  Future<Either<String, List<HomeModel>>> fetchServices() async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    final result = await _homeService.getServices();

    result.match(
      (err) => _errorMessage = err,
      (services) => _services = services,
    );

    _isLoading = false;
    notifyListeners();
    return result;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedLocation(String? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedLocation = null;
    notifyListeners();
  }

  void _loadCart() {
    _cartItems = _cartService.getCartItems();
    for (var item in _cartItems) {
      if (!_quantities.containsKey(item)) {
        _quantities[item] = 1;
      }
    }
    notifyListeners();
  }

  bool isInCart(HomeModel service) {
    return _cartItems.any((item) => item.id == service.id);
  }

  void addToCart(HomeModel service) {
    if (!isInCart(service)) {
      _cartItems.add(service);
      _quantities[service] = 1;
      _cartService.saveCartItems(_cartItems);
      notifyListeners();
    }
  }

  void removeFromCart(HomeModel service) {
    _cartItems.removeWhere((item) => item.id == service.id);
    _quantities.remove(service);
    _cartService.saveCartItems(_cartItems);
    notifyListeners();
  }

  void updateQuantity(HomeModel service, int newQuantity) {
    if (_cartItems.contains(service)) {
      if (newQuantity > 0) {
        _quantities[service] = newQuantity;
      } else {
        removeFromCart(service);
      }
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    _quantities.clear();
    _cartService.saveCartItems(_cartItems);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../data/models/product_model.dart';

class HomeViewModel with ChangeNotifier {
  final ApiService _api = ApiService();

  List<ProductModel> products = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.fetchProducts();
      products = data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      errorMessage = e.toString();
      products = [];
    }

    isLoading = false;
    notifyListeners();
  }
}

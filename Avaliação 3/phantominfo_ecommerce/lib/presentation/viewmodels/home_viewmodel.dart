// lib/presentation/viewmodels/home_viewmodel.dart
import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../data/models/product_model.dart';

class HomeViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchProducts();
      
      if (data.isEmpty) {
        final token = await _apiService.getToken();
        if (token == null) {
          _errorMessage = 'Sessão expirada. Faça login novamente.';
        } else {
          _errorMessage = 'Falha ao carregar produtos. Verifique sua conexão.';
        }
        _products = [];
      } else {
        _products = data.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      _errorMessage = 'Erro inesperado ao carregar produtos.';
      _products = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
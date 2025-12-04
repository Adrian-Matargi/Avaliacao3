// lib/core/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {
  final String _baseUrl = API_URL;

  // Busca o token salvo (necessário para buscar produtos)
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Método para buscar todos os produtos
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final uri = Uri.parse('$_baseUrl/products');
    final token = await getToken(); 
    
    // Se não houver token, o acesso não é autorizado.
    if (token == null) return [];

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
      return [];
    } catch (e) {
      print('Erro ao buscar produtos: $e');
      return [];
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://fakestoreapi.com";

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final url = Uri.parse("$baseUrl/products");

    print("📡 GET -> $url");

    final response = await http.get(url);

    print("📡 STATUS: ${response.statusCode}");
    print("📄 BODY: ${response.body}");

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Erro ao carregar produtos: ${response.statusCode}");
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SimpleFirestoreUser {
  final String name;
  final String documentId;

  SimpleFirestoreUser({
    required this.name,
    required this.documentId,
  });
}

class AuthViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SimpleFirestoreUser? _currentUser;
  bool _isLoading = false;

  SimpleFirestoreUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthViewModel() {
    _currentUser = null;
  }

  // LOGIN usando Firestore
  Future<void> login(String name, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // comparação com banco de dados do firestore
      final result = await _firestore
          .collection('User')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        throw 'Nome de usuário não encontrado.';
      }

      final doc = result.docs.first;
      final data = doc.data();

      // Valida senha
      if (data['password'] != password) {
        throw 'Senha incorreta.';
      }

      // Login
      _currentUser = SimpleFirestoreUser(
        name: data['name'],
        documentId: doc.id,
      );

      print('Login OK → Document ID: ${doc.id}');
    } catch (e) {
      throw 'Erro no login: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}

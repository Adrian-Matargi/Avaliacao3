// lib/presentation/viewmodels/auth_viewmodel.dart (Com Firestore Simples)

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Classe de Usuário Simples para fins de estudo
class SimpleFirestoreUser {
  final String name;
  final String documentId;
  SimpleFirestoreUser({required this.name, required this.documentId});
}

class AuthViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SimpleFirestoreUser? _currentUser;
  bool _isLoading = false;

  SimpleFirestoreUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Construtor: Inicializa com usuário nulo
  AuthViewModel() {
    _currentUser = null; 
    notifyListeners();
  }

  // FUNÇÃO DE LOGIN USANDO BUSCA DIRETA NO FIRESTORE
  Future<void> login(String name, String password) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500)); // Simula delay de rede
    
    try {
      // 1. Consulta o Firestore buscando por um documento onde o campo 'name' é igual ao digitado
      final result = await _firestore.collection('users')
          .where('name', isEqualTo: name)
          .limit(1) // Pega apenas o primeiro resultado
          .get();

      if (result.docs.isEmpty) {
        // Usuário não encontrado
        throw 'Nome de usuário não encontrado.';
      }

      // 2. Documento encontrado
      final userData = result.docs.first.data();
      final storedPassword = userData['password'];
      final documentId = result.docs.first.id;

      // 3. Compara a senha digitada com a senha armazenada (texto simples!)
      if (password == storedPassword) {
        // Sucesso
        _currentUser = SimpleFirestoreUser(name: name, documentId: documentId);
        print('Login bem-sucedido. Document ID: $documentId');
      } else {
        // Senha incorreta
        throw 'Senha incorreta.';
      }
    } catch (e) {
      if (e is String) {
        throw e;
      }
      // Outros erros (ex: erro de rede ou Firestore)
      throw 'Erro ao tentar fazer login: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // FUNÇÃO DE LOGOUT
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}
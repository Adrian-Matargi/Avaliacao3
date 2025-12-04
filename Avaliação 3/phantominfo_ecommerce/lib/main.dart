// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/cart/cart_screen.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/cart_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async { 
  // OBRIGATÓRIO: Garante que os bindings do Flutter estão prontos
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialização do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final authViewModel = AuthViewModel();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      child: MyApp(
        // Rota inicial baseada no estado do Firebase Auth
        initialRoute: authViewModel.currentUser != null ? '/home' : '/login', 
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute; 
  
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phantominfo E-commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.cyan,
        ).copyWith(
          secondary: AppColors.accentColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.backgroundColor,
          elevation: 0,
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
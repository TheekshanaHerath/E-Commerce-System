import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/auth_repository.dart';
import 'features/authentication/bloc/login_bloc.dart';
import 'features/authentication/ui/login_screen.dart';
import 'spash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce App',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),

        '/login': (context) => BlocProvider(
          create: (context) => LoginBloc(AuthRepository()),
          child: const Loginscreen(),
        ),
      },
    );
  }
}
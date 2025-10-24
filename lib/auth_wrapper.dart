import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polbeng_ar_gamifikasi_polbeng_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:polbeng_ar_gamifikasi_polbeng_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:polbeng_ar_gamifikasi_polbeng_mobile/main_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.when(
          authenticated: (user) => const MainPage(),
          unauthenticated: () => const LoginPage(),
          error: (message) => const LoginPage(),
          initial: () => const SplashScreen(),
          loading: () => const SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Mengecek sesi...'),
          ],
        ),
      ),
    );
  }
}

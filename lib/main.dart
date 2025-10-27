import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import untuk debugPrint
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polbeng_ar_gamifikasi_polbeng_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:polbeng_ar_gamifikasi_polbeng_mobile/features/auth/presentation/pages/register_page.dart';
import 'core/di/service_locator.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/missions/bloc_data/mission_bloc.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'main_page.dart';
import 'auth_wrapper.dart';

void main() async {
  debugPrint('[main] Aplikasi dimulai...');

  // 1. Pastikan binding siap
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[main] Binding Flutter sudah siap.');

  // 2. Inisialisasi Service Locator
  try {
    debugPrint('[main] Memulai setupLocator()...');
    await setupLocator();
    debugPrint('[main] setupLocator() SELESAI.');
  } catch (e) {
    debugPrint(
      '[main] GAGAL setupLocator(): ${e.toString()}',
    );
  }

  // 3. Jalankan aplikasi
  debugPrint('[main] Menjalankan MainApp()...');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '[MainApp] Build... (Membuat MultiBlocProvider)',
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            debugPrint(
              '[MainApp] Membuat AuthBloc dan mengirim event authCheckRequested...',
            );
            return sl<AuthBloc>()
              ..add(const AuthEvent.authCheckRequest());
          },
        ),
        BlocProvider(
          create: (context) => sl<MissionBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ProfileBloc>(),
        ),
        
      ],
      child: MaterialApp(
        title: 'Polbeng AR Gamifikasi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity:
              VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              unauthenticated: () {
                debugPrint(
                  '[MainApp] Listener: State unauthenticated, navigasi ke Login.',
                );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
            );
          },
          child: const AuthWrapper(),
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/main': (context) => const MainPage(),
        },
      ),
    );
  }
}

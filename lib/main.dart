import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/theme/app_theme.dart';
import 'package:store_app/features/auth/presentation/pages/splash_page.dart';
import 'package:store_app/features/cart/presentation/bloc/cart/cart_bloc.dart';
import 'package:store_app/injection.dart';

void main() async {
  // Memastikan binding Flutter siap sebelum melakukan async task
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Service Locator (GetIt)
  await initInjector();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // PRINSIP: Global State Management.
    // Bloc yang datanya digunakan di banyak screen (Cart & Auth)
    // diletakkan di top-level agar tidak ter-dispose saat pindah page.
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<CartBloc>()..add(LoadCart()))],
      child: MaterialApp(
        title: 'Store App Clean Architecture',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/theme/app_colors.dart';
import 'package:store_app/core/theme/app_fonts.dart';
import 'package:store_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:store_app/features/auth/presentation/pages/login_page.dart';
import 'package:store_app/features/product/presentation/pages/product_page.dart';
import 'package:store_app/injection.dart';

/// PRINSIP: Initial Route Handler.
/// Mengapa bagus: Menghindari "flicker" (kedipan) layar login jika user sebenarnya sudah login.
/// SplashPage bertindak sebagai router pintar saat aplikasi pertama kali dimuat.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Langsung cek session saat Splash muncul
      create: (context) => sl<AuthBloc>()..add(LoadCurrentUser()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Beri delay sedikit biar logo sempet kelihatan (branding)
        Future.delayed(const Duration(seconds: 2), () {
          /// PRINSIP: Context Safety Check.
          /// Mengapa bagus: Memastikan widget masih ada di dalam widget tree
          /// sebelum melakukan aksi navigasi. Ini mencegah "Looking up a deactivated widget's ancestor" error.
          if (!context.mounted) return;

          if (state is AuthAuthenticated) {
            /// PRINSIP: Clear Stack Navigation.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ProductPage()),
              (route) => false,
            );
          } else if (state is AuthUnauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        });
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storefront, size: 80, color: AppColors.white),
              Text(
                'Store App',
                style: AppFonts.semiBold.copyWith(color: AppColors.white, fontSize: 24),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }
}

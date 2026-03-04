import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/components/custom_button.dart';
import 'package:store_app/core/components/custom_text_field.dart';
import 'package:store_app/core/theme/app_colors.dart';
import 'package:store_app/core/theme/app_fonts.dart';
import 'package:store_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:store_app/features/product/presentation/pages/product_page.dart';
import 'package:store_app/injection.dart';

/// PRINSIP: Scoped BLoc Provider.
/// Mengapa bagus: Dengan membungkus View di dalam BlocProvider, kita memastikan
/// AuthBloc memiliki lifecycle yang jelas. Bloc akan di-dispose otomatis saat
/// user meninggalkan halaman login, mencegah memory leak.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => sl<AuthBloc>(), child: const LoginView());
  }
}

/// PRINSIP: Reactive UI & Event-Driven Communication.
/// Mengapa bagus: View tidak memproses logika login secara langsung. View hanya
/// mengirimkan "Event" (LoginSubmitted) dan bereaksi terhadap "State" (Loading, Error, Success).
/// Ini menjaga UI tetap "dumb" (bodoh) dan logika tetap terpusat di Bloc.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ProductPage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Column(
                children: [
                  Icon(Icons.storefront, size: 80, color: AppColors.primary),
                  Text(
                    'Login Account',
                    style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 20),
                  ),
                  Text(
                    'Hello, welcome back to our account',
                    style: AppFonts.regular.copyWith(color: AppColors.grey, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 52.0),
              CustomTextField(
                controller: _usernameController,
                label: 'Username',
                hintText: 'Masukkan Username',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                obscureText: true,
                label: 'Password',
                hintText: 'Masukkan Password',
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Button.filled(
                    label: 'Login',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginSubmitted(_usernameController.text, _passwordController.text),
                      );
                    },
                    isLoading: state is AuthLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

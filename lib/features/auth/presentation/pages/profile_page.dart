import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/components/custom_appbar.dart';
import 'package:store_app/core/components/custom_button.dart';
import 'package:store_app/core/theme/app_colors.dart';
import 'package:store_app/core/theme/app_fonts.dart';
import 'package:store_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:store_app/features/auth/presentation/pages/login_page.dart';
import 'package:store_app/injection.dart';

/// PRINSIP: Dependency Injection via BlocProvider.
/// Mengapa bagus: Memastikan halaman Profile mendapatkan instance AuthBloc yang bersih
/// dan memicu loading data user segera setelah halaman dibuat menggunakan cascade operator (..).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>()..add(LoadCurrentUser()),
      child: const ProfileView(),
    );
  }
}

/// PRINSIP: State-Driven Navigation.
/// Mengapa bagus: Menggunakan BlocConsumer memungkinkan kita menangani perubahan state
/// untuk UI (tampil nama) dan aksi navigasi (pindah ke login saat logout) secara efisien dalam satu widget.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'My Profile',
          style: AppFonts.semiBold.copyWith(color: AppColors.primary, fontSize: 16),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          /// FUNGSI: Tambahkan pengecekan State di sini.
          /// Kita hanya ingin pindah ke LoginPage JIKA user sudah tidak terautentikasi (Logout).
          if (state is AuthUnauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Icon(Icons.person, size: 60, color: AppColors.primary),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        state.username,
                        style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 16),
                      ),
                      Text(
                        '${state.username}@gmail.com',
                        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        color: AppColors.black.withValues(alpha: 0.05),
                        blurRadius: 30.0,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Grup AKUN ---
                      Text(
                        'Akun',
                        style: AppFonts.regular.copyWith(
                          color: AppColors.black.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      profileMenu(icon: Icons.person, title: 'Informasi Akun', onPressed: () {}),
                      const SizedBox(height: 16.0),
                      profileMenu(
                        icon: Icons.lock_outline,
                        title: 'Ubah Password',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 24.0),

                      // --- Grup TRANSAKSI ---
                      Text(
                        'Transaksi',
                        style: AppFonts.regular.copyWith(
                          color: AppColors.black.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      profileMenu(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Pesanan Saya',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16.0),
                      profileMenu(icon: Icons.favorite_border, title: 'Wishlist', onPressed: () {}),
                      const SizedBox(height: 16.0),
                      profileMenu(
                        icon: Icons.location_on_outlined,
                        title: 'Alamat Pengiriman',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 24.0),

                      // --- Grup UMUM ---
                      Text(
                        'Umum',
                        style: AppFonts.regular.copyWith(
                          color: AppColors.black.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      profileMenu(
                        icon: Icons.help_outline,
                        title: 'Pusat Bantuan',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16.0),
                      profileMenu(
                        icon: Icons.info_outline,
                        title: 'Tentang Aplikasi',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Button.filled(
                  label: 'Logout',
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  isLoading: state is AuthLoading,
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget profileMenu({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12.0),
          Text(title, style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: AppColors.black),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/application/auth/auth_bloc.dart';
import 'package:smart_interview_ai/core/helper/presentation_helper.dart';
import 'package:smart_interview_ai/core/utils/const.dart';
import 'package:smart_interview_ai/core/widgets/snackbar/custom_snackbar.dart';
import 'package:smart_interview_ai/domain/auth/models/save_user_model.dart';
import 'package:smart_interview_ai/domain/auth/models/user_model.dart';
import 'package:smart_interview_ai/presentation/auth/widgets/BackgroundGradient.dart';
import 'package:smart_interview_ai/presentation/auth/widgets/switch_account_sheet.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _hasSavedAccounts = false;
  List<SaveUserModel> _savedAccounts = [];
  UserModel? _userModel;

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _plusKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(AuthCheckRequested()),
      child: Builder(
        builder: (context) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                setState(() => _isLoading = true);
              }

              if (state is AuthAuthenticated) {
                setState(() {
                  _isLoading = false;
                  _userModel = state.user;
                });

                context.router.replaceAll([
                  NavbarWrapperRoute(
                    homeKey: _homeKey,
                    plusKey: _plusKey,
                    profileKey: _profileKey,
                  ),
                ]);
              }

              if (state is AuthSavedAccountsLoaded) {
                setState(() {
                  _savedAccounts = state.accounts;
                  _hasSavedAccounts = state.accounts.isNotEmpty;
                });
              }

              if (state is AuthUnauthenticated) {
                setState(() {
                  _isLoading = false;
                  _userModel = null;
                });
              }

              if (state is AuthFailure) {
                setState(() => _isLoading = false);
                PresentationHelper.showCustomSnackBar(
                  context: context,
                  message: state.message,
                  type: SnackbarType.error,
                );
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  const Backgroundgradient(),
                  SafeArea(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            width: 360,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(36),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  blurRadius: 1,
                                  offset: const Offset(-1, -1),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : _userModel != null
                                ? _buildLoginWithAccount(context)
                                : _hasSavedAccounts
                                ? _buildLoginWithSavedAccounts(context)
                                : _buildLoginEmpty(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= UI (TIDAK DIUBAH) =================

  Widget _buildLoginEmpty(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icon/tulkun-icon-transparent.png',
          width: 150,
          height: 150,
        ),
        const Text(
          "Hello Sobat TulKun!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Selamat datang di aplikasi Smart Interview AI.\nMasuk untuk melanjutkan.",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLoginRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              children: [
                const Spacer(),
                Image.network(PresentationConst.logoGoogle, width: 20),
                const SizedBox(width: 16),
                const Text(
                  "Login with Google",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginWithSavedAccounts(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Welcome back",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        SwitchAccountSheet(
          accounts: _savedAccounts,
          onSelect: (user) {
            context.read<AuthBloc>().add(AuthSwitchAccountRequested(user));
          },
          onAddAccount: () {
            context.read<AuthBloc>().add(AuthLoginRequested());
          },
        ),
      ],
    );
  }

  Widget _buildLoginWithAccount(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_userModel!.photoUrl!),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _userModel!.displayName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(_userModel!.email),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthCheckRequested());
            },
            child: Text(
              'Continue as ${_userModel!.displayName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (_) => SwitchAccountSheet(
                  accounts: _savedAccounts,
                  onSelect: (user) {
                    Navigator.pop(context);
                    context.read<AuthBloc>().add(
                      AuthSwitchAccountRequested(user),
                    );
                  },
                  onAddAccount: () {
                    context.read<AuthBloc>().add(AuthLoginRequested());
                  },
                ),
              );
            },
            child: const Text("Switch Account"),
          ),
        ),
      ],
    );
  }
}

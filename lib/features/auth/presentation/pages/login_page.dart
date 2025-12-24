import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/core/helper/presentation_helper.dart';
import 'package:smart_interview_ai/core/utils/const.dart';
import 'package:smart_interview_ai/core/widgets/snackbar/custom_snackbar.dart';
import 'package:smart_interview_ai/features/auth/models/save_user_model.dart';
import 'package:smart_interview_ai/features/auth/models/user_model.dart';
import 'package:smart_interview_ai/features/auth/widgets/BackgroundGradient.dart';
import 'package:smart_interview_ai/features/auth/widgets/switch_account_sheet.dart';

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
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await DI.authRepository.getCurrentUser();
    final accounts = await DI.authRepository.getSavedAccounts();

    if (!mounted) return;

    setState(() {
      _userModel = user;
      _hasSavedAccounts = accounts.isNotEmpty;
      _savedAccounts = accounts;
    });
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final user = await DI.authRepository.loginWithGoogle();

      if (!mounted) return;

      if (user != null) {
        context.router.replaceAll([
          NavbarWrapperRoute(
            homeKey: _homeKey,
            plusKey: _plusKey,
            profileKey: _profileKey,
          ),
        ]);
      } else {
        PresentationHelper.showCustomSnackBar(
          context: context,
          message: 'Sign in canceled',
          type: SnackbarType.info,
        );
      }
    } catch (e) {
      if (mounted) {
        PresentationHelper.showCustomSnackBar(
          context: context,
          message: 'Login Failed: $e',
          type: SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _continueUser() async {
    setState(() => _isLoading = true);
    try {
      await DI.authRepository.continueWithSavedUser();
      if (!mounted) return;
      context.router.replaceAll([
        NavbarWrapperRoute(
          homeKey: _homeKey,
          plusKey: _plusKey,
          profileKey: _profileKey,
        ),
      ]);
    } catch (e) {
      PresentationHelper.showCustomSnackBar(
        context: context,
        message: e.toString(),
        type: SnackbarType.error,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showSwitchAccountSheet() async {
    final accounts = await DI.authRepository.getSavedAccounts();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SwitchAccountSheet(
          accounts: accounts,
          onSelect: (user) async {
            Navigator.pop(context);
            setState(() => _isLoading = true);
            try {
              final switchedUser = await DI.authRepository.switchAccount(user);
              if (!mounted) return;
              setState(() {
                _userModel = switchedUser;
              });
            } catch (e) {
              PresentationHelper.showCustomSnackBar(
                context: context,
                message: e.toString(),
                type: SnackbarType.error,
              );
            } finally {
              if (mounted) {
                setState(() => _isLoading = false);
              }
            }
          },
          onAddAccount: () async {
            await DI.authRepository.disconnectGoogle();
            await _handleGoogleSignIn();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        ? const Center(child: CircularProgressIndicator())
                        : _userModel != null
                        ? _buildLoginWithAccount()
                        : _hasSavedAccounts
                        ? _buildLoginWithSavedAccounts()
                        : _buildLoginEmpty(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginEmpty() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(PresentationConst.logoGoogle, width: 50, height: 50),
        const SizedBox(height: 16),

        const Text(
          "Hello there!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          "Welcome to the future of browsing.\nSign in to continue.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _handleGoogleSignIn,
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
                Image.network(
                  PresentationConst.logoGoogle,
                  width: 20,
                  height: 20,
                ),
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

  Widget _buildLoginWithSavedAccounts() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Welcome back",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 24),

        SwitchAccountSheet(
          accounts: _savedAccounts,
          onSelect: (user) async {
            final switchedUser = await DI.authRepository.switchAccount(user);
            if (!mounted) return;
            setState(() {
              _userModel = switchedUser;
            });
          },
          onAddAccount: () async {
            await DI.authRepository.disconnectGoogle();
            await _handleGoogleSignIn();
          },
        ),
      ],
    );
  }

  Widget _buildLoginWithAccount() {
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
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _userModel!.email,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _continueUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B8CEE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Continue as ${_userModel!.displayName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton(
            onPressed: _showSwitchAccountSheet,
            child: const Text(
              "Switch Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

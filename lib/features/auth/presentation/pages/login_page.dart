import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/core/helper/presentation_helper.dart';
import 'package:smart_interview_ai/core/widgets/snackbar/custom_snackbar.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await DI.authRepository.loginWithGoogle();

      if (mounted) {
        if (user != null) {
          // Navigate to home page on success
          // Navigate to home page on success
          context.router.replace(const HomeRoute());
        } else {
          // Canceled by user
          PresentationHelper.showCustomSnackBar(
            context: context,
            message: 'Sign in canceled',
            type: SnackbarType.info,
          );
        }
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or App Name
              const Icon(
                Icons.mic_none_outlined,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 24),
              Text(
                'Smart Interview AI',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _handleGoogleSignIn,
                    icon: Image.network(
                      'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg', // Placeholder for icon asset
                      // Since we don't have assets yet, we'll use a standard icon or text
                      // For this task, let's use a standard Icon because network image might fail without internet permission configured or valid url
                      // Actually, let's use a standard icon for safety.
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.login),
                    ),
                    // Better to use Icons.login for now to avoid asset issues unless we add one
                    label: const Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

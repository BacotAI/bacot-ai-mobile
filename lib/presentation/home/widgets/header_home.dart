import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/application/auth/auth_bloc.dart';
import 'package:smart_interview_ai/presentation/home/widgets/avatar_home.dart';

class HeaderHome extends StatefulWidget {
  const HeaderHome({super.key});

  @override
  State<HeaderHome> createState() => _HeaderHomeState();
}

class _HeaderHomeState extends State<HeaderHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final user = state.user;

              return AvatarHome(
                avatar: user.photoUrl.toString(),
                name: user.displayName,
                email: user.email,
              );
            }

            if (state is AuthLoading) {
              return const CircularProgressIndicator();
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}

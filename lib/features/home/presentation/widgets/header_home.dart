import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/features/home/presentation/cubit/home_cubit.dart';
import 'package:smart_interview_ai/features/home/presentation/cubit/home_state.dart';
import 'package:smart_interview_ai/features/home/presentation/widgets/avatar_home.dart';

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
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              final users = state.user;
              return AvatarHome(
                avatar: users.photoUrl.toString(),
                name: users.displayName,
                email: users.email,
              );
            }
            if (state is HomeError) {
              return Text(state.message);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}

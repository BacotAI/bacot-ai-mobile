import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/core/config/app_colors.dart';
import 'package:smart_interview_ai/application/sample/sample_bloc.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SampleBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sample BLoC')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FetchButton(),
              const SizedBox(height: 12),
              const Expanded(child: _UserList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _FetchButton extends StatelessWidget {
  const _FetchButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SampleBloc, SampleState>(
      builder: (context, state) {
        final isLoading = state is SampleLoading;
        return Column(
          children: [
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => context.read<SampleBloc>().add(
                      const SampleUsersRequested(),
                    ),
              child: const Text('Fetch Users'),
            ),
            if (isLoading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
          ],
        );
      },
    );
  }
}

class _UserList extends StatelessWidget {
  const _UserList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SampleBloc, SampleState>(
      builder: (context, state) {
        if (state is SampleError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        } else if (state is SampleLoaded) {
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                leading: CircleAvatar(child: Text('${user.id}')),
              );
            },
          );
        }
        return const Center(child: Text('Press button to load users'));
      },
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/app/di.dart';
import '../cubit/pre_interview_cubit.dart';
import '../cubit/pre_interview_state.dart';
import '../widgets/question_card.dart';

@RoutePage()
class PreInterviewPage extends StatelessWidget {
  const PreInterviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PreInterviewCubit>()..loadQuestions(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E293B),
            ),
            onPressed: () => context.router.back(),
          ),
          title: const Text(
            'Persiapan Interview',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<PreInterviewCubit, PreInterviewState>(
          builder: (context, state) {
            if (state is PreInterviewLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
              );
            }

            if (state is PreInterviewError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Terjadi kesalahan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<PreInterviewCubit>().loadQuestions(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is PreInterviewLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: state.questions.length,
                itemBuilder: (context, index) {
                  return QuestionCard(question: state.questions[index]);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

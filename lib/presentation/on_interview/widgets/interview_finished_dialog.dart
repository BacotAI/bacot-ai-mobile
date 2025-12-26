import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:smart_interview_ai/application/on_interview/on_interview_bloc.dart';
import 'package:smart_interview_ai/domain/pre_interview/entities/question_entity.dart';
import 'package:smart_interview_ai/domain/transcription/entities/transcription_status.dart';

class InterviewFinishedDialog extends StatelessWidget {
  final OnInterviewFinished initialState;
  final List<QuestionEntity> questions;
  final OnInterviewBloc bloc;

  const InterviewFinishedDialog({
    super.key,
    required this.initialState,
    required this.questions,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<OnInterviewBloc, OnInterviewState>(
        builder: (context, state) {
          final currentState = (state is OnInterviewFinished)
              ? state
              : initialState;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Interview Selesai'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withAlpha(50)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.remove_red_eye,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Skor Mata: ${(currentState.finalResult.eyeContactScore * 100).toInt()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Feedback:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(currentState.finalResult.feedbackMessage),
                    const SizedBox(height: 24),
                    const Text(
                      'Transkripsi Jawaban:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(questions.length, (index) {
                      final transcription = currentState.transcriptions[index];
                      final status = currentState.transcriptionStatuses[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withAlpha(30)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pertanyaan ${index + 1}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              questions[index].text,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                              ),
                            ),
                            const Divider(height: 20),
                            if (status == TranscriptionStatus.completed)
                              Text(
                                transcription ?? 'Tidak ada teks.',
                                style: const TextStyle(fontSize: 14),
                              )
                            else
                              const Text(
                                'Gagal mentranskripsi.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.read<OnInterviewBloc>().add(
                    const OnInterviewSessionCleared(),
                  );
                  context.router.popUntilRoot();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          );
        },
      ),
    );
  }
}

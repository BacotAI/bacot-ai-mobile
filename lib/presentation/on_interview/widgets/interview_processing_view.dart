import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/application/on_interview/on_interview_bloc.dart';
import 'package:smart_interview_ai/core/utils/sizes.dart';
import 'package:smart_interview_ai/domain/transcription/entities/transcription_status.dart';

class InterviewProcessingView extends StatelessWidget {
  const InterviewProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnInterviewBloc, OnInterviewState>(
      builder: (context, state) {
        final transcriptionStatuses = state is OnInterviewProcessing
            ? state.transcriptionStatuses
            : (state is OnInterviewFinished
                  ? state.transcriptionStatuses
                  : <int, TranscriptionStatus>{});

        // Calculate progress percentage
        int completedCount = transcriptionStatuses.values
            .where((s) => s == TranscriptionStatus.completed)
            .length;
        int totalCount = transcriptionStatuses.length;
        int progressPercent = totalCount > 0
            ? (completedCount * 100 ~/ totalCount)
            : 0;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: SizesApp.margin * 4),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            // Illustration Container
                            _ProcessingIllustration(),
                            const SizedBox(height: 48),

                            const Text(
                              "Analyzing Context",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "\"Turning your thoughts into insights\"",
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF64748B),
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                            const SizedBox(height: 48),

                            // Progress Breakdown Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "PROGRESS BREAKDOWN",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF94A3B8),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F7FF),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "$progressPercent%",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00C2FF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Progress List
                            if (totalCount == 0)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Preparing question analysis...",
                                  style: TextStyle(color: Color(0xFF64748B)),
                                ),
                              ),

                            ...transcriptionStatuses.entries.map((entry) {
                              final index = entry.key;
                              final status = entry.value;
                              return _StatusItem(
                                title: "Question ${index + 1}",
                                subtitle: _getStatusText(status),
                                status: status,
                              );
                            }),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getStatusText(TranscriptionStatus status) {
    switch (status) {
      case TranscriptionStatus.idle:
        return "Pending";
      case TranscriptionStatus.processing:
        return "Processing...";
      case TranscriptionStatus.completed:
        return "Complete";
      case TranscriptionStatus.failed:
        return "Failed";
    }
  }
}

class _ProcessingIllustration extends StatefulWidget {
  @override
  State<_ProcessingIllustration> createState() =>
      _ProcessingIllustrationState();
}

class _ProcessingIllustrationState extends State<_ProcessingIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 240,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00C2FF).withAlpha(30),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(12, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double step = 1.0 / 16.0;
                  double start = index * step;
                  double end = (index + 4.0) * step;

                  double value = Interval(
                    start.clamp(0.0, 1.0),
                    end.clamp(0.0, 1.0),
                    curve: Curves.easeInOutCubic,
                  ).transform(_controller.value);

                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        const Color(0xFFF1F5F9), // Inactive color
                        const Color(0xFF00C2FF), // Active color
                        value,
                      ),
                      boxShadow: value > 0.1
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF00C2FF,
                                ).withAlpha((20 * value).toInt()),
                                blurRadius: 8 * value,
                                spreadRadius: 2 * value,
                              ),
                            ]
                          : null,
                    ),
                  );
                },
              );
            }),
          ),
        ),

        Positioned(
          bottom: -15,
          right: -10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulsingDot(),
                const SizedBox(width: 8),
                const Text(
                  "Transcribing",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(
              0xFF00C2FF,
            ).withAlpha(30 + (_controller.value * 70).toInt()),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF00C2FF,
                ).withAlpha(50 + (_controller.value * 70).toInt()),
                blurRadius: 4,
                spreadRadius: 2 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final TranscriptionStatus status;

  const _StatusItem({
    required this.title,
    required this.subtitle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color iconBgColor;
    Widget icon;
    bool isProcessing = status == TranscriptionStatus.processing;

    switch (status) {
      case TranscriptionStatus.completed:
        iconBgColor = const Color(0xFF22C55E);
        icon = const Icon(Icons.check, size: 16, color: Colors.white);
        break;
      case TranscriptionStatus.processing:
        iconBgColor = const Color(0xFFE0F7FF);
        icon = const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00C2FF)),
          ),
        );
        break;
      case TranscriptionStatus.failed:
        iconBgColor = const Color(0xFFEF4444);
        icon = const Icon(Icons.error_outline, size: 16, color: Colors.white);
        break;
      default:
        iconBgColor = const Color(0xFFF1F5F9);
        icon = const Icon(
          Icons.lock_outline,
          size: 16,
          color: Color(0xFF94A3B8),
        );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isProcessing
              ? const Color(0xFF00C2FF).withAlpha(30)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBgColor,
            ),
            child: Center(child: icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: status == TranscriptionStatus.completed
                        ? const Color(0xFF22C55E)
                        : isProcessing
                        ? const Color(0xFF00C2FF)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          _StatusBars(status: status),
        ],
      ),
    );
  }
}

class _StatusBars extends StatelessWidget {
  final TranscriptionStatus status;

  const _StatusBars({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        Color barColor;
        switch (status) {
          case TranscriptionStatus.completed:
            barColor = const Color(0xFF22C55E);
            break;
          case TranscriptionStatus.processing:
            barColor = index < 2
                ? const Color(0xFF00C2FF)
                : const Color(0xFFE2E8F0);
            break;
          default:
            barColor = const Color(0xFFE2E8F0);
        }
        return Container(
          width: 4,
          height: 16,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

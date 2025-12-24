import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/features/pre_interview/presentation/widgets/question_card.dart
import 'package:smart_interview_ai/features/pre_interview/domain/entities/question_entity.dart';
=======
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/domain/pre_interview/entities/question_entity.dart';
>>>>>>> main:lib/presentation/pre_interview/widgets/question_card.dart
import 'keyword_chip.dart';

class QuestionCard extends StatefulWidget {
  final QuestionEntity question;

  const QuestionCard({super.key, required this.question});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  bool _showInsight = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleInsight() {
    setState(() {
      _showInsight = !_showInsight;
      if (_showInsight) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Color _getDifficultyColor(QuestionDifficulty difficulty) {
    switch (difficulty) {
      case QuestionDifficulty.easy:
        return const Color(0xFF10B981); // Emerald
      case QuestionDifficulty.tricky:
        return const Color(0xFFF59E0B); // Amber
      case QuestionDifficulty.hard:
        return const Color(0xFFEF4444); // Red
    }
  }

  String _getDifficultyLabel(QuestionDifficulty difficulty) {
    switch (difficulty) {
      case QuestionDifficulty.easy:
        return 'Easy';
      case QuestionDifficulty.tricky:
        return 'Tricky';
      case QuestionDifficulty.hard:
        return 'Hard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(24),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(
                          widget.question.difficulty,
                        ).withAlpha(255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getDifficultyLabel(widget.question.difficulty),
                        style: TextStyle(
                          color: _getDifficultyColor(
                            widget.question.difficulty,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.question.estimatedDurationSeconds}s',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _toggleInsight,
                      style: IconButton.styleFrom(
                        backgroundColor: _showInsight
                            ? const Color(0xFFFDF2F2)
                            : const Color(0xFFFFFBEB),
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: Icon(
                        _showInsight
                            ? Icons.lightbulb
                            : Icons.lightbulb_outline,
                        color: _showInsight
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFFF59E0B),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.question.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFEF3C7)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.psychology_outlined,
                              size: 18,
                              color: Color(0xFFD97706),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Behind The Question',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD97706),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.question.hrInsight,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber[900],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'SUGGESTED POWER WORDS',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.question.powerWords
                      .map((word) => KeywordChip(label: word))
                      .toList(),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1E293B)),
                            foregroundColor: const Color(0xFF1E293B),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.accessibility_new_rounded,
                            size: 20,
                          ),
                          label: const Text(
                            'Siap Persiapan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E293B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.videocam_rounded, size: 20),
                          label: const Text(
                            'Mulai Latihan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.question.communityStats,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

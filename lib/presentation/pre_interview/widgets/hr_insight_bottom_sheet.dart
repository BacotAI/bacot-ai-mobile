import 'package:flutter/material.dart';
import 'package:smart_interview_ai/core/widgets/premium/premium_blur_wrapper.dart';

class HrInsightBottomSheet extends StatelessWidget {
  final String question;
  final String recruiterIntent;
  final String strategyMethod;
  final String strategyDescription;
  final bool isPremium;

  const HrInsightBottomSheet({
    super.key,
    required this.question,
    required this.recruiterIntent,
    required this.strategyMethod,
    required this.strategyDescription,
    this.isPremium = false,
  });

  static Future<void> show(
    BuildContext context, {
    required String question,
    required String recruiterIntent,
    required String strategyMethod,
    required String strategyDescription,
    bool isPremium = false,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => HrInsightBottomSheet(
        question: question,
        recruiterIntent: recruiterIntent,
        strategyMethod: strategyMethod,
        strategyDescription: strategyDescription,
        isPremium: isPremium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle & Header - Always visible
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildHeader(context),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Content - Gated by PremiumBlurWrapper
          Expanded(
            child: PremiumBlurWrapper(
              isPremium: isPremium,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Question Card
                    _buildCurrentQuestionCard(),
                    const SizedBox(height: 20),

                    // Tags
                    _buildTags(),
                    const SizedBox(height: 32),

                    // Recruiter Intent Section
                    _buildSectionHeader(
                      icon: Icons.track_changes_rounded,
                      title: 'Recruiter Intent',
                      color: const Color(0xFF06B6D4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      recruiterIntent,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF475569), // Slate 600
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Winning Strategy Card
                    _buildWinningStrategyCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // AI Icon
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 28,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Titles
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'HR Insight',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 12,
                    color: Color(0xFF8B5CF6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'AI COACH ANALYSIS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF64748B),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Close Button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 20,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentQuestionCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gradient Left Border
              Container(
                width: 6,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_rounded,
                            size: 14,
                            color: Color(0xFF06B6D4),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'CURRENT QUESTION',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF06B6D4),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '"$question"',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildChip(
          icon: Icons.handshake_rounded,
          label: 'Conflict Resolution',
          color: const Color(0xFF10B981), // Emerald
        ),
        _buildChip(
          icon: Icons.favorite_rounded,
          label: 'Emotional Intelligence',
          color: const Color(0xFFEC4899), // Pink
        ),
      ],
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildWinningStrategyCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4F46E5), // Indigo 600
            const Color(0xFF7C3AED), // Purple 600
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withAlpha(40),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFFFFD700),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Winning Strategy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withAlpha(210),
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'Structure your answer with the '),
                TextSpan(
                  text: strategyMethod,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF22D3EE), // Cyan 400
                  ),
                ),
                const TextSpan(text: '. '),
                TextSpan(text: strategyDescription),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

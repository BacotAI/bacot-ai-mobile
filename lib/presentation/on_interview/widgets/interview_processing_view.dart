import 'package:flutter/material.dart';

class InterviewProcessingView extends StatelessWidget {
  const InterviewProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Premium Loading Animation
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00C2FF)),
                backgroundColor: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 32),
            // Status Text
            const Text(
              "Finishing Interview...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Saving your recordings securely",
              style: TextStyle(
                color: Colors.white.withAlpha(150),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

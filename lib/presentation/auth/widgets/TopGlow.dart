import 'package:flutter/material.dart';

class Topglow extends StatelessWidget {
  const Topglow({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -160,
      left: -120,
      child: Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Color(0xFFC4B5FD).withValues(alpha: 0.45),
              const Color(0xFFEDE9FE).withValues(alpha: 0.0),
            ],
            stops: [0.0, 0.65],
          ),
        ),
      ),
    );
  }
}

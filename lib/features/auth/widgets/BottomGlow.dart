import 'package:flutter/material.dart';

class Bottomglow extends StatelessWidget {
  const Bottomglow({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -200,
      right: -140,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Color(0xFF7DD3FC).withValues(alpha: 0.40),
              const Color(0xFFEDE9FE).withValues(alpha: 0.0),
            ],
            stops: [0.0, 0.7],
          ),
        ),
      ),
    );
  }
}

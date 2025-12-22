import 'package:flutter/material.dart';
import 'briefing_tag.dart';

class BriefingCard extends StatelessWidget {
  final String title;
  final String description;
  final List<BriefingTag> tags;
  final Widget? icon;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final bool isLocked;
  final bool isActive;

  const BriefingCard({
    super.key,
    required this.title,
    required this.description,
    this.tags = const [],
    this.icon,
    this.actionLabel,
    this.actionIcon,
    this.onActionPressed,
    this.isLocked = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: isActive
            ? Border.all(color: const Color(0xFF0EA5E9).withAlpha(50), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isLocked ? 5 : 10),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Wrap(spacing: 8, children: tags),
                  const Spacer(),
                  if (icon != null) icon!,
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isLocked
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: isLocked
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: 24),
                Material(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: isLocked ? null : onActionPressed,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          if (actionIcon != null) ...[
                            Icon(
                              actionIcon,
                              size: 20,
                              color: const Color(0xFF0EA5E9),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Text(
                            actionLabel!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: Color(0xFFCBD5E1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              if (isActive && !isLocked) ...[
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=2671&auto=format&fit=crop',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withAlpha(100),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(220),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.psychology_rounded,
                              size: 18,
                              color: Color(0xFF0EA5E9),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'STAR Method Hint',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

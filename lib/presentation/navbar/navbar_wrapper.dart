import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/presentation/navbar/widgets/navbar_item.dart';

@RoutePage()
class NavbarWrapperPage extends StatefulWidget {
  final GlobalKey? homeKey;
  final GlobalKey? plusKey;
  final GlobalKey? profileKey;

  const NavbarWrapperPage({
    super.key,
    this.homeKey,
    this.plusKey,
    this.profileKey,
  });

  @override
  State<NavbarWrapperPage> createState() => _NavbarWrapperPageState();
}

class _NavbarWrapperPageState extends State<NavbarWrapperPage> {
  late final GlobalKey _homeKey = widget.homeKey ?? GlobalKey();
  late final GlobalKey _plusKey = widget.plusKey ?? GlobalKey();
  late final GlobalKey _profileKey = widget.profileKey ?? GlobalKey();

  late TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      builder: (context, child) {
        tabsRouter = AutoTabsRouter.of(context);

        final topRoute = context.topRoute;
        final hideBottomNav = topRoute.meta['hideBottomNav'] == true;

        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              child,
              if (!hideBottomNav)
                Align(alignment: Alignment.bottomCenter, child: _buildNavbar()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavbar() {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 90,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            /// 🔥 GLASS CONTAINER
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NavbarItem(
                          key: _homeKey,
                          icon: Icons.home,
                          label: 'Home',
                          isActive: tabsRouter.activeIndex == 0,
                          onTap: () => tabsRouter.setActiveIndex(0),
                        ),
                        const SizedBox(width: 48),
                        NavbarItem(
                          key: _profileKey,
                          icon: Icons.person,
                          label: 'Profile',
                          isActive: tabsRouter.activeIndex == 2,
                          onTap: () => tabsRouter.setActiveIndex(2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// ➕ FLOATING PLUS BUTTON
            Positioned(
              bottom: 28,
              child: GestureDetector(
                key: _plusKey,
                onTap: () => tabsRouter.setActiveIndex(1),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0B132B),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

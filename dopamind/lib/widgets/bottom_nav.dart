import 'package:flutter/material.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:dopamind/theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final AppScreen currentScreen;
  final void Function(AppScreen) onNavigate;

  const BottomNav({
    super.key,
    required this.currentScreen,
    required this.onNavigate,
  });

  static const _navItems = [
    _NavItem(id: AppScreen.dashboard, label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
    _NavItem(id: AppScreen.analytics, label: 'Analytics', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart),
    _NavItem(id: AppScreen.focusMode, label: 'Focus', icon: Icons.shield_outlined, activeIcon: Icons.shield),
    _NavItem(id: AppScreen.habitCoach, label: 'Coach', icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome),
    _NavItem(id: AppScreen.settings, label: 'Settings', icon: Icons.settings_outlined, activeIcon: Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.95),
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.map((item) {
              final isActive = currentScreen == item.id;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onNavigate(item.id),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? theme.colorScheme.primary.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isActive ? item.activeIcon : item.icon,
                              size: 24,
                              color: isActive
                                  ? AppColors.darkPrimary
                                  : Colors.white54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive
                              ? AppColors.darkPrimary
                              : Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final AppScreen id;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

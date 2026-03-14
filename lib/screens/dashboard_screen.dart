import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:dopamind/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showAlert = true;
  late Timer _timer;
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateGreeting());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        _greeting = 'Good morning';
      } else if (hour < 18) {
        _greeting = 'Good afternoon';
      } else {
        _greeting = 'Good evening';
      }
    });
  }

  Color _getScoreColor(int score) {
    if (score >= 70) return AppColors.dopamineLow;
    if (score >= 50) return AppColors.dopamineMedium;
    return AppColors.dopamineHigh;
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 50) return 'Moderate';
    return 'Needs Attention';
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final scoreColor = _getScoreColor(store.currentDopamineScore);
    final focusProgress = (155 / store.dailyFocusGoal) * 100;
    final topDistracting = store.appUsage
        .where((app) => app.dopamineImpact == 'high')
        .take(3)
        .toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting,
                        style: TextStyle(color: mutedFg, fontSize: 14),
                      ),
                      Text(
                        store.userName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => store.setScreen(AppScreen.settings),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: muted,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          store.userName.isNotEmpty
                              ? store.userName[0].toUpperCase()
                              : '?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // AI Alert
            if (_showAlert)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.chart5Light.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.chart5Light.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.chart5Light.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.warning_amber,
                          size: 18,
                          color: AppColors.chart5Light,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'High dopamine activity detected',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "You've been scrolling for 25 minutes. Consider taking a break.",
                              style: TextStyle(color: mutedFg, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _showAlert = false),
                        child: Icon(Icons.close, size: 20, color: mutedFg),
                      ),
                    ],
                  ),
                ),
              ),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Dopamine Score Card
                  _buildCard(
                    theme: theme,
                    border: border,
                    isDark: isDark,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.psychology, size: 20, color: mutedFg),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Dopamine Score',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _getScoreLabel(store.currentDopamineScore),
                                style: TextStyle(
                                  color: scoreColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${store.currentDopamineScore}',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w600,
                                  color: scoreColor,
                                  letterSpacing: -1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '/100',
                                  style: TextStyle(color: mutedFg, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(Icons.trending_down, size: 16, color: AppColors.dopamineLow),
                              const SizedBox(width: 8),
                              Text(
                                '3% better than yesterday',
                                style: TextStyle(color: mutedFg, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Focus Mode Quick Actions
                  _buildCard(
                    theme: theme,
                    border: border,
                    isDark: isDark,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.shield_outlined, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Focus Mode',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              for (final mode in [FocusMode.study, FocusMode.work, FocusMode.detox])
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: mode != FocusMode.detox ? 8 : 0,
                                    ),
                                    child: _buildFocusModeButton(
                                      store: store,
                                      mode: mode,
                                      theme: theme,
                                      isDark: isDark,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (store.focusMode != FocusMode.off) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: muted.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.focusActive,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_focusModeLabel(store.focusMode)} Mode Active',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Daily Progress
                  _buildCard(
                    theme: theme,
                    border: border,
                    isDark: isDark,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: mutedFg),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Focus Time Today',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '155m / ${store.dailyFocusGoal}m',
                                style: TextStyle(color: mutedFg, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: focusProgress / 100,
                              minHeight: 8,
                              backgroundColor: muted,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${store.dailyFocusGoal - 155} minutes to reach your goal',
                              style: TextStyle(color: mutedFg, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // High Dopamine Apps
                  _buildCard(
                    theme: theme,
                    border: border,
                    isDark: isDark,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.bolt, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'High Dopamine Apps',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => store.setScreen(AppScreen.analytics),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Row(
                                  children: [
                                    Text('View All', style: TextStyle(fontSize: 12, color: mutedFg)),
                                    Icon(Icons.chevron_right, size: 14, color: mutedFg),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...topDistracting.map(
                            (app) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: muted,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(app.icon, style: const TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          app.appName,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${app.usageMinutes} min today',
                                          style: TextStyle(color: mutedFg, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 64,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: (app.usageMinutes / 120).clamp(0.0, 1.0),
                                        minHeight: 6,
                                        backgroundColor: muted,
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          AppColors.dopamineHigh,
                                        ),
                                      ),
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
                  const SizedBox(height: 16),

                  // AI Habit Coach CTA
                  GestureDetector(
                    onTap: () => store.setScreen(AppScreen.habitCoach),
                    child: _buildCard(
                      theme: theme,
                      border: border,
                      isDark: isDark,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.chart2Light.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 24,
                                color: AppColors.chart2Light,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI Habit Coach',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Get personalized suggestions to improve focus',
                                    style: TextStyle(color: mutedFg, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 20, color: mutedFg),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required ThemeData theme,
    required Color border,
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }

  Widget _buildFocusModeButton({
    required AppStore store,
    required FocusMode mode,
    required ThemeData theme,
    required bool isDark,
  }) {
    final isActive = store.focusMode == mode;
    return SizedBox(
      height: 40,
      child: isActive
          ? ElevatedButton(
              onPressed: () => store.setFocusMode(FocusMode.off),
              child: Text(_focusModeLabel(mode)),
            )
          : OutlinedButton(
              onPressed: () => store.setFocusMode(mode),
              child: Text(_focusModeLabel(mode)),
            ),
    );
  }

  String _focusModeLabel(FocusMode mode) {
    switch (mode) {
      case FocusMode.study:
        return 'Study';
      case FocusMode.work:
        return 'Work';
      case FocusMode.detox:
        return 'Detox';
      case FocusMode.off:
        return 'Off';
    }
  }
}

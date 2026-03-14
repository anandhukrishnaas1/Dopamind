import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:dopamind/theme/app_theme.dart';

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({super.key});

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _smartActivation = true;
  bool _scheduleEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startTimerIfNeeded();
  }

  void _startTimerIfNeeded() {
    final store = context.read<AppStore>();
    if (store.focusMode != FocusMode.off && store.focusModeStartTime != null) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            _elapsedSeconds = DateTime.now()
                .difference(store.focusModeStartTime!)
                .inSeconds;
          });
        }
      });
    } else {
      _timer?.cancel();
      _elapsedSeconds = 0;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final hrs = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hrs > 0) {
      return '$hrs:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${mins.toString()}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final focusModes = [
      _FocusModeData(
        id: FocusMode.study,
        name: 'Study Mode',
        description: 'Block social media and entertainment apps',
        icon: Icons.menu_book_outlined,
        blockedApps: ['Instagram', 'TikTok', 'Twitter', 'YouTube', 'Netflix'],
        color: AppColors.chart1,
      ),
      _FocusModeData(
        id: FocusMode.work,
        name: 'Work Mode',
        description: 'Allow productivity tools, block distractions',
        icon: Icons.work_outline,
        blockedApps: ['TikTok', 'Instagram', 'Games', 'Netflix'],
        color: AppColors.chart2,
      ),
      _FocusModeData(
        id: FocusMode.detox,
        name: 'Digital Detox',
        description: 'Block all non-essential apps',
        icon: Icons.eco_outlined,
        blockedApps: ['All Social Media', 'All Entertainment', 'All Games'],
        color: AppColors.chart3,
      ),
    ];

    final activeMode = focusModes.where((m) => m.id == store.focusMode).firstOrNull;

    // Restart timer when focus mode changes
    if (store.focusMode != FocusMode.off && _timer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startTimerIfNeeded());
    } else if (store.focusMode == FocusMode.off && _timer != null) {
      _timer?.cancel();
      _timer = null;
      _elapsedSeconds = 0;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Focus Mode',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Block distractions and stay focused',
                    style: TextStyle(color: mutedFg, fontSize: 14),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active Session
                  if (store.focusMode != FocusMode.off && activeMode != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.darkPrimary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: activeMode.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(activeMode.icon, size: 24, color: activeMode.color),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activeMode.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.circle, size: 8, color: AppColors.darkPrimary),
                                      const SizedBox(width: 4),
                                      const Text('Active Now',
                                          style: TextStyle(color: Colors.white54, fontSize: 13)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            _formatTime(_elapsedSeconds),
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              letterSpacing: -2,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Session Duration',
                            style: TextStyle(color: Colors.white38, fontSize: 14),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _circleButton(
                                icon: Icons.pause,
                                onTap: () => store.setFocusMode(FocusMode.off),
                                border: border,
                                isDark: isDark,
                              ),
                              const SizedBox(width: 16),
                              _circleButton(
                                icon: Icons.replay,
                                onTap: () {
                                  final mode = store.focusMode;
                                  store.setFocusMode(FocusMode.off);
                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () => store.setFocusMode(mode),
                                  );
                                },
                                border: border,
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Mode Selection
                  Text(
                    'Select Mode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: mutedFg,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...focusModes.map((mode) {
                    final isActive = store.focusMode == mode.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => store.setFocusMode(
                            isActive ? FocusMode.off : mode.id),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : AppColors.lightCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive
                                  ? theme.colorScheme.primary
                                  : border,
                              width: isActive ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: mode.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(mode.icon, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(mode.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        if (isActive)
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.check,
                                                size: 14,
                                                color:
                                                    theme.colorScheme.onPrimary),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(mode.description,
                                        style: TextStyle(
                                            color: mutedFg, fontSize: 14)),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: [
                                        Icon(Icons.block,
                                            size: 12, color: mutedFg),
                                        ...mode.blockedApps.take(3).map(
                                              (app) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: muted,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(app,
                                                    style: const TextStyle(
                                                        fontSize: 12)),
                                              ),
                                            ),
                                        if (mode.blockedApps.length > 3)
                                          Text(
                                              '+${mode.blockedApps.length - 3} more',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: mutedFg)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 4),

                  // Quick Start
                  if (store.focusMode == FocusMode.off) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => store.setFocusMode(FocusMode.study),
                        icon: const Icon(Icons.play_arrow, size: 20),
                        label: const Text('Start Focus Session'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Focus Settings
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Focus Settings',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 16),
                        _settingRow(
                          'Smart Activation',
                          'Auto-activate when high dopamine detected',
                          _smartActivation,
                          (v) => setState(() => _smartActivation = v),
                          mutedFg,
                        ),
                        const SizedBox(height: 16),
                        _settingRow(
                          'Scheduled Sessions',
                          'Set recurring focus times',
                          _scheduleEnabled,
                          (v) => setState(() => _scheduleEnabled = v),
                          mutedFg,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Today's Focus
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: mutedFg),
                            const SizedBox(width: 8),
                            Text("Today's Focus",
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: muted.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text('2h 35m',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text('Total Focus Time',
                                        style: TextStyle(
                                            color: mutedFg, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: muted.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text('4',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text('Sessions Completed',
                                        style: TextStyle(
                                            color: mutedFg, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color border,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: border),
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _settingRow(String title, String subtitle, bool value,
      ValueChanged<bool> onChanged, Color mutedFg) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              Text(subtitle,
                  style: TextStyle(color: mutedFg, fontSize: 12)),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _FocusModeData {
  final FocusMode id;
  final String name;
  final String description;
  final IconData icon;
  final List<String> blockedApps;
  final Color color;

  _FocusModeData({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.blockedApps,
    required this.color,
  });
}

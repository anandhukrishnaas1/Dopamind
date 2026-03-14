import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:dopamind/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

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
                children: [
                  const Icon(Icons.settings_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Settings',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Profile Card
                  _buildCard(
                    border: border,
                    isDark: isDark,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                store.userName.isNotEmpty
                                    ? store.userName[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(store.userName,
                                    style: const TextStyle(fontWeight: FontWeight.w500)),
                                Text(store.email,
                                    style: TextStyle(color: mutedFg, fontSize: 14)),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: const Text('Edit', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notifications
                  _buildSectionCard(
                    title: 'Notifications',
                    icon: Icons.notifications_outlined,
                    theme: theme,
                    border: border,
                    isDark: isDark,
                    children: [
                      _settingRow(
                        'Push Notifications',
                        'Get alerts for focus reminders',
                        store.notificationsEnabled,
                        () => store.toggleSetting('notificationsEnabled'),
                        mutedFg,
                      ),
                      const SizedBox(height: 16),
                      _settingRow(
                        'Daily Summary',
                        'Receive daily insights at 9 PM',
                        true,
                        () {},
                        mutedFg,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // AI & Behavior
                  _buildSectionCard(
                    title: 'AI & Behavior',
                    icon: Icons.psychology_outlined,
                    theme: theme,
                    border: border,
                    isDark: isDark,
                    children: [
                      _settingRow(
                        'Smart Interventions',
                        'AI-powered break suggestions',
                        store.smartInterventions,
                        () => store.toggleSetting('smartInterventions'),
                        mutedFg,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Prediction Sensitivity',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                Text('How early to detect patterns',
                                    style: TextStyle(
                                        color: mutedFg, fontSize: 12)),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child:
                                const Text('Adjust', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _settingRow(
                        'Infinite Scroll Detection',
                        'Alert during long scroll sessions',
                        true,
                        () {},
                        mutedFg,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Appearance
                  _buildSectionCard(
                    title: 'Appearance',
                    icon: Icons.dark_mode_outlined,
                    theme: theme,
                    border: border,
                    isDark: isDark,
                    children: [
                      _settingRow(
                        'Dark Mode',
                        'Switch to dark theme',
                        store.darkMode,
                        () => store.toggleSetting('darkMode'),
                        mutedFg,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Privacy & Security
                  _buildSectionCard(
                    title: 'Privacy & Security',
                    icon: Icons.shield_outlined,
                    theme: theme,
                    border: border,
                    isDark: isDark,
                    children: [
                      _navRow('Data & Privacy', mutedFg, muted),
                      _navRow('Export Your Data', mutedFg, muted),
                      _navRow('Delete Account', mutedFg, muted,
                          isDestructive: true),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Support
                  _buildSectionCard(
                    title: 'Support',
                    icon: Icons.help_outline,
                    theme: theme,
                    border: border,
                    isDark: isDark,
                    children: [
                      _navRowWithIcon(Icons.help_outline, 'Help Center', mutedFg, muted),
                      _navRowWithIcon(Icons.mail_outline, 'Contact Us', mutedFg, muted),
                      _navRowWithIcon(Icons.description_outlined, 'Terms & Privacy Policy', mutedFg, muted),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sign Out
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => store.logout(),
                      icon: Icon(Icons.logout,
                          size: 18, color: isDark ? AppColors.darkDestructive : AppColors.lightDestructive),
                      label: Text(
                        'Sign Out',
                        style: TextStyle(
                          color: isDark ? AppColors.darkDestructive : AppColors.lightDestructive,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Version
                  Center(
                    child: Text(
                      'DopamineOS v1.0.0',
                      style: TextStyle(color: mutedFg, fontSize: 12),
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

  Widget _buildCard(
      {required Color border, required bool isDark, required Widget child}) {
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required Color border,
    required bool isDark,
    required List<Widget> children,
  }) {
    return _buildCard(
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
                  Icon(icon, size: 16),
                  const SizedBox(width: 8),
                  Text(title,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _settingRow(String title, String subtitle, bool value,
      VoidCallback onChanged, Color mutedFg) {
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
        Switch(value: value, onChanged: (_) => onChanged()),
      ],
    );
  }

  Widget _navRow(String title, Color mutedFg, Color muted,
      {bool isDestructive = false}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isDestructive ? AppColors.lightDestructive : null,
              ),
            ),
            Icon(Icons.chevron_right,
                size: 18,
                color: isDestructive ? AppColors.lightDestructive : mutedFg),
          ],
        ),
      ),
    );
  }

  Widget _navRowWithIcon(
      IconData icon, String title, Color mutedFg, Color muted) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: mutedFg),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
            Icon(Icons.chevron_right, size: 18, color: mutedFg),
          ],
        ),
      ),
    );
  }
}

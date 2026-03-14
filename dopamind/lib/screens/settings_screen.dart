import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:dopamind/theme/app_theme.dart';
import 'package:dopamind/screens/terms_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showEditProfile(BuildContext context, AppStore store) {
    final nameController = TextEditingController(text: store.userName);
    final ageController = TextEditingController(text: store.age.toString());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: Text('Edit Profile', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name', 
                labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Age', 
                labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final age = int.tryParse(ageController.text) ?? store.age;
              store.updateProfile(nameController.text, age);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final mutedBg = isDark ? AppColors.darkMuted : AppColors.lightMuted;

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
                    theme: theme,
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
                            onPressed: () => _showEditProfile(context, store),
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                        store.dailySummary,
                        () => store.toggleSetting('dailySummary'),
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
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sensitivity adjusted to high'))
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                        store.infiniteScrollDetection,
                        () => store.toggleSetting('infiniteScrollDetection'),
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
                    children: [
                      _navRow('Data & Privacy', mutedFg, onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsPolicyScreen()));
                      }),
                      _navRow('Export Your Data', mutedFg, onTap: () {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data export started...')));
                      }),
                      _navRow('Delete Account', mutedFg,
                          isDestructive: true, onTap: () {
                             showDialog(
                               context: context,
                               builder: (context) => AlertDialog(
                                 backgroundColor: theme.cardTheme.color,
                                 title: const Text('Delete Account?'),
                                 content: const Text('This action cannot be undone.'),
                                 actions: [
                                   TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                   TextButton(onPressed: () => Navigator.pop(context), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                 ],
                               )
                             );
                          }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Support
                  _buildSectionCard(
                    title: 'Support',
                    icon: Icons.help_outline,
                    theme: theme,
                    children: [
                      _navRowWithIcon(Icons.help_outline, 'Help Center', mutedFg, onTap: () {}),
                      _navRowWithIcon(Icons.mail_outline, 'Contact Us', mutedFg, onTap: () {}),
                      _navRowWithIcon(Icons.description_outlined, 'Terms & Privacy Policy', mutedFg, onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsPolicyScreen()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sign Out
                  SizedBox(
                    width: double.infinity,
                    height: 56,
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
                        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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

  Widget _buildCard({required ThemeData theme, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: theme.cardTheme.shape is RoundedRectangleBorder 
          ? Border.fromBorderSide((theme.cardTheme.shape as RoundedRectangleBorder).side)
          : null,
      ),
      child: child,
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return _buildCard(
      theme: theme,
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

  Widget _navRow(String title, Color mutedFg, {bool isDestructive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
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
      IconData icon, String title, Color mutedFg, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
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

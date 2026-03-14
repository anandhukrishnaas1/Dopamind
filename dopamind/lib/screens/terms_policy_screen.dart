import 'package:flutter/material.dart';
import 'package:dopamind/theme/app_theme.dart';

class TermsPolicyScreen extends StatelessWidget {
  const TermsPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Terms & Privacy Policy', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Privacy Policy',
              'Last updated: March 2024\n\nAt DopamineOS, we take your privacy seriously. This policy describes how we collect, use, and protect your data.\n\n1. Data Collection: We collect app usage statistics and screen time data locally on your device to provide insights. This data is synced to your private Firestore account if logged in.\n\n2. Usage: Your data is used exclusively to help you manage your digital behavior. We do not sell your data to third parties.\n\n3. Permissions: We require Usage Access and Notification permissions to function correctly.',
              mutedFg,
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Terms of Service',
              'By using DopamineOS, you agree to the following terms:\n\n1. Purpose: The app is intended for personal use to manage digital behavior.\n\n2. Limitation of Liability: We provide AI suggestions for wellness, but these are not medical advice.\n\n3. Responsible Use: You agree to use the app responsibly and not for any illegal purposes.',
              mutedFg,
            ),
            const SizedBox(height: 48),
            Center(
              child: Text(
                '© 2024 DopamineOS Team',
                style: TextStyle(color: mutedFg, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, Color mutedFg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: mutedFg,
          ),
        ),
      ],
    );
  }
}

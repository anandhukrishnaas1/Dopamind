import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:dopamind/theme/app_theme.dart';
import 'package:animate_do/animate_do.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final mutedBg = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    // Calculate real stats from store.appUsage
    final totalMinutes = store.appUsage.fold<int>(0, (sum, app) => sum + app.usageMinutes);
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    final screenTimeStr = hours > 0 ? '${hours}h ${mins}m' : '${mins}m';

    // Sort apps by usage for the horizontal list
    final topApps = [...store.appUsage]..sort((a, b) => b.usageMinutes.compareTo(a.usageMinutes));

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good afternoon,',
                        style: TextStyle(color: mutedFg, fontSize: 14),
                      ),
                      Text(
                        store.userName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: mutedBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none_outlined, size: 24),
                  ),
                ],
              ),
            ),

            // Dopamine Score Hero
            Padding(
              padding: const EdgeInsets.all(24),
              child: FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(24),
                    border: theme.cardTheme.shape is RoundedRectangleBorder 
                      ? Border.fromBorderSide((theme.cardTheme.shape as RoundedRectangleBorder).side)
                      : null,
                    boxShadow: isDark ? [] : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Current Dopamine Score',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: CircularProgressIndicator(
                              value: store.currentDopamineScore / 100,
                              strokeWidth: 12,
                              backgroundColor: mutedBg,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                store.currentDopamineScore > 70 
                                  ? AppColors.dopamineHigh 
                                  : store.currentDopamineScore > 40 
                                    ? AppColors.dopamineMedium 
                                    : AppColors.dopamineLow
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '${store.currentDopamineScore}',
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '/100',
                                style: TextStyle(color: mutedFg, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        store.currentDopamineScore > 70 
                          ? 'High Dopamine Activity Detected' 
                          : 'Maintaining Healthy Levels',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600,
                          color: store.currentDopamineScore > 70 ? AppColors.dopamineHigh : AppColors.dopamineLow
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store.currentDopamineScore > 70 
                          ? 'Consider taking a 15-minute focus break.'
                          : 'You are doing great! Keep it up.',
                        style: TextStyle(color: mutedFg, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _statCard('Focus Time', '0m', Icons.timer_outlined, AppColors.chart3, theme),
                  const SizedBox(width: 16),
                  _statCard('Screen Time', screenTimeStr, Icons.smartphone_outlined, AppColors.chart1, theme),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // High Dopamine Apps
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'High Impact Apps',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => store.setScreen(AppScreen.analytics),
                    child: Text(
                      'View All',
                      style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 120,
              child: topApps.isEmpty 
                ? Center(child: Text('No usage data yet', style: TextStyle(color: mutedFg)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: topApps.length,
                    itemBuilder: (context, index) {
                      final app = topApps[index];
                      return _appCard(app.appName, '${app.usageMinutes}m', app.icon, theme);
                    },
                  ),
            ),

            const SizedBox(height: 32),

            // Smart Interventions
            if (store.smartInterventions && store.currentDopamineScore > 70)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark 
                        ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                        : [Colors.white, Colors.grey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                    boxShadow: isDark ? [] : [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.chart1.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bolt, color: AppColors.chart1),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Smart Intervention',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 16, 
                                color: isDark ? Colors.white : Colors.black
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "High dopamine activity detected. Need a breather?",
                              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: isDark ? Colors.white38 : Colors.black26),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: theme.cardTheme.shape is RoundedRectangleBorder 
            ? Border.fromBorderSide((theme.cardTheme.shape as RoundedRectangleBorder).side)
            : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: theme.textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _appCard(String name, String time, String icon, ThemeData theme) {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: theme.cardTheme.shape is RoundedRectangleBorder 
          ? Border.fromBorderSide((theme.cardTheme.shape as RoundedRectangleBorder).side)
          : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13), overflow: TextOverflow.ellipsis),
          Text(time, style: TextStyle(color: theme.textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: 11)),
        ],
      ),
    );
  }
}

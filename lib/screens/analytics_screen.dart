import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:dopamind/theme/app_theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getDopamineColor(String impact) {
    switch (impact) {
      case 'high':
        return AppColors.dopamineHigh;
      case 'medium':
        return AppColors.dopamineMedium;
      case 'low':
        return AppColors.dopamineLow;
      default:
        return Colors.grey;
    }
  }

  String _dayLabel(String date) {
    final d = DateTime.parse(date);
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[d.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final avgScore = store.weeklyStats.fold<int>(0, (a, s) => a + s.dopamineScore) ~/
        store.weeklyStats.length;
    final avgFocus = store.weeklyStats.fold<int>(0, (a, s) => a + s.focusMinutes) ~/
        store.weeklyStats.length;
    final totalScroll = store.weeklyStats.fold<int>(0, (a, s) => a + s.scrollSessions);
    final sortedApps = [...store.appUsage]..sort((a, b) => b.usageMinutes.compareTo(a.usageMinutes));

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
                      const Icon(Icons.bar_chart, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Analytics',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your attention health insights',
                    style: TextStyle(color: mutedFg, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Summary stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildStatCard('$avgScore', 'Avg Score', AppColors.dopamineLow, theme, border, isDark),
                  const SizedBox(width: 12),
                  _buildStatCard('$avgFocus', 'Focus Min/Day', null, theme, border, isDark),
                  const SizedBox(width: 12),
                  _buildStatCard('$totalScroll', 'Scroll Sessions', AppColors.dopamineHigh, theme, border, isDark),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: muted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: theme.colorScheme.onSurface,
                  unselectedLabelColor: mutedFg,
                  labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  unselectedLabelStyle: const TextStyle(fontSize: 12),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: border),
                  ),
                  indicatorPadding: const EdgeInsets.all(2),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Score', height: 36),
                    Tab(text: 'Focus', height: 36),
                    Tab(text: 'Screen Time', height: 36),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Chart content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: 280,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScoreChart(store, theme, border, isDark, mutedFg),
                    _buildFocusChart(store, theme, border, isDark, mutedFg),
                    _buildScreenTimeChart(store, theme, border, isDark, mutedFg),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Usage Breakdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildCard(
                border: border,
                isDark: isDark,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bolt, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'App Usage Today',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...sortedApps.map((app) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(app.appName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                          Text('${app.usageMinutes} min', style: TextStyle(color: mutedFg, fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: (app.usageMinutes / 120).clamp(0.0, 1.0),
                                          minHeight: 6,
                                          backgroundColor: muted,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            _getDopamineColor(app.dopamineImpact),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      // Legend
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: border)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _legendDot('Low', AppColors.dopamineLow, mutedFg),
                              const SizedBox(width: 16),
                              _legendDot('Medium', AppColors.dopamineMedium, mutedFg),
                              const SizedBox(width: 16),
                              _legendDot('High', AppColors.dopamineHigh, mutedFg),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Peak Distraction Hours
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildCard(
                border: border,
                isDark: isDark,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peak Distraction Hours',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      _peakRow('9:00 PM - 11:00 PM', 'Most Active', AppColors.dopamineHigh, mutedFg),
                      const SizedBox(height: 12),
                      _peakRow('12:00 PM - 1:00 PM', 'Moderate', AppColors.dopamineMedium, mutedFg),
                      const SizedBox(height: 12),
                      _peakRow('7:00 AM - 8:00 AM', 'Low', AppColors.dopamineLow, mutedFg),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, Color? valueColor, ThemeData theme, Color border, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: valueColor ?? theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreChart(
      AppStore store, ThemeData theme, Color border, bool isDark, Color mutedFg) {
    return _buildCard(
      border: border,
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.gps_fixed, size: 16),
                const SizedBox(width: 8),
                Text('Dopamine Score Trend', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: border,
                      strokeWidth: 1,
                      dashArray: [3, 3],
                    ),
                    getDrawingVerticalLine: (_) => FlLine(
                      color: border,
                      strokeWidth: 1,
                      dashArray: [3, 3],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final i = value.toInt();
                          if (i >= 0 && i < store.weeklyStats.length) {
                            return Text(_dayLabel(store.weeklyStats[i].date),
                                style: TextStyle(fontSize: 11, color: mutedFg));
                          }
                          return const Text('');
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 25,
                        getTitlesWidget: (value, _) => Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 11, color: mutedFg),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: store.weeklyStats.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.dopamineScore.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: isDark ? AppColors.chart2Dark : AppColors.chart2Light,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (isDark ? AppColors.chart2Dark : AppColors.chart2Light).withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: AppColors.dopamineLow),
                const SizedBox(width: 8),
                Text('Score improving this week', style: TextStyle(color: mutedFg, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusChart(
      AppStore store, ThemeData theme, Color border, bool isDark, Color mutedFg) {
    return _buildCard(
      border: border,
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 8),
                Text('Daily Focus Time', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: border,
                      strokeWidth: 1,
                      dashArray: [3, 3],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final i = value.toInt();
                          if (i >= 0 && i < store.weeklyStats.length) {
                            return Text(_dayLabel(store.weeklyStats[i].date),
                                style: TextStyle(fontSize: 11, color: mutedFg));
                          }
                          return const Text('');
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 50,
                        getTitlesWidget: (value, _) => Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 11, color: mutedFg),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: store.weeklyStats.asMap().entries.map((e) {
                    return BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(
                        toY: e.value.focusMinutes.toDouble(),
                        color: isDark ? AppColors.chart1Dark : AppColors.chart1Light,
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenTimeChart(
      AppStore store, ThemeData theme, Color border, bool isDark, Color mutedFg) {
    return _buildCard(
      border: border,
      isDark: isDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text('Screen Time (hours)', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: border,
                      strokeWidth: 1,
                      dashArray: [3, 3],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final i = value.toInt();
                          if (i >= 0 && i < store.weeklyStats.length) {
                            return Text(_dayLabel(store.weeklyStats[i].date),
                                style: TextStyle(fontSize: 11, color: mutedFg));
                          }
                          return const Text('');
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 2,
                        getTitlesWidget: (value, _) => Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 11, color: mutedFg),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: store.weeklyStats.asMap().entries.map((e) {
                    return BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(
                        toY: (e.value.totalScreenTime / 60 * 10).roundToDouble() / 10,
                        color: isDark ? AppColors.chart5Dark : AppColors.chart5Light,
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.trending_down, size: 16, color: AppColors.dopamineLow),
                const SizedBox(width: 8),
                Text('12% less than last week', style: TextStyle(color: mutedFg, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Color border, required bool isDark, required Widget child}) {
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

  Widget _legendDot(String label, Color color, Color textColor) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: textColor)),
      ],
    );
  }

  Widget _peakRow(String time, String level, Color color, Color mutedFg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(time, style: TextStyle(fontSize: 14, color: mutedFg)),
        Text(level, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
      ],
    );
  }
}

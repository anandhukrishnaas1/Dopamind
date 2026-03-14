import 'package:usage_stats/usage_stats.dart';
import 'dart:io';

class UsageService {
  static Future<List<Map<String, dynamic>>> getDailyUsage({DateTime? date}) async {
    if (!Platform.isAndroid) return [];

    DateTime endDate = date ?? DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day);
    
    // If querying historical date, set endDate to end of that day
    if (date != null) {
      endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
    }

    List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startDate, endDate);
    
    // Sort by usage time descending
    usageStats.sort((a, b) => int.parse(b.totalTimeInForeground!)
        .compareTo(int.parse(a.totalTimeInForeground!)));

    List<Map<String, dynamic>> processedStats = [];

    for (var info in usageStats.take(10)) {
      int minutes = int.parse(info.totalTimeInForeground!) ~/ (1000 * 60);
      if (minutes > 0) {
        String packageName = info.packageName ?? 'Unknown';
        processedStats.add({
          'appName': _getReadableName(packageName),
          'packageName': packageName,
          'usageMinutes': minutes,
          'impact': _getImpact(packageName),
          'icon': _getIcon(packageName),
        });
      }
    }

    return processedStats;
  }

  static Future<List<Map<String, dynamic>>> getUsageForRange(DateTime start, DateTime end) async {
    if (!Platform.isAndroid) return [];
    
    List<Map<String, dynamic>> history = [];
    
    // Iterate day by day
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      DateTime date = start.add(Duration(days: i));
      List<Map<String, dynamic>> daily = await getDailyUsage(date: date);
      
      int totalMinutes = daily.fold(0, (sum, item) => sum + (item['usageMinutes'] as int));
      int highImpactMinutes = daily
        .where((item) => item['impact'] == 'high')
        .fold(0, (sum, item) => sum + (item['usageMinutes'] as int));
      
      // Calculate a pseudo-dopamine score based on high-impact usage
      // (Simplified: 100 - (highImpactMinutes / 3))
      int score = (100 - (highImpactMinutes / 3)).clamp(0, 100).toInt();

      history.add({
        'date': date.toIso8601String().split('T')[0],
        'totalMinutes': totalMinutes,
        'highImpactMinutes': highImpactMinutes,
        'dopamineScore': score,
        'usage': daily,
      });
    }
    
    return history;
  }

  static String _getReadableName(String packageName) {
    if (packageName.contains('instagram')) return 'Instagram';
    if (packageName.contains('tiktok')) return 'TikTok';
    if (packageName.contains('twitter') || packageName.contains('x.android')) return 'Twitter';
    if (packageName.contains('youtube')) return 'YouTube';
    if (packageName.contains('facebook')) return 'Facebook';
    if (packageName.contains('whatsapp')) return 'WhatsApp';
    if (packageName.contains('snapchat')) return 'Snapchat';
    if (packageName.contains('slack')) return 'Slack';
    if (packageName.contains('notion')) return 'Notion';
    if (packageName.contains('netflix')) return 'Netflix';
    if (packageName.contains('spotify')) return 'Spotify';
    
    // Fallback: cleanup package name
    return packageName.split('.').last.toUpperCase();
  }

  static String _getIcon(String packageName) {
    if (packageName.contains('instagram')) return '📸';
    if (packageName.contains('tiktok')) return '🎵';
    if (packageName.contains('twitter') || packageName.contains('x.android')) return '🐦';
    if (packageName.contains('youtube')) return '▶️';
    if (packageName.contains('facebook')) return '👥';
    if (packageName.contains('whatsapp')) return '💬';
    if (packageName.contains('snapchat')) return '👻';
    if (packageName.contains('slack')) return '💬';
    if (packageName.contains('notion')) return '📝';
    if (packageName.contains('netflix')) return '🎬';
    if (packageName.contains('spotify')) return '🎧';
    return '📱';
  }

  static String _getImpact(String packageName) {
    List<String> high = [
      'instagram', 'tiktok', 'twitter', 'youtube', 'facebook', 
      'snapchat', 'netflix', 'spotify', 'reels', 'shorts'
    ];
    for (var h in high) {
      if (packageName.toLowerCase().contains(h)) return 'high';
    }
    return 'low';
  }
}

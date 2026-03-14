import 'package:usage_stats/usage_stats.dart';
import 'dart:io';

class PermissionService {
  static Future<bool> checkUsagePermission() async {
    if (Platform.isAndroid) {
      bool? isGranted = await UsageStats.checkUsagePermission();
      return isGranted ?? false;
    }
    // iOS Screen Time API is handled differently, often requiring native bridge
    // For now, we return true on iOS to allow the flow to continue in demo
    return true;
  }

  static Future<void> requestUsagePermission() async {
    if (Platform.isAndroid) {
      UsageStats.grantUsagePermission();
    }
  }
}

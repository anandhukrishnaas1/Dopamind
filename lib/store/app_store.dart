import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppScreen {
  onboarding,
  auth,
  dashboard,
  analytics,
  focusMode,
  habitCoach,
  settings,
}

enum FocusMode {
  off,
  study,
  work,
  detox,
}

class AppUsage {
  final String appName;
  final String icon;
  final int usageMinutes;
  final String dopamineImpact; // 'low', 'medium', 'high'
  final String category;

  AppUsage({
    required this.appName,
    required this.icon,
    required this.usageMinutes,
    required this.dopamineImpact,
    required this.category,
  });
}

class DailyStats {
  final String date;
  final int dopamineScore;
  final int focusMinutes;
  final int totalScreenTime;
  final int scrollSessions;
  final int interventions;

  DailyStats({
    required this.date,
    required this.dopamineScore,
    required this.focusMinutes,
    required this.totalScreenTime,
    required this.scrollSessions,
    required this.interventions,
  });
}

class AppStore extends ChangeNotifier {
  // Navigation
  AppScreen _currentScreen = AppScreen.onboarding;
  bool _hasCompletedOnboarding = false;
  bool _isAuthenticated = false;

  // User data
  String _userName = '';
  String _email = '';

  // Dopamine & Focus
  int _currentDopamineScore = 74;
  FocusMode _focusMode = FocusMode.off;
  DateTime? _focusModeStartTime;
  int _dailyFocusGoal = 180;

  // Settings
  bool _notificationsEnabled = true;
  bool _smartInterventions = true;
  bool _darkMode = false;

  // Mock data
  final List<AppUsage> _appUsage = [
    AppUsage(appName: 'Instagram', icon: '📸', usageMinutes: 95, dopamineImpact: 'high', category: 'social'),
    AppUsage(appName: 'TikTok', icon: '🎵', usageMinutes: 78, dopamineImpact: 'high', category: 'entertainment'),
    AppUsage(appName: 'Twitter', icon: '🐦', usageMinutes: 45, dopamineImpact: 'high', category: 'social'),
    AppUsage(appName: 'YouTube', icon: '▶️', usageMinutes: 62, dopamineImpact: 'medium', category: 'entertainment'),
    AppUsage(appName: 'Slack', icon: '💬', usageMinutes: 35, dopamineImpact: 'low', category: 'productivity'),
    AppUsage(appName: 'Notion', icon: '📝', usageMinutes: 28, dopamineImpact: 'low', category: 'productivity'),
  ];

  final List<DailyStats> _weeklyStats = [
    DailyStats(date: '2024-01-08', dopamineScore: 72, focusMinutes: 145, totalScreenTime: 285, scrollSessions: 12, interventions: 3),
    DailyStats(date: '2024-01-09', dopamineScore: 68, focusMinutes: 120, totalScreenTime: 310, scrollSessions: 15, interventions: 5),
    DailyStats(date: '2024-01-10', dopamineScore: 75, focusMinutes: 180, totalScreenTime: 260, scrollSessions: 8, interventions: 2),
    DailyStats(date: '2024-01-11', dopamineScore: 62, focusMinutes: 90, totalScreenTime: 340, scrollSessions: 18, interventions: 7),
    DailyStats(date: '2024-01-12', dopamineScore: 78, focusMinutes: 200, totalScreenTime: 240, scrollSessions: 6, interventions: 1),
    DailyStats(date: '2024-01-13', dopamineScore: 71, focusMinutes: 155, totalScreenTime: 275, scrollSessions: 10, interventions: 4),
    DailyStats(date: '2024-01-14', dopamineScore: 74, focusMinutes: 170, totalScreenTime: 265, scrollSessions: 9, interventions: 3),
  ];

  // Getters
  AppScreen get currentScreen => _currentScreen;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get isAuthenticated => _isAuthenticated;
  String get userName => _userName;
  String get email => _email;
  int get currentDopamineScore => _currentDopamineScore;
  FocusMode get focusMode => _focusMode;
  DateTime? get focusModeStartTime => _focusModeStartTime;
  int get dailyFocusGoal => _dailyFocusGoal;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get smartInterventions => _smartInterventions;
  bool get darkMode => _darkMode;
  List<AppUsage> get appUsage => _appUsage;
  List<DailyStats> get weeklyStats => _weeklyStats;

  // Initialize from SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userName = prefs.getString('userName') ?? '';
    _email = prefs.getString('email') ?? '';
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _smartInterventions = prefs.getBool('smartInterventions') ?? true;
    _darkMode = prefs.getBool('darkMode') ?? false;

    // Determine initial screen
    if (!_hasCompletedOnboarding) {
      _currentScreen = AppScreen.onboarding;
    } else if (!_isAuthenticated) {
      _currentScreen = AppScreen.auth;
    } else {
      _currentScreen = AppScreen.dashboard;
    }

    notifyListeners();
  }

  // Actions
  void setScreen(AppScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasCompletedOnboarding = true;
    _currentScreen = AppScreen.auth;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    notifyListeners();
  }

  Future<void> login(String name, String email) async {
    _isAuthenticated = true;
    _userName = name;
    _email = email;
    _currentScreen = AppScreen.dashboard;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userName', name);
    await prefs.setString('email', email);
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userName = '';
    _email = '';
    _currentScreen = AppScreen.auth;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.setString('userName', '');
    await prefs.setString('email', '');
    notifyListeners();
  }

  void setFocusMode(FocusMode mode) {
    _focusMode = mode;
    _focusModeStartTime = mode != FocusMode.off ? DateTime.now() : null;
    notifyListeners();
  }

  void updateDopamineScore(int score) {
    _currentDopamineScore = score;
    notifyListeners();
  }

  Future<void> toggleSetting(String setting) async {
    final prefs = await SharedPreferences.getInstance();
    switch (setting) {
      case 'notificationsEnabled':
        _notificationsEnabled = !_notificationsEnabled;
        await prefs.setBool('notificationsEnabled', _notificationsEnabled);
        break;
      case 'smartInterventions':
        _smartInterventions = !_smartInterventions;
        await prefs.setBool('smartInterventions', _smartInterventions);
        break;
      case 'darkMode':
        _darkMode = !_darkMode;
        await prefs.setBool('darkMode', _darkMode);
        break;
    }
    notifyListeners();
  }
}

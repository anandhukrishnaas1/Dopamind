import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dopamind/services/usage_service.dart';
import 'package:dopamind/services/permission_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

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

class Goal {
  final String text;
  bool completed;
  Goal({required this.text, this.completed = false});
  
  Map<String, dynamic> toMap() => {'text': text, 'completed': completed};
  factory Goal.fromMap(Map<String, dynamic> map) => Goal(
    text: map['text'] ?? '', 
    completed: map['completed'] ?? false
  );
}

class AppStore extends ChangeNotifier {
  // Navigation
  AppScreen _currentScreen = AppScreen.onboarding;
  bool _hasCompletedOnboarding = false;
  bool _isAuthenticated = false;

  // User data
  String _userName = '';
  String _email = '';
  int _age = 18;
  int _gemsCount = 0;
  int _currentStreak = 0;
  DateTime? _lastActivityDate;
  List<Goal> _goals = [
    Goal(text: '30 min of focused work before checking phone', completed: true),
    Goal(text: 'No social media before 10 AM', completed: true),
    Goal(text: 'Screen-free lunch break', completed: false),
    Goal(text: 'No phone 1 hour before bed', completed: false),
  ];

  // Dopamine & Focus
  int _currentDopamineScore = 74;
  FocusMode _focusMode = FocusMode.off;
  DateTime? _focusModeStartTime;
  int _dailyFocusGoal = 180;

  // Settings
  bool _notificationsEnabled = true;
  bool _dailySummary = true;
  bool _smartInterventions = true;
  bool _infiniteScrollDetection = true;
  bool _darkMode = false;
  String _coachRecommendation = 'Loading personalized advice...';

  // Data lists (initialized empty)
  final List<AppUsage> _appUsage = [];
  List<DailyStats> _weeklyStats = [];


  // Getters
  AppScreen get currentScreen => _currentScreen;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get isAuthenticated => _isAuthenticated;
  String get userName => _userName;
  String get email => _email;
  int get age => _age;
  int get gemsCount => _gemsCount;
  int get currentStreak => _currentStreak;
  int get currentDopamineScore => _currentDopamineScore;
  FocusMode get focusMode => _focusMode;
  DateTime? get focusModeStartTime => _focusModeStartTime;
  int get dailyFocusGoal => _dailyFocusGoal;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get dailySummary => _dailySummary;
  bool get smartInterventions => _smartInterventions;
  bool get infiniteScrollDetection => _infiniteScrollDetection;
  bool get darkMode => _darkMode;
  String get coachRecommendation => _coachRecommendation;
  List<AppUsage> get appUsage => _appUsage;
  List<DailyStats> get weeklyStats => _weeklyStats;
  List<Goal> get goals => _goals;

  // Initialize from SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userName = prefs.getString('userName') ?? '';
    _email = prefs.getString('email') ?? '';
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _dailySummary = prefs.getBool('dailySummary') ?? true;
    _smartInterventions = prefs.getBool('smartInterventions') ?? true;
    _infiniteScrollDetection = prefs.getBool('infiniteScrollDetection') ?? true;
    _darkMode = prefs.getBool('darkMode') ?? true;
    _age = prefs.getInt('age') ?? 18;
    _gemsCount = prefs.getInt('gemsCount') ?? 0;
    _currentStreak = prefs.getInt('currentStreak') ?? 0;
    
    String? goalsStr = prefs.getString('goals');
    if (goalsStr != null) {
      Iterable l = json.decode(goalsStr);
      _goals = List<Goal>.from(l.map((model)=> Goal.fromMap(model)));
    }

    String? lastDateStr = prefs.getString('lastActivityDate');
    if (lastDateStr != null) {
      _lastActivityDate = DateTime.parse(lastDateStr);
      _checkAndUpdateStreak();
    }

    // Determine initial screen
    if (!_hasCompletedOnboarding) {
      _currentScreen = AppScreen.onboarding;
    } else if (!_isAuthenticated) {
      _currentScreen = AppScreen.auth;
    } else {
      _currentScreen = AppScreen.dashboard;
      _syncFromFirestore(); // Sync data if already authenticated
    }

    // Initial data refresh
    await _fetchHistoricalStats();
    await refreshUsageData();
    await fetchCoachRecommendation();

    notifyListeners();
  }

  Future<void> _fetchHistoricalStats() async {
    bool hasPermission = await PermissionService.checkUsagePermission();
    if (!hasPermission) return;

    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6));
    
    final history = await UsageService.getUsageForRange(start, now);
    
    _weeklyStats = history.map((h) => DailyStats(
      date: h['date'],
      dopamineScore: h['dopamineScore'],
      focusMinutes: 0, // Not explicitly tracked by OS, but could be inferred or mock-seeded realistically
      totalScreenTime: h['totalMinutes'],
      scrollSessions: 0,
      interventions: 0,
    )).toList();
    
    notifyListeners();
  }

  Future<void> refreshUsageData() async {
    bool hasPermission = await PermissionService.checkUsagePermission();
    if (!hasPermission) return;

    final realUsage = await UsageService.getDailyUsage();
    if (realUsage.isNotEmpty) {
      _appUsage.clear();
      int highDopamineMinutes = 0;
      int totalMinutes = 0;

      for (var app in realUsage) {
        _appUsage.add(AppUsage(
          appName: app['appName'],
          icon: app['icon'],
          usageMinutes: app['usageMinutes'],
          dopamineImpact: app['impact'],
          category: 'other',
        ));
        totalMinutes += (app['usageMinutes'] as int);
        if (app['impact'] == 'high') {
          highDopamineMinutes += (app['usageMinutes'] as int);
        }
      }

      // Dynamically calculate dopamine score
      int freshScore = 100 - (highDopamineMinutes ~/ 2);
      _currentDopamineScore = freshScore.clamp(0, 100);
      
      notifyListeners();
    }
  }

  Future<void> fetchCoachRecommendation() async {
    final hasPermission = await PermissionService.checkUsagePermission();
    if (!hasPermission) return;

    final realUsage = await UsageService.getDailyUsage();
    final insight = await AIService.getAIAnalytics({
      'dopamineScore': _currentDopamineScore,
      'usage': realUsage.map((a) => {
        'app': a['appName'],
        'minutes': a['usageMinutes'],
        'impact': a['impact'],
      }).toList(),
      'context': 'Give a short 1-2 sentence actionable habit recommendation for the user dashboard coach section.'
    });

    _coachRecommendation = insight;
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

  void setAge(int age) {
    _age = age;
    SharedPreferences.getInstance().then((prefs) => prefs.setInt('age', age));
    notifyListeners();
    _syncToFirestore();
  }

  void updateProfile(String name, int age) {
    _userName = name;
    _age = age;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('userName', name);
      prefs.setInt('age', age);
    });
    _syncToFirestore();
    notifyListeners();
  }

  void addGems(int count) {
    _gemsCount += count;
    SharedPreferences.getInstance().then((prefs) => prefs.setInt('gemsCount', _gemsCount));
    _syncToFirestore();
    notifyListeners();
  }

  // Goal Management
  void addGoal(String text) {
    _goals.add(Goal(text: text));
    _saveGoals();
    _syncToFirestore();
    notifyListeners();
  }

  void toggleGoal(int index) {
    if (index >= 0 && index < _goals.length) {
      _goals[index].completed = !_goals[index].completed;
      _saveGoals();
      _syncToFirestore();
      notifyListeners();
    }
  }

  void removeGoal(int index) {
    if (index >= 0 && index < _goals.length) {
      _goals.removeAt(index);
      _saveGoals();
      _syncToFirestore();
      notifyListeners();
    }
  }

  void _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    String goalsStr = json.encode(_goals.map((v) => v.toMap()).toList());
    await prefs.setString('goals', goalsStr);
  }

  void _syncToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userName': _userName,
          'email': _email,
          'age': _age,
          'gemsCount': _gemsCount,
          'currentStreak': _currentStreak,
          'lastActivityDate': _lastActivityDate?.toIso8601String(),
          'goals': _goals.map((g) => g.toMap()).toList(),
          'settings': {
            'notificationsEnabled': _notificationsEnabled,
            'dailySummary': _dailySummary,
            'smartInterventions': _smartInterventions,
            'infiniteScrollDetection': _infiniteScrollDetection,
            'darkMode': _darkMode,
          },
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint("Firestore Sync Error: $e");
      }
    }
  }

  void _syncFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          _userName = data['userName'] ?? _userName;
          _gemsCount = data['gemsCount'] ?? _gemsCount;
          _currentStreak = data['currentStreak'] ?? _currentStreak;
          if (data['lastActivityDate'] != null) {
            _lastActivityDate = DateTime.parse(data['lastActivityDate']);
          }
          
          if (data['goals'] != null) {
            List<dynamic> goalsData = data['goals'];
            _goals = goalsData.map((g) => Goal.fromMap(g as Map<String, dynamic>)).toList();
          }

          if (data['settings'] != null) {
            Map<String, dynamic> settings = data['settings'];
            _notificationsEnabled = settings['notificationsEnabled'] ?? _notificationsEnabled;
            _dailySummary = settings['dailySummary'] ?? _dailySummary;
            _smartInterventions = settings['smartInterventions'] ?? _smartInterventions;
            _infiniteScrollDetection = settings['infiniteScrollDetection'] ?? _infiniteScrollDetection;
            _darkMode = settings['darkMode'] ?? _darkMode;
          }

          notifyListeners();
        }
      } catch (e) {
        debugPrint("Firestore Retrieval Error: $e");
      }
    }
  }

  void _checkAndUpdateStreak() {
    if (_lastActivityDate == null) {
      _currentStreak = 1;
    } else {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final last = DateTime(_lastActivityDate!.year, _lastActivityDate!.month, _lastActivityDate!.day);
      final difference = today.difference(last).inDays;

      if (difference == 1) {
        _currentStreak++;
      } else if (difference > 1) {
        _currentStreak = 1;
      }
      // If difference is 0, same day, no change
    }
    _lastActivityDate = DateTime.now();
    _saveStreak();
    _syncToFirestore();
    notifyListeners();
  }

  void _saveStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentStreak', _currentStreak);
    await prefs.setString('lastActivityDate', _lastActivityDate!.toIso8601String());
  }

  void updateStreak(int days) {
    _currentStreak = days;
    _saveStreak();
    _syncToFirestore();
    notifyListeners();
  }

  Future<void> login(String name, String email) async {
    _isAuthenticated = true;
    
    final prefs = await SharedPreferences.getInstance();
    
    // If name is empty, try to get from prefs
    if (name.isEmpty || name == 'User') {
      _userName = prefs.getString('userName') ?? 'User';
    } else {
      _userName = name;
    }
    
    _email = email;
    _currentScreen = AppScreen.dashboard;
    
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userName', _userName);
    await prefs.setString('email', email);
    
    _syncToFirestore();
    _syncFromFirestore();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) return; // User cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        _isAuthenticated = true;
        _userName = user.displayName ?? _userName;
        _email = user.email ?? _email;
        _currentScreen = AppScreen.dashboard;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userName', _userName);
        await prefs.setString('email', _email);

        _syncToFirestore();
        _syncFromFirestore();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      rethrow;
    }
  }

  Future<void> signup(String name, String email, String password) async {
    _isAuthenticated = true;
    _userName = name;
    _email = email;
    _currentScreen = AppScreen.dashboard;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userName', name);
    await prefs.setString('email', email);
    
    try {
       if (FirebaseAuth.instance.app.name != null) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
      }
    } catch (e) {
       debugPrint("Firebase Signup Error: $e");
    }

    _syncToFirestore();
    _syncFromFirestore();
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
      case 'dailySummary':
        _dailySummary = !_dailySummary;
        await prefs.setBool('dailySummary', _dailySummary);
        break;
      case 'smartInterventions':
        _smartInterventions = !_smartInterventions;
        await prefs.setBool('smartInterventions', _smartInterventions);
        break;
      case 'infiniteScrollDetection':
        _infiniteScrollDetection = !_infiniteScrollDetection;
        await prefs.setBool('infiniteScrollDetection', _infiniteScrollDetection);
        break;
      case 'darkMode':
        _darkMode = !_darkMode;
        await prefs.setBool('darkMode', _darkMode);
        break;
    }
    _syncToFirestore();
    notifyListeners();
  }
}

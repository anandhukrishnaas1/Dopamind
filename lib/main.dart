import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dopamind/theme/app_theme.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:dopamind/screens/onboarding_screen.dart';
import 'package:dopamind/screens/auth_screen.dart';
import 'package:dopamind/screens/dashboard_screen.dart';
import 'package:dopamind/screens/analytics_screen.dart';
import 'package:dopamind/screens/focus_mode_screen.dart';
import 'package:dopamind/screens/habit_coach_screen.dart';
import 'package:dopamind/screens/settings_screen.dart';
import 'package:dopamind/widgets/bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final store = AppStore();
  await store.init();

  runApp(
    ChangeNotifierProvider.value(
      value: store,
      child: const DopaMindApp(),
    ),
  );
}

class DopaMindApp extends StatelessWidget {
  const DopaMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStore>(
      builder: (context, store, _) {
        return MaterialApp(
          title: 'DopamineOS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: store.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AppShell(),
        );
      },
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStore>(
      builder: (context, store, _) {
        final showBottomNav = store.isAuthenticated &&
            [
              AppScreen.dashboard,
              AppScreen.analytics,
              AppScreen.focusMode,
              AppScreen.habitCoach,
              AppScreen.settings,
            ].contains(store.currentScreen);

        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: child,
                ),
              );
            },
            child: _buildScreen(store),
          ),
          bottomNavigationBar: showBottomNav
              ? BottomNav(
                  currentScreen: store.currentScreen,
                  onNavigate: store.setScreen,
                )
              : null,
        );
      },
    );
  }

  Widget _buildScreen(AppStore store) {
    switch (store.currentScreen) {
      case AppScreen.onboarding:
        return OnboardingScreen(
          key: const ValueKey('onboarding'),
          onComplete: store.completeOnboarding,
        );
      case AppScreen.auth:
        return AuthScreen(
          key: const ValueKey('auth'),
          onLogin: store.login,
        );
      case AppScreen.dashboard:
        return DashboardScreen(key: const ValueKey('dashboard'));
      case AppScreen.analytics:
        return AnalyticsScreen(key: const ValueKey('analytics'));
      case AppScreen.focusMode:
        return FocusModeScreen(key: const ValueKey('focus-mode'));
      case AppScreen.habitCoach:
        return HabitCoachScreen(key: const ValueKey('habit-coach'));
      case AppScreen.settings:
        return SettingsScreen(key: const ValueKey('settings'));
    }
  }
}

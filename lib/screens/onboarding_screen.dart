import 'package:flutter/material.dart';
import 'package:dopamind/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentSlide = 0;

  final List<_SlideData> _slides = [
    _SlideData(
      icon: Icons.psychology_outlined,
      title: 'Predict Your Digital Habits',
      description:
          'Our AI analyzes your smartphone usage patterns to predict when you\'re about to enter an addictive scrolling loop.',
      gradientColors: [AppColors.chart1Light.withOpacity(0.2), AppColors.chart2Light.withOpacity(0.2)],
    ),
    _SlideData(
      icon: Icons.shield_outlined,
      title: 'Break Dopamine Loops',
      description:
          'Get intelligent interventions before endless scrolling begins. Take control of your attention and digital wellbeing.',
      gradientColors: [AppColors.chart2Light.withOpacity(0.2), AppColors.chart3Light.withOpacity(0.2)],
    ),
    _SlideData(
      icon: Icons.gps_fixed,
      title: 'Improve Focus & Productivity',
      description:
          'Smart Focus Mode blocks distracting apps automatically when high dopamine activity is detected.',
      gradientColors: [AppColors.chart3Light.withOpacity(0.2), AppColors.chart4Light.withOpacity(0.2)],
    ),
    _SlideData(
      icon: Icons.auto_awesome_outlined,
      title: 'Build Healthier Habits',
      description:
          'Your AI Habit Coach suggests alternatives and tracks your progress toward a balanced digital lifestyle.',
      gradientColors: [AppColors.chart4Light.withOpacity(0.2), AppColors.chart1Light.withOpacity(0.2)],
    ),
  ];

  void _nextSlide() {
    if (_currentSlide < _slides.length - 1) {
      setState(() => _currentSlide++);
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final primary = theme.colorScheme.primary;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.psychology,
                        size: 20,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'DopamineOS',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: widget.onComplete,
                  child: Text(
                    'Skip',
                    style: TextStyle(color: mutedFg),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    )),
                    child: child,
                  ),
                );
              },
              child: _buildSlideContent(_slides[_currentSlide], theme, mutedFg),
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(
              children: [
                // Progress dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _currentSlide = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentSlide ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentSlide
                              ? primary
                              : mutedFg.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Next/Get Started button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _nextSlide,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_currentSlide == _slides.length - 1
                            ? 'Get Started'
                            : 'Next'),
                        if (_currentSlide < _slides.length - 1) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, size: 20),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideContent(_SlideData slide, ThemeData theme, Color mutedFg) {
    return KeyedSubtree(
      key: ValueKey(slide.title),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: slide.gradientColors,
                ),
              ),
              child: Icon(
                slide.icon,
                size: 64,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              slide.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              slide.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: mutedFg,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;

  _SlideData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientColors,
  });
}

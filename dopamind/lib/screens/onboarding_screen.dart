import 'package:flutter/material.dart';
import 'package:dopamind/theme/app_theme.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:dopamind/services/permission_service.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentSlide = 0;
  final PageController _pageController = PageController();

  Future<void> _nextSlide() async {
    if (_currentSlide == 2) {
      // Permission slide
      bool isGranted = await PermissionService.checkUsagePermission();
      if (!isGranted) {
        await PermissionService.requestUsagePermission();
        // Skip moving to next slide so user can try again after granting
        return; 
      }
    }

    if (_currentSlide < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = Provider.of<AppStore>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'DopamineOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (_currentSlide < 4)
                    TextButton(
                      onPressed: widget.onComplete,
                      child: const Text('Skip', style: TextStyle(color: Colors.white54)),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentSlide = index),
                physics: const NeverScrollableScrollPhysics(), // Force using buttons
                children: [
                  _IntroSlide(
                    title: 'Empower Humans\nto Focus Better.',
                    description: 'Stop the mindless scrolling and take back control of your attention.',
                    icon: Icons.auto_awesome,
                  ),
                  _AgeSelectorSlide(
                    onChanged: (age) => store.setAge(age),
                    selectedAge: store.age,
                  ),
                  _PermissionSlide(),
                  _StreakSlide(),
                  _GemSlide(),
                  _IntroSlide(
                    title: 'Ready to Start?',
                    description: 'Your journey to a balanced digital life begins now.',
                    icon: Icons.rocket_launch,
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Progress dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentSlide ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentSlide ? AppColors.darkPrimary : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  
                  // Primary Button
                  ElevatedButton(
                    onPressed: _nextSlide,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      _currentSlide == 5 ? 'Get Started' : 'Continue',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
}

class _IntroSlide extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isLast;

  const _IntroSlide({
    required this.title,
    required this.description,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: AppColors.darkPrimary),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgeSelectorSlide extends StatelessWidget {
  final Function(int) onChanged;
  final int selectedAge;

  const _AgeSelectorSlide({required this.onChanged, required this.selectedAge});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'How old are you?',
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'So we can suggest the best setup for you.',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
        const SizedBox(height: 64),
        SizedBox(
          height: 250,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 60,
            perspective: 0.005,
            diameterRatio: 1.2,
            onSelectedItemChanged: (index) => onChanged(index + 13),
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 88,
              builder: (context, index) {
                final age = index + 13;
                final isSelected = age == selectedAge;
                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white24,
                      fontSize: isSelected ? 32 : 24,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    child: Text('$age'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PermissionSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text(
                  '“DopamineOS” Would Like to Access Screen Time',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Providing access to Screen Time may allow it to see your activity data, restrict content, and limit usage.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Tap "Continue" to grant access in System Settings.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _StreakSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkPrimary.withOpacity(0.3),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(Icons.local_fire_department, size: 120, color: AppColors.darkPrimary),
                const Text(
                  '1',
                  style: TextStyle(color: Colors.white, fontSize: 72, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'DAY STREAK',
                  style: TextStyle(color: AppColors.darkPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 48),
        const Text(
          'Maintain a daily streak by focusing\na little bit every day.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
        ),
      ],
    );
  }
}

class _GemSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'First Gem',
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tap to reveal your first gem!',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
        const SizedBox(height: 64),
        // Placeholder for the 3D Gem image
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(40),
            gradient: RadialGradient(
              colors: [Colors.white24, Colors.transparent],
            ),
          ),
          child: const Icon(Icons.diamond, size: 80, color: Colors.blueAccent),
        ),
        const SizedBox(height: 64),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(200, 56),
          ),
          child: const Text('Reveal Gem'),
        ),
      ],
    );
  }
}

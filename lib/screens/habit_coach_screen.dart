import 'package:flutter/material.dart';
import 'package:dopamind/theme/app_theme.dart';

class HabitCoachScreen extends StatefulWidget {
  const HabitCoachScreen({super.key});

  @override
  State<HabitCoachScreen> createState() => _HabitCoachScreenState();
}

class _HabitCoachScreenState extends State<HabitCoachScreen> {
  final List<int> _completedSuggestions = [];
  final int _currentStreak = 7;

  final List<_SuggestionData> _suggestions = [
    _SuggestionData(id: 1, title: 'Take a 5-minute walk', description: 'Step away from screens and get some fresh air', icon: Icons.park_outlined, duration: '5 min'),
    _SuggestionData(id: 2, title: 'Practice breathing', description: '4-7-8 breathing technique to reset your focus', icon: Icons.air_outlined, duration: '3 min'),
    _SuggestionData(id: 3, title: 'Read a chapter', description: "Pick up that book you've been meaning to read", icon: Icons.menu_book_outlined, duration: '15 min'),
    _SuggestionData(id: 4, title: 'Quick stretches', description: 'Desk stretches to release tension', icon: Icons.fitness_center_outlined, duration: '5 min'),
    _SuggestionData(id: 5, title: 'Listen to calm music', description: 'Lo-fi or ambient sounds for focus', icon: Icons.music_note_outlined, duration: '10 min'),
    _SuggestionData(id: 6, title: 'Make a warm drink', description: 'Tea or coffee break, mindfully', icon: Icons.coffee_outlined, duration: '5 min'),
  ];

  final List<_GoalData> _dailyGoals = [
    _GoalData(id: 1, text: '30 min of focused work before checking phone', completed: true),
    _GoalData(id: 2, text: 'No social media before 10 AM', completed: true),
    _GoalData(id: 3, text: 'Screen-free lunch break', completed: false),
    _GoalData(id: 4, text: 'No phone 1 hour before bed', completed: false),
  ];

  void _toggleSuggestion(int id) {
    setState(() {
      if (_completedSuggestions.contains(id)) {
        _completedSuggestions.remove(id);
      } else {
        _completedSuggestions.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final completedGoals = _dailyGoals.where((g) => g.completed).length;

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
                      const Icon(Icons.auto_awesome, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'AI Habit Coach',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Personalized suggestions for better habits',
                    style: TextStyle(color: mutedFg, fontSize: 14),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Streak Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (isDark ? AppColors.chart4Dark : AppColors.chart4Light).withOpacity(0.1),
                          (isDark ? AppColors.chart5Dark : AppColors.chart5Light).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (isDark ? AppColors.chart4Dark : AppColors.chart4Light).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.local_fire_department,
                                      size: 20,
                                      color: isDark ? AppColors.chart5Dark : AppColors.chart5Light),
                                  const SizedBox(width: 8),
                                  const Text('Current Streak',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$_currentStreak days',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Keep it up! You're building great habits.",
                                style: TextStyle(color: mutedFg, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const Text('🔥', style: TextStyle(fontSize: 48)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Daily Goals
                  _buildCard(
                    border: border,
                    isDark: isDark,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.gps_fixed, size: 16),
                                  const SizedBox(width: 8),
                                  Text("Today's Goals",
                                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Text('$completedGoals/${_dailyGoals.length}',
                                  style: TextStyle(color: mutedFg, fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._dailyGoals.map((goal) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: goal.completed
                                            ? theme.colorScheme.primary
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: goal.completed
                                              ? theme.colorScheme.primary
                                              : mutedFg.withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: goal.completed
                                          ? Icon(Icons.check,
                                              size: 14, color: theme.colorScheme.onPrimary)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        goal.text,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: goal.completed ? mutedFg : null,
                                          decoration: goal.completed
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // AI Recommendation
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.chart2Dark : AppColors.chart2Light).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (isDark ? AppColors.chart2Dark : AppColors.chart2Light).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (isDark ? AppColors.chart2Dark : AppColors.chart2Light).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.auto_awesome, size: 20,
                              color: isDark ? AppColors.chart2Dark : AppColors.chart2Light),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('AI Recommendation',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text(
                                'Based on your patterns, I suggest starting your day with 20 minutes of focused work before checking any social apps. This could improve your morning productivity by 40%.',
                                style: TextStyle(color: mutedFg, fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    textStyle: const TextStyle(fontSize: 13),
                                  ),
                                  child: const Text('Add to Goals'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Healthier Alternatives
                  Text('Healthier Alternatives',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: mutedFg)),
                  const SizedBox(height: 12),
                  ..._suggestions.map((suggestion) {
                    final isCompleted = _completedSuggestions.contains(suggestion.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () => _toggleSuggestion(suggestion.id),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.success.withOpacity(0.1)
                                : (isDark ? AppColors.darkCard : AppColors.lightCard),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCompleted
                                  ? AppColors.success.withOpacity(0.3)
                                  : border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? AppColors.success.withOpacity(0.2)
                                      : muted,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isCompleted ? Icons.check : suggestion.icon,
                                  size: 20,
                                  color: isCompleted ? AppColors.success : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      suggestion.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isCompleted ? mutedFg : null,
                                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    Text(suggestion.description,
                                        style: TextStyle(color: mutedFg, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 12, color: mutedFg),
                                  const SizedBox(width: 4),
                                  Text(suggestion.duration,
                                      style: TextStyle(color: mutedFg, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Weekly Progress
                  _buildCard(
                    border: border,
                    isDark: isDark,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weekly Progress',
                              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                                .asMap()
                                .entries
                                .map((e) {
                              final isComplete = e.key < 5;
                              final isHalf = e.key == 5;
                              return Column(
                                children: [
                                  Text(e.value,
                                      style: TextStyle(color: mutedFg, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isComplete
                                          ? theme.colorScheme.primary
                                          : isHalf
                                              ? theme.colorScheme.primary.withOpacity(0.5)
                                              : muted,
                                    ),
                                    child: isComplete
                                        ? Icon(Icons.check, size: 16,
                                            color: theme.colorScheme.onPrimary)
                                        : null,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text('5 of 7 days completed this week',
                                style: TextStyle(color: mutedFg, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Learn More
                  GestureDetector(
                    onTap: () {},
                    child: _buildCard(
                      border: border,
                      isDark: isDark,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: muted,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.menu_book_outlined, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Learn More',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  Text('Articles on digital wellness',
                                      style: TextStyle(color: mutedFg, fontSize: 12)),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 20, color: mutedFg),
                          ],
                        ),
                      ),
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
}

class _SuggestionData {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final String duration;
  _SuggestionData({required this.id, required this.title, required this.description, required this.icon, required this.duration});
}

class _GoalData {
  final int id;
  final String text;
  final bool completed;
  _GoalData({required this.id, required this.text, required this.completed});
}

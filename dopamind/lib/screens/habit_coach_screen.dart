import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dopamind/store/app_store.dart';
import 'package:dopamind/theme/app_theme.dart';

class HabitCoachScreen extends StatefulWidget {
  const HabitCoachScreen({super.key});

  @override
  State<HabitCoachScreen> createState() => _HabitCoachScreenState();
}

class _HabitCoachScreenState extends State<HabitCoachScreen> {
  final List<int> _completedSuggestions = [];

  final List<_SuggestionData> _suggestions = [
    _SuggestionData(id: 1, title: 'Take a 5-minute walk', description: 'Step away from screens and get some fresh air', icon: Icons.park_outlined, duration: '5 min'),
    _SuggestionData(id: 2, title: 'Practice breathing', description: '4-7-8 breathing technique to reset your focus', icon: Icons.air_outlined, duration: '3 min'),
    _SuggestionData(id: 3, title: 'Read a chapter', description: "Pick up that book you've been meaning to read", icon: Icons.menu_book_outlined, duration: '15 min'),
    _SuggestionData(id: 4, title: 'Quick stretches', description: 'Desk stretches to release tension', icon: Icons.fitness_center_outlined, duration: '5 min'),
    _SuggestionData(id: 5, title: 'Listen to calm music', description: 'Lo-fi or ambient sounds for focus', icon: Icons.music_note_outlined, duration: '10 min'),
    _SuggestionData(id: 6, title: 'Make a warm drink', description: 'Tea or coffee break, mindfully', icon: Icons.coffee_outlined, duration: '5 min'),
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
    final store = context.watch<AppStore>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Use theme semantic colors instead of hardcoded ones
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final cardBg = theme.cardTheme.color ?? theme.colorScheme.surface;
    final borderCol = theme.cardTheme.shape is RoundedRectangleBorder 
      ? (theme.cardTheme.shape as RoundedRectangleBorder).side.color 
      : theme.colorScheme.outline;

    final goals = store.goals;
    final completedGoals = goals.where((g) => g.completed).length;

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
                        colors: AppColors.orangeGradient,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkPrimary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.bolt, size: 20, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Current Streak',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${store.currentStreak} days',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Keep it up! You're building great habits.",
                                style: TextStyle(color: Colors.white70, fontSize: 13),
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
                    theme: theme,
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
                              Text('$completedGoals/${goals.length}',
                                  style: TextStyle(color: mutedFg, fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...goals.asMap().entries.map((entry) {
                            final index = entry.key;
                            final goal = entry.value;
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () => store.toggleGoal(index),
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
                                      IconButton(
                                        icon: Icon(Icons.close, size: 16, color: mutedFg.withOpacity(0.5)),
                                        onPressed: () => store.removeGoal(index),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                          }),
                          const SizedBox(height: 8),
                          // Input for new goal
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Add a custom goal...',
                              hintStyle: TextStyle(color: mutedFg, fontSize: 14),
                              border: InputBorder.none,
                              prefixIcon: const Icon(Icons.add, size: 16),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                store.addGoal(value.trim());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.chart1.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.chart1.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.chart1.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.auto_awesome, size: 20,
                              color: AppColors.chart1),
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
                                store.coachRecommendation,
                                style: TextStyle(color: mutedFg, fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () {
                                    store.addGoal(store.coachRecommendation);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    textStyle: const TextStyle(fontSize: 13),
                                    minimumSize: Size.zero,
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
                                : cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCompleted
                                  ? AppColors.success.withOpacity(0.3)
                                  : borderCol,
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
                                      : (isDark ? AppColors.darkMuted : AppColors.lightMuted),
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
                    theme: theme,
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
                                              : (isDark ? AppColors.darkMuted : AppColors.lightMuted),
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
                      theme: theme,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
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

  Widget _buildCard({required ThemeData theme, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: theme.cardTheme.shape is RoundedRectangleBorder 
          ? Border.fromBorderSide((theme.cardTheme.shape as RoundedRectangleBorder).side)
          : null,
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

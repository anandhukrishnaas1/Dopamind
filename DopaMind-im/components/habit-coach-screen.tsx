"use client"

import { useState } from "react"
import { motion, AnimatePresence } from "framer-motion"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { 
  Sparkles, 
  TreePine,
  BookOpen,
  Wind,
  Dumbbell,
  Music,
  Coffee,
  ChevronRight,
  Check,
  Clock,
  Target,
  Flame
} from "lucide-react"

const suggestions = [
  {
    id: 1,
    title: "Take a 5-minute walk",
    description: "Step away from screens and get some fresh air",
    icon: TreePine,
    duration: "5 min",
    category: "movement",
  },
  {
    id: 2,
    title: "Practice breathing",
    description: "4-7-8 breathing technique to reset your focus",
    icon: Wind,
    duration: "3 min",
    category: "mindfulness",
  },
  {
    id: 3,
    title: "Read a chapter",
    description: "Pick up that book you've been meaning to read",
    icon: BookOpen,
    duration: "15 min",
    category: "learning",
  },
  {
    id: 4,
    title: "Quick stretches",
    description: "Desk stretches to release tension",
    icon: Dumbbell,
    duration: "5 min",
    category: "movement",
  },
  {
    id: 5,
    title: "Listen to calm music",
    description: "Lo-fi or ambient sounds for focus",
    icon: Music,
    duration: "10 min",
    category: "relaxation",
  },
  {
    id: 6,
    title: "Make a warm drink",
    description: "Tea or coffee break, mindfully",
    icon: Coffee,
    duration: "5 min",
    category: "self-care",
  },
]

const dailyGoals = [
  { id: 1, text: "30 min of focused work before checking phone", completed: true },
  { id: 2, text: "No social media before 10 AM", completed: true },
  { id: 3, text: "Screen-free lunch break", completed: false },
  { id: 4, text: "No phone 1 hour before bed", completed: false },
]

export function HabitCoachScreen() {
  const [completedSuggestions, setCompletedSuggestions] = useState<number[]>([])
  const [currentStreak, setCurrentStreak] = useState(7)

  const toggleSuggestion = (id: number) => {
    setCompletedSuggestions(prev => 
      prev.includes(id) 
        ? prev.filter(i => i !== id)
        : [...prev, id]
    )
  }

  const completedGoals = dailyGoals.filter(g => g.completed).length

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header */}
      <header className="px-6 pt-6 pb-4">
        <div className="flex items-center gap-2 mb-1">
          <Sparkles className="w-5 h-5" />
          <h1 className="text-xl font-semibold tracking-tight">AI Habit Coach</h1>
        </div>
        <p className="text-sm text-muted-foreground">Personalized suggestions for better habits</p>
      </header>

      <main className="px-6 space-y-4">
        {/* Streak Card */}
        <Card className="bg-gradient-to-br from-chart-4/10 to-chart-5/10 border-chart-4/30">
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="flex items-center gap-2 mb-1">
                  <Flame className="w-5 h-5 text-chart-5" />
                  <span className="text-sm font-medium">Current Streak</span>
                </div>
                <div className="text-4xl font-semibold">{currentStreak} days</div>
                <p className="text-sm text-muted-foreground mt-1">
                  Keep it up! You're building great habits.
                </p>
              </div>
              <div className="text-6xl">🔥</div>
            </div>
          </CardContent>
        </Card>

        {/* Daily Goals */}
        <Card>
          <CardHeader className="pb-3">
            <div className="flex items-center justify-between">
              <CardTitle className="text-base font-medium flex items-center gap-2">
                <Target className="w-4 h-4" />
                {"Today's Goals"}
              </CardTitle>
              <span className="text-sm text-muted-foreground">
                {completedGoals}/{dailyGoals.length}
              </span>
            </div>
          </CardHeader>
          <CardContent className="pt-0">
            <div className="space-y-3">
              {dailyGoals.map((goal) => (
                <div 
                  key={goal.id}
                  className="flex items-center gap-3"
                >
                  <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center flex-shrink-0 ${
                    goal.completed 
                      ? 'bg-primary border-primary' 
                      : 'border-muted-foreground/30'
                  }`}>
                    {goal.completed && <Check className="w-3 h-3 text-primary-foreground" />}
                  </div>
                  <span className={`text-sm ${goal.completed ? 'text-muted-foreground line-through' : ''}`}>
                    {goal.text}
                  </span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* AI Suggestion */}
        <Card className="border-2 border-chart-2/30 bg-chart-2/5">
          <CardContent className="p-4">
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-xl bg-chart-2/20 flex items-center justify-center flex-shrink-0">
                <Sparkles className="w-5 h-5 text-chart-2" />
              </div>
              <div className="flex-1">
                <p className="text-sm font-medium">AI Recommendation</p>
                <p className="text-sm text-muted-foreground mt-1">
                  Based on your patterns, I suggest starting your day with 20 minutes of focused work before checking any social apps. This could improve your morning productivity by 40%.
                </p>
                <Button size="sm" className="mt-3">
                  Add to Goals
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Alternative Activities */}
        <div>
          <h2 className="text-sm font-medium text-muted-foreground mb-3">
            Healthier Alternatives
          </h2>
          <div className="space-y-2">
            <AnimatePresence>
              {suggestions.map((suggestion) => {
                const isCompleted = completedSuggestions.includes(suggestion.id)
                return (
                  <motion.div
                    key={suggestion.id}
                    layout
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -10 }}
                  >
                    <Card 
                      className={`cursor-pointer transition-all ${
                        isCompleted ? 'bg-success/10 border-success/30' : 'hover:bg-muted/30'
                      }`}
                      onClick={() => toggleSuggestion(suggestion.id)}
                    >
                      <CardContent className="p-4">
                        <div className="flex items-center gap-3">
                          <div className={`w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 ${
                            isCompleted ? 'bg-success/20' : 'bg-muted'
                          }`}>
                            {isCompleted ? (
                              <Check className="w-5 h-5 text-success" />
                            ) : (
                              <suggestion.icon className="w-5 h-5" />
                            )}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className={`text-sm font-medium ${isCompleted ? 'line-through text-muted-foreground' : ''}`}>
                              {suggestion.title}
                            </p>
                            <p className="text-xs text-muted-foreground mt-0.5">
                              {suggestion.description}
                            </p>
                          </div>
                          <div className="flex items-center gap-2 text-xs text-muted-foreground">
                            <Clock className="w-3 h-3" />
                            {suggestion.duration}
                          </div>
                        </div>
                      </CardContent>
                    </Card>
                  </motion.div>
                )
              })}
            </AnimatePresence>
          </div>
        </div>

        {/* Weekly Progress */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-sm font-medium">Weekly Progress</CardTitle>
          </CardHeader>
          <CardContent className="pt-0">
            <div className="flex items-center justify-between mb-2">
              {['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day, index) => (
                <div key={index} className="text-center">
                  <span className="text-xs text-muted-foreground">{day}</span>
                  <div className={`w-8 h-8 rounded-full mt-1 flex items-center justify-center ${
                    index < 5 
                      ? 'bg-primary text-primary-foreground' 
                      : index === 5 
                      ? 'bg-primary/50 text-primary-foreground' 
                      : 'bg-muted'
                  }`}>
                    {index < 5 && <Check className="w-4 h-4" />}
                  </div>
                </div>
              ))}
            </div>
            <p className="text-xs text-muted-foreground text-center mt-3">
              5 of 7 days completed this week
            </p>
          </CardContent>
        </Card>

        {/* Resources */}
        <Card className="cursor-pointer hover:bg-muted/30 transition-colors">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-muted flex items-center justify-center">
                  <BookOpen className="w-5 h-5" />
                </div>
                <div>
                  <p className="text-sm font-medium">Learn More</p>
                  <p className="text-xs text-muted-foreground">
                    Articles on digital wellness
                  </p>
                </div>
              </div>
              <ChevronRight className="w-5 h-5 text-muted-foreground" />
            </div>
          </CardContent>
        </Card>
      </main>
    </div>
  )
}

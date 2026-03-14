"use client"

import { useState, useEffect } from "react"
import { motion } from "framer-motion"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Progress } from "@/components/ui/progress"
import { 
  Brain, 
  Shield, 
  Zap, 
  Clock, 
  TrendingDown, 
  Sparkles,
  ChevronRight,
  AlertTriangle
} from "lucide-react"
import type { FocusMode } from "@/lib/store"

interface DashboardProps {
  userName: string
  dopamineScore: number
  focusMode: FocusMode
  focusMinutesToday: number
  dailyFocusGoal: number
  appUsage: Array<{
    appName: string
    icon: string
    usageMinutes: number
    dopamineImpact: 'low' | 'medium' | 'high'
  }>
  onSetFocusMode: (mode: FocusMode) => void
  onNavigate: (screen: 'analytics' | 'focus-mode' | 'habit-coach' | 'settings') => void
}

export function Dashboard({
  userName,
  dopamineScore,
  focusMode,
  focusMinutesToday,
  dailyFocusGoal,
  appUsage,
  onSetFocusMode,
  onNavigate,
}: DashboardProps) {
  const [currentTime, setCurrentTime] = useState(new Date())
  const [showAlert, setShowAlert] = useState(true)

  useEffect(() => {
    const timer = setInterval(() => setCurrentTime(new Date()), 60000)
    return () => clearInterval(timer)
  }, [])

  const greeting = currentTime.getHours() < 12 
    ? "Good morning" 
    : currentTime.getHours() < 18 
    ? "Good afternoon" 
    : "Good evening"

  const focusProgress = (focusMinutesToday / dailyFocusGoal) * 100

  const getScoreColor = (score: number) => {
    if (score >= 70) return "text-dopamine-low"
    if (score >= 50) return "text-dopamine-medium"
    return "text-dopamine-high"
  }

  const getScoreLabel = (score: number) => {
    if (score >= 80) return "Excellent"
    if (score >= 70) return "Good"
    if (score >= 50) return "Moderate"
    return "Needs Attention"
  }

  const topDistracting = appUsage
    .filter(app => app.dopamineImpact === 'high')
    .slice(0, 3)

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header */}
      <header className="px-6 pt-6 pb-4">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-muted-foreground text-sm">{greeting}</p>
            <h1 className="text-xl font-semibold tracking-tight">{userName}</h1>
          </div>
          <button 
            onClick={() => onNavigate('settings')}
            className="w-10 h-10 rounded-full bg-muted flex items-center justify-center"
          >
            <span className="text-lg font-medium">{userName.charAt(0).toUpperCase()}</span>
          </button>
        </div>
      </header>

      {/* AI Alert */}
      {showAlert && (
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="mx-6 mb-4"
        >
          <Card className="bg-chart-5/10 border-chart-5/30">
            <CardContent className="p-4">
              <div className="flex items-start gap-3">
                <div className="w-8 h-8 rounded-lg bg-chart-5/20 flex items-center justify-center flex-shrink-0">
                  <AlertTriangle className="w-4 h-4 text-chart-5" />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium">High dopamine activity detected</p>
                  <p className="text-xs text-muted-foreground mt-0.5">
                    You've been scrolling for 25 minutes. Consider taking a break.
                  </p>
                </div>
                <button 
                  onClick={() => setShowAlert(false)}
                  className="text-muted-foreground hover:text-foreground text-lg leading-none"
                >
                  ×
                </button>
              </div>
            </CardContent>
          </Card>
        </motion.div>
      )}

      {/* Main content */}
      <main className="px-6 space-y-4">
        {/* Dopamine Score Card */}
        <Card className="overflow-hidden">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Brain className="w-5 h-5 text-muted-foreground" />
                <span className="text-sm font-medium">Dopamine Score</span>
              </div>
              <span className={`text-sm font-medium ${getScoreColor(dopamineScore)}`}>
                {getScoreLabel(dopamineScore)}
              </span>
            </div>
            
            <div className="flex items-end gap-2 mb-4">
              <span className={`text-5xl font-semibold tracking-tight ${getScoreColor(dopamineScore)}`}>
                {dopamineScore}
              </span>
              <span className="text-muted-foreground text-lg mb-1">/100</span>
            </div>

            <div className="flex items-center gap-2 text-sm text-muted-foreground">
              <TrendingDown className="w-4 h-4 text-dopamine-low" />
              <span>3% better than yesterday</span>
            </div>
          </CardContent>
        </Card>

        {/* Focus Mode Quick Actions */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base font-medium flex items-center gap-2">
              <Shield className="w-4 h-4" />
              Focus Mode
            </CardTitle>
          </CardHeader>
          <CardContent className="pt-0">
            <div className="grid grid-cols-3 gap-2">
              {(['study', 'work', 'detox'] as const).map((mode) => (
                <Button
                  key={mode}
                  variant={focusMode === mode ? "default" : "outline"}
                  size="sm"
                  onClick={() => onSetFocusMode(focusMode === mode ? 'off' : mode)}
                  className="h-10 capitalize"
                >
                  {mode}
                </Button>
              ))}
            </div>
            {focusMode !== 'off' && (
              <motion.div 
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: 'auto' }}
                className="mt-3 p-3 rounded-lg bg-muted/50"
              >
                <div className="flex items-center gap-2 text-sm">
                  <div className="w-2 h-2 rounded-full bg-focus-active animate-pulse" />
                  <span className="capitalize">{focusMode} Mode Active</span>
                </div>
              </motion.div>
            )}
          </CardContent>
        </Card>

        {/* Daily Progress */}
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center gap-2">
                <Clock className="w-4 h-4 text-muted-foreground" />
                <span className="text-sm font-medium">Focus Time Today</span>
              </div>
              <span className="text-sm text-muted-foreground">
                {focusMinutesToday}m / {dailyFocusGoal}m
              </span>
            </div>
            <Progress value={focusProgress} className="h-2" />
            <p className="text-xs text-muted-foreground mt-2">
              {dailyFocusGoal - focusMinutesToday > 0 
                ? `${dailyFocusGoal - focusMinutesToday} minutes to reach your goal`
                : "Goal achieved! Great work!"
              }
            </p>
          </CardContent>
        </Card>

        {/* Top Distracting Apps */}
        <Card>
          <CardHeader className="pb-3">
            <div className="flex items-center justify-between">
              <CardTitle className="text-base font-medium flex items-center gap-2">
                <Zap className="w-4 h-4" />
                High Dopamine Apps
              </CardTitle>
              <Button 
                variant="ghost" 
                size="sm" 
                className="h-8 text-xs"
                onClick={() => onNavigate('analytics')}
              >
                View All
                <ChevronRight className="w-3 h-3 ml-1" />
              </Button>
            </div>
          </CardHeader>
          <CardContent className="pt-0">
            <div className="space-y-3">
              {topDistracting.map((app, index) => (
                <div key={app.appName} className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-muted flex items-center justify-center text-lg">
                    {app.icon}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium">{app.appName}</p>
                    <p className="text-xs text-muted-foreground">{app.usageMinutes} min today</p>
                  </div>
                  <div className="w-16">
                    <div className="h-1.5 rounded-full bg-muted overflow-hidden">
                      <div 
                        className="h-full rounded-full bg-dopamine-high"
                        style={{ width: `${Math.min((app.usageMinutes / 120) * 100, 100)}%` }}
                      />
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* AI Habit Coach CTA */}
        <Card 
          className="cursor-pointer hover:bg-muted/30 transition-colors"
          onClick={() => onNavigate('habit-coach')}
        >
          <CardContent className="p-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-2xl bg-chart-2/20 flex items-center justify-center">
                <Sparkles className="w-6 h-6 text-chart-2" />
              </div>
              <div className="flex-1">
                <p className="font-medium">AI Habit Coach</p>
                <p className="text-sm text-muted-foreground">
                  Get personalized suggestions to improve focus
                </p>
              </div>
              <ChevronRight className="w-5 h-5 text-muted-foreground" />
            </div>
          </CardContent>
        </Card>
      </main>
    </div>
  )
}

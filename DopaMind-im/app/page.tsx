"use client"

import { useEffect, useState } from "react"
import { AnimatePresence, motion } from "framer-motion"
import { useAppStore } from "@/lib/store"
import { Onboarding } from "@/components/onboarding"
import { AuthScreen } from "@/components/auth-screen"
import { Dashboard } from "@/components/dashboard"
import { AnalyticsScreen } from "@/components/analytics-screen"
import { FocusModeScreen } from "@/components/focus-mode-screen"
import { HabitCoachScreen } from "@/components/habit-coach-screen"
import { SettingsScreen } from "@/components/settings-screen"
import { BottomNav } from "@/components/bottom-nav"

export default function Home() {
  const [mounted, setMounted] = useState(false)
  
  const {
    currentScreen,
    hasCompletedOnboarding,
    isAuthenticated,
    userName,
    email,
    currentDopamineScore,
    focusMode,
    focusModeStartTime,
    dailyFocusGoal,
    appUsage,
    weeklyStats,
    notificationsEnabled,
    smartInterventions,
    darkMode,
    setScreen,
    completeOnboarding,
    login,
    logout,
    setFocusMode,
    toggleSetting,
  } = useAppStore()

  useEffect(() => {
    setMounted(true)
  }, [])

  // Handle dark mode
  useEffect(() => {
    if (mounted) {
      document.documentElement.classList.toggle('dark', darkMode)
    }
  }, [darkMode, mounted])

  // Determine current screen based on auth state
  useEffect(() => {
    if (mounted) {
      if (!hasCompletedOnboarding) {
        setScreen('onboarding')
      } else if (!isAuthenticated) {
        setScreen('auth')
      } else if (currentScreen === 'onboarding' || currentScreen === 'auth') {
        setScreen('dashboard')
      }
    }
  }, [mounted, hasCompletedOnboarding, isAuthenticated, currentScreen, setScreen])

  // Calculate focus minutes today (mock)
  const focusMinutesToday = 155

  if (!mounted) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="w-8 h-8 rounded-lg bg-primary animate-pulse" />
      </div>
    )
  }

  const showBottomNav = isAuthenticated && 
    ['dashboard', 'analytics', 'focus-mode', 'habit-coach', 'settings'].includes(currentScreen)

  return (
    <div className="min-h-screen bg-background max-w-lg mx-auto relative">
      <AnimatePresence mode="wait">
        {currentScreen === 'onboarding' && (
          <motion.div
            key="onboarding"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          >
            <Onboarding onComplete={completeOnboarding} />
          </motion.div>
        )}

        {currentScreen === 'auth' && (
          <motion.div
            key="auth"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          >
            <AuthScreen onLogin={login} />
          </motion.div>
        )}

        {currentScreen === 'dashboard' && (
          <motion.div
            key="dashboard"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
          >
            <Dashboard
              userName={userName}
              dopamineScore={currentDopamineScore}
              focusMode={focusMode}
              focusMinutesToday={focusMinutesToday}
              dailyFocusGoal={dailyFocusGoal}
              appUsage={appUsage}
              onSetFocusMode={setFocusMode}
              onNavigate={setScreen}
            />
          </motion.div>
        )}

        {currentScreen === 'analytics' && (
          <motion.div
            key="analytics"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
          >
            <AnalyticsScreen
              weeklyStats={weeklyStats}
              appUsage={appUsage}
            />
          </motion.div>
        )}

        {currentScreen === 'focus-mode' && (
          <motion.div
            key="focus-mode"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
          >
            <FocusModeScreen
              currentMode={focusMode}
              onSetMode={setFocusMode}
              focusModeStartTime={focusModeStartTime}
            />
          </motion.div>
        )}

        {currentScreen === 'habit-coach' && (
          <motion.div
            key="habit-coach"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
          >
            <HabitCoachScreen />
          </motion.div>
        )}

        {currentScreen === 'settings' && (
          <motion.div
            key="settings"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
          >
            <SettingsScreen
              userName={userName}
              email={email}
              notificationsEnabled={notificationsEnabled}
              smartInterventions={smartInterventions}
              darkMode={darkMode}
              onToggleSetting={toggleSetting}
              onLogout={logout}
            />
          </motion.div>
        )}
      </AnimatePresence>

      {/* Bottom Navigation */}
      {showBottomNav && (
        <BottomNav currentScreen={currentScreen} onNavigate={setScreen} />
      )}
    </div>
  )
}

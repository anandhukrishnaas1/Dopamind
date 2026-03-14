import { create } from 'zustand'
import { persist } from 'zustand/middleware'

export type AppScreen = 
  | 'onboarding' 
  | 'auth' 
  | 'dashboard' 
  | 'analytics' 
  | 'focus-mode' 
  | 'settings'
  | 'habit-coach'

export type FocusMode = 'off' | 'study' | 'work' | 'detox'

interface AppUsage {
  appName: string
  icon: string
  usageMinutes: number
  dopamineImpact: 'low' | 'medium' | 'high'
  category: 'social' | 'entertainment' | 'productivity' | 'gaming' | 'other'
}

interface DailyStats {
  date: string
  dopamineScore: number
  focusMinutes: number
  totalScreenTime: number
  scrollSessions: number
  interventions: number
}

interface AppState {
  // Navigation
  currentScreen: AppScreen
  hasCompletedOnboarding: boolean
  isAuthenticated: boolean
  
  // User data
  userName: string
  email: string
  
  // Dopamine & Focus
  currentDopamineScore: number
  focusMode: FocusMode
  focusModeStartTime: number | null
  dailyFocusGoal: number
  
  // Usage data
  appUsage: AppUsage[]
  weeklyStats: DailyStats[]
  
  // Settings
  notificationsEnabled: boolean
  smartInterventions: boolean
  darkMode: boolean
  
  // Actions
  setScreen: (screen: AppScreen) => void
  completeOnboarding: () => void
  login: (name: string, email: string) => void
  logout: () => void
  setFocusMode: (mode: FocusMode) => void
  updateDopamineScore: (score: number) => void
  toggleSetting: (setting: 'notificationsEnabled' | 'smartInterventions' | 'darkMode') => void
}

// Mock data for demonstration
const mockAppUsage: AppUsage[] = [
  { appName: 'Instagram', icon: '📸', usageMinutes: 95, dopamineImpact: 'high', category: 'social' },
  { appName: 'TikTok', icon: '🎵', usageMinutes: 78, dopamineImpact: 'high', category: 'entertainment' },
  { appName: 'Twitter', icon: '🐦', usageMinutes: 45, dopamineImpact: 'high', category: 'social' },
  { appName: 'YouTube', icon: '▶️', usageMinutes: 62, dopamineImpact: 'medium', category: 'entertainment' },
  { appName: 'Slack', icon: '💬', usageMinutes: 35, dopamineImpact: 'low', category: 'productivity' },
  { appName: 'Notion', icon: '📝', usageMinutes: 28, dopamineImpact: 'low', category: 'productivity' },
]

const mockWeeklyStats: DailyStats[] = [
  { date: '2024-01-08', dopamineScore: 72, focusMinutes: 145, totalScreenTime: 285, scrollSessions: 12, interventions: 3 },
  { date: '2024-01-09', dopamineScore: 68, focusMinutes: 120, totalScreenTime: 310, scrollSessions: 15, interventions: 5 },
  { date: '2024-01-10', dopamineScore: 75, focusMinutes: 180, totalScreenTime: 260, scrollSessions: 8, interventions: 2 },
  { date: '2024-01-11', dopamineScore: 62, focusMinutes: 90, totalScreenTime: 340, scrollSessions: 18, interventions: 7 },
  { date: '2024-01-12', dopamineScore: 78, focusMinutes: 200, totalScreenTime: 240, scrollSessions: 6, interventions: 1 },
  { date: '2024-01-13', dopamineScore: 71, focusMinutes: 155, totalScreenTime: 275, scrollSessions: 10, interventions: 4 },
  { date: '2024-01-14', dopamineScore: 74, focusMinutes: 170, totalScreenTime: 265, scrollSessions: 9, interventions: 3 },
]

export const useAppStore = create<AppState>()(
  persist(
    (set) => ({
      // Initial state
      currentScreen: 'onboarding',
      hasCompletedOnboarding: false,
      isAuthenticated: false,
      userName: '',
      email: '',
      currentDopamineScore: 74,
      focusMode: 'off',
      focusModeStartTime: null,
      dailyFocusGoal: 180,
      appUsage: mockAppUsage,
      weeklyStats: mockWeeklyStats,
      notificationsEnabled: true,
      smartInterventions: true,
      darkMode: false,

      // Actions
      setScreen: (screen) => set({ currentScreen: screen }),
      
      completeOnboarding: () => set({ 
        hasCompletedOnboarding: true, 
        currentScreen: 'auth' 
      }),
      
      login: (name, email) => set({ 
        isAuthenticated: true, 
        userName: name, 
        email,
        currentScreen: 'dashboard' 
      }),
      
      logout: () => set({ 
        isAuthenticated: false, 
        userName: '', 
        email: '',
        currentScreen: 'auth' 
      }),
      
      setFocusMode: (mode) => set({ 
        focusMode: mode,
        focusModeStartTime: mode !== 'off' ? Date.now() : null
      }),
      
      updateDopamineScore: (score) => set({ currentDopamineScore: score }),
      
      toggleSetting: (setting) => set((state) => ({ 
        [setting]: !state[setting] 
      })),
    }),
    {
      name: 'dopamine-os-storage',
      partialize: (state) => ({
        hasCompletedOnboarding: state.hasCompletedOnboarding,
        isAuthenticated: state.isAuthenticated,
        userName: state.userName,
        email: state.email,
        notificationsEnabled: state.notificationsEnabled,
        smartInterventions: state.smartInterventions,
        darkMode: state.darkMode,
      }),
    }
  )
)

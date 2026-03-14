"use client"

import { motion } from "framer-motion"
import { Home, BarChart3, Shield, Sparkles, Settings } from "lucide-react"
import type { AppScreen } from "@/lib/store"

interface BottomNavProps {
  currentScreen: AppScreen
  onNavigate: (screen: AppScreen) => void
}

const navItems = [
  { id: 'dashboard' as const, label: 'Home', icon: Home },
  { id: 'analytics' as const, label: 'Analytics', icon: BarChart3 },
  { id: 'focus-mode' as const, label: 'Focus', icon: Shield },
  { id: 'habit-coach' as const, label: 'Coach', icon: Sparkles },
  { id: 'settings' as const, label: 'Settings', icon: Settings },
]

export function BottomNav({ currentScreen, onNavigate }: BottomNavProps) {
  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-background/95 backdrop-blur-lg border-t border-border safe-area-bottom">
      <div className="flex items-center justify-around h-16 max-w-lg mx-auto px-2">
        {navItems.map((item) => {
          const isActive = currentScreen === item.id
          return (
            <button
              key={item.id}
              onClick={() => onNavigate(item.id)}
              className="relative flex flex-col items-center justify-center w-16 h-full"
            >
              <div className="relative">
                {isActive && (
                  <motion.div
                    layoutId="nav-indicator"
                    className="absolute -inset-2 bg-primary/10 rounded-xl"
                    transition={{ type: "spring", stiffness: 500, damping: 30 }}
                  />
                )}
                <item.icon 
                  className={`relative w-5 h-5 transition-colors ${
                    isActive ? 'text-primary' : 'text-muted-foreground'
                  }`} 
                />
              </div>
              <span 
                className={`text-[10px] mt-1 transition-colors ${
                  isActive ? 'text-primary font-medium' : 'text-muted-foreground'
                }`}
              >
                {item.label}
              </span>
            </button>
          )
        })}
      </div>
    </nav>
  )
}

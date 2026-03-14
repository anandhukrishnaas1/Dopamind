"use client"

import { useState, useEffect } from "react"
import { motion } from "framer-motion"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Switch } from "@/components/ui/switch"
import { 
  Shield, 
  Book, 
  Briefcase, 
  Leaf,
  Play,
  Pause,
  RotateCcw,
  Clock,
  Ban,
  Check
} from "lucide-react"
import type { FocusMode } from "@/lib/store"

interface FocusModeScreenProps {
  currentMode: FocusMode
  onSetMode: (mode: FocusMode) => void
  focusModeStartTime: number | null
}

const focusModes = [
  {
    id: 'study' as const,
    name: 'Study Mode',
    description: 'Block social media and entertainment apps',
    icon: Book,
    blockedApps: ['Instagram', 'TikTok', 'Twitter', 'YouTube', 'Netflix'],
    color: 'bg-chart-1',
  },
  {
    id: 'work' as const,
    name: 'Work Mode',
    description: 'Allow productivity tools, block distractions',
    icon: Briefcase,
    blockedApps: ['TikTok', 'Instagram', 'Games', 'Netflix'],
    color: 'bg-chart-2',
  },
  {
    id: 'detox' as const,
    name: 'Digital Detox',
    description: 'Block all non-essential apps',
    icon: Leaf,
    blockedApps: ['All Social Media', 'All Entertainment', 'All Games'],
    color: 'bg-chart-3',
  },
]

export function FocusModeScreen({ currentMode, onSetMode, focusModeStartTime }: FocusModeScreenProps) {
  const [elapsedTime, setElapsedTime] = useState(0)
  const [smartActivation, setSmartActivation] = useState(true)
  const [scheduleEnabled, setScheduleEnabled] = useState(false)

  useEffect(() => {
    if (currentMode !== 'off' && focusModeStartTime) {
      const interval = setInterval(() => {
        setElapsedTime(Math.floor((Date.now() - focusModeStartTime) / 1000))
      }, 1000)
      return () => clearInterval(interval)
    } else {
      setElapsedTime(0)
    }
  }, [currentMode, focusModeStartTime])

  const formatTime = (seconds: number) => {
    const hrs = Math.floor(seconds / 3600)
    const mins = Math.floor((seconds % 3600) / 60)
    const secs = seconds % 60
    if (hrs > 0) {
      return `${hrs}:${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
    }
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }

  const activeMode = focusModes.find(m => m.id === currentMode)

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header */}
      <header className="px-6 pt-6 pb-4">
        <div className="flex items-center gap-2 mb-1">
          <Shield className="w-5 h-5" />
          <h1 className="text-xl font-semibold tracking-tight">Focus Mode</h1>
        </div>
        <p className="text-sm text-muted-foreground">Block distractions and stay focused</p>
      </header>

      <main className="px-6 space-y-4">
        {/* Active Session */}
        {currentMode !== 'off' && activeMode && (
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
          >
            <Card className="border-2 border-focus-active/30 bg-focus-active/5">
              <CardContent className="p-6">
                <div className="flex items-center gap-3 mb-4">
                  <div className={`w-12 h-12 rounded-2xl ${activeMode.color}/20 flex items-center justify-center`}>
                    <activeMode.icon className="w-6 h-6" />
                  </div>
                  <div>
                    <p className="font-medium">{activeMode.name}</p>
                    <div className="flex items-center gap-1 text-sm text-muted-foreground">
                      <div className="w-2 h-2 rounded-full bg-focus-active animate-pulse" />
                      <span>Active</span>
                    </div>
                  </div>
                </div>

                {/* Timer */}
                <div className="text-center py-6">
                  <div className="text-5xl font-mono font-semibold tracking-tight">
                    {formatTime(elapsedTime)}
                  </div>
                  <p className="text-sm text-muted-foreground mt-2">Session Duration</p>
                </div>

                {/* Controls */}
                <div className="flex items-center justify-center gap-3">
                  <Button 
                    variant="outline" 
                    size="icon"
                    className="w-12 h-12 rounded-full"
                    onClick={() => onSetMode('off')}
                  >
                    <Pause className="w-5 h-5" />
                  </Button>
                  <Button 
                    variant="outline" 
                    size="icon"
                    className="w-12 h-12 rounded-full"
                    onClick={() => {
                      onSetMode('off')
                      setTimeout(() => onSetMode(currentMode), 100)
                    }}
                  >
                    <RotateCcw className="w-5 h-5" />
                  </Button>
                </div>
              </CardContent>
            </Card>
          </motion.div>
        )}

        {/* Mode Selection */}
        <div className="space-y-3">
          <h2 className="text-sm font-medium text-muted-foreground">Select Mode</h2>
          {focusModes.map((mode) => {
            const isActive = currentMode === mode.id
            return (
              <Card 
                key={mode.id}
                className={`cursor-pointer transition-all ${
                  isActive 
                    ? 'border-2 border-primary bg-primary/5' 
                    : 'hover:bg-muted/30'
                }`}
                onClick={() => onSetMode(isActive ? 'off' : mode.id)}
              >
                <CardContent className="p-4">
                  <div className="flex items-start gap-3">
                    <div className={`w-10 h-10 rounded-xl ${mode.color}/20 flex items-center justify-center flex-shrink-0`}>
                      <mode.icon className="w-5 h-5" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between">
                        <p className="font-medium">{mode.name}</p>
                        {isActive && (
                          <div className="w-5 h-5 rounded-full bg-primary flex items-center justify-center">
                            <Check className="w-3 h-3 text-primary-foreground" />
                          </div>
                        )}
                      </div>
                      <p className="text-sm text-muted-foreground mt-0.5">{mode.description}</p>
                      
                      {/* Blocked Apps Preview */}
                      <div className="flex items-center gap-1.5 mt-2 flex-wrap">
                        <Ban className="w-3 h-3 text-muted-foreground" />
                        {mode.blockedApps.slice(0, 3).map((app) => (
                          <span key={app} className="text-xs bg-muted px-1.5 py-0.5 rounded">
                            {app}
                          </span>
                        ))}
                        {mode.blockedApps.length > 3 && (
                          <span className="text-xs text-muted-foreground">
                            +{mode.blockedApps.length - 3} more
                          </span>
                        )}
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            )
          })}
        </div>

        {/* Quick Start Button */}
        {currentMode === 'off' && (
          <Button 
            className="w-full h-12 text-base"
            onClick={() => onSetMode('study')}
          >
            <Play className="w-4 h-4 mr-2" />
            Start Focus Session
          </Button>
        )}

        {/* Settings */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base font-medium">Focus Settings</CardTitle>
          </CardHeader>
          <CardContent className="pt-0 space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium">Smart Activation</p>
                <p className="text-xs text-muted-foreground">
                  Auto-activate when high dopamine detected
                </p>
              </div>
              <Switch 
                checked={smartActivation} 
                onCheckedChange={setSmartActivation}
              />
            </div>
            
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium">Scheduled Sessions</p>
                <p className="text-xs text-muted-foreground">
                  Set recurring focus times
                </p>
              </div>
              <Switch 
                checked={scheduleEnabled} 
                onCheckedChange={setScheduleEnabled}
              />
            </div>
          </CardContent>
        </Card>

        {/* Today's Stats */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-sm font-medium flex items-center gap-2">
              <Clock className="w-4 h-4" />
              {"Today's Focus"}
            </CardTitle>
          </CardHeader>
          <CardContent className="pt-0">
            <div className="grid grid-cols-2 gap-4">
              <div className="text-center p-3 rounded-lg bg-muted/50">
                <div className="text-2xl font-semibold">2h 35m</div>
                <div className="text-xs text-muted-foreground mt-1">Total Focus Time</div>
              </div>
              <div className="text-center p-3 rounded-lg bg-muted/50">
                <div className="text-2xl font-semibold">4</div>
                <div className="text-xs text-muted-foreground mt-1">Sessions Completed</div>
              </div>
            </div>
          </CardContent>
        </Card>
      </main>
    </div>
  )
}

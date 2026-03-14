"use client"

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Switch } from "@/components/ui/switch"
import { 
  Settings, 
  User,
  Bell,
  Brain,
  Moon,
  Shield,
  HelpCircle,
  FileText,
  LogOut,
  ChevronRight,
  Mail
} from "lucide-react"

interface SettingsScreenProps {
  userName: string
  email: string
  notificationsEnabled: boolean
  smartInterventions: boolean
  darkMode: boolean
  onToggleSetting: (setting: 'notificationsEnabled' | 'smartInterventions' | 'darkMode') => void
  onLogout: () => void
}

export function SettingsScreen({
  userName,
  email,
  notificationsEnabled,
  smartInterventions,
  darkMode,
  onToggleSetting,
  onLogout,
}: SettingsScreenProps) {
  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header */}
      <header className="px-6 pt-6 pb-4">
        <div className="flex items-center gap-2 mb-1">
          <Settings className="w-5 h-5" />
          <h1 className="text-xl font-semibold tracking-tight">Settings</h1>
        </div>
      </header>

      <main className="px-6 space-y-4">
        {/* Profile Card */}
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-4">
              <div className="w-14 h-14 rounded-full bg-primary flex items-center justify-center">
                <span className="text-xl font-semibold text-primary-foreground">
                  {userName.charAt(0).toUpperCase()}
                </span>
              </div>
              <div className="flex-1">
                <p className="font-medium">{userName}</p>
                <p className="text-sm text-muted-foreground">{email}</p>
              </div>
              <Button variant="outline" size="sm">
                Edit
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Notifications */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base font-medium flex items-center gap-2">
              <Bell className="w-4 h-4" />
              Notifications
            </CardTitle>
          </CardHeader>
          <CardContent className="pt-0 space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium">Push Notifications</p>
                <p className="text-xs text-muted-foreground">
                  Get alerts for focus reminders
                </p>
              </div>
              <Switch 
                checked={notificationsEnabled} 
                onCheckedChange={() => onToggleSetting('notificationsEnabled')}
              />
            </div>
            
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium">Daily Summary</p>
                <p className="text-xs text-muted-foreground">
                  Receive daily insights at 9 PM
                </p>
              </div>
              <Switch defaultChecked />
            </div>
          </CardContent>
        </Card>

        {/* AI & Behavior */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base font-medium flex items-center gap-2">
              <Brain className="w-4 h-4" />
              AI & Behavior
            </CardTitle>
          </CardHeader>
          <CardContent className="pt-0 space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium">Smart Interventions</p>
                <p className="text-xs text-muted-foreground">
                  AI-powered break suggestions
                </p>
              </div>
              <Switch 
                checked={smartInterventions} 
                onCheckedChange={() => onToggleSetting('smartInterventions')}
              />
            </div>
            
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium">Prediction Sensitivity</p>
                <p className="text-xs text-muted-foreground">
                  How early to detect patterns
                </p>
              </div>
              <Button variant="outline" size="sm">
                Adjust
              </Button>
            </div>

            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium">Infinite Scroll Detection</p>
                <p className="text-xs text-muted-foreground">
                  Alert during long scroll sessions
                </p>
              </div>
              <Switch defaultChecked />
            </div>
          </CardContent>
        </Card>

        {/* Appearance */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base font-medium flex items-center gap-2">
              <Moon className="w-4 h-4" />
              Appearance
            </CardTitle>
          </CardHeader>
          <CardContent className="pt-0">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium">Dark Mode</p>
                <p className="text-xs text-muted-foreground">
                  Switch to dark theme
                </p>
              </div>
              <Switch 
                checked={darkMode} 
                onCheckedChange={() => onToggleSetting('darkMode')}
              />
            </div>
          </CardContent>
        </Card>

        {/* Privacy & Security */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base font-medium flex items-center gap-2">
              <Shield className="w-4 h-4" />
              Privacy & Security
            </CardTitle>
          </CardHeader>
          <CardContent className="pt-0 space-y-1">
            <button className="w-full flex items-center justify-between py-3 hover:bg-muted/30 rounded-lg px-2 -mx-2 transition-colors">
              <span className="text-sm">Data & Privacy</span>
              <ChevronRight className="w-4 h-4 text-muted-foreground" />
            </button>
            <button className="w-full flex items-center justify-between py-3 hover:bg-muted/30 rounded-lg px-2 -mx-2 transition-colors">
              <span className="text-sm">Export Your Data</span>
              <ChevronRight className="w-4 h-4 text-muted-foreground" />
            </button>
            <button className="w-full flex items-center justify-between py-3 hover:bg-muted/30 rounded-lg px-2 -mx-2 transition-colors">
              <span className="text-sm text-destructive">Delete Account</span>
              <ChevronRight className="w-4 h-4 text-destructive" />
            </button>
          </CardContent>
        </Card>

        {/* Support */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base font-medium flex items-center gap-2">
              <HelpCircle className="w-4 h-4" />
              Support
            </CardTitle>
          </CardHeader>
          <CardContent className="pt-0 space-y-1">
            <button className="w-full flex items-center justify-between py-3 hover:bg-muted/30 rounded-lg px-2 -mx-2 transition-colors">
              <div className="flex items-center gap-2">
                <HelpCircle className="w-4 h-4 text-muted-foreground" />
                <span className="text-sm">Help Center</span>
              </div>
              <ChevronRight className="w-4 h-4 text-muted-foreground" />
            </button>
            <button className="w-full flex items-center justify-between py-3 hover:bg-muted/30 rounded-lg px-2 -mx-2 transition-colors">
              <div className="flex items-center gap-2">
                <Mail className="w-4 h-4 text-muted-foreground" />
                <span className="text-sm">Contact Us</span>
              </div>
              <ChevronRight className="w-4 h-4 text-muted-foreground" />
            </button>
            <button className="w-full flex items-center justify-between py-3 hover:bg-muted/30 rounded-lg px-2 -mx-2 transition-colors">
              <div className="flex items-center gap-2">
                <FileText className="w-4 h-4 text-muted-foreground" />
                <span className="text-sm">Terms & Privacy Policy</span>
              </div>
              <ChevronRight className="w-4 h-4 text-muted-foreground" />
            </button>
          </CardContent>
        </Card>

        {/* Sign Out */}
        <Button 
          variant="outline" 
          className="w-full h-12 text-destructive hover:text-destructive hover:bg-destructive/10"
          onClick={onLogout}
        >
          <LogOut className="w-4 h-4 mr-2" />
          Sign Out
        </Button>

        {/* Version */}
        <p className="text-center text-xs text-muted-foreground">
          DopamineOS v1.0.0
        </p>
      </main>
    </div>
  )
}

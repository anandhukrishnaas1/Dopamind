"use client"

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { 
  BarChart3, 
  Clock, 
  TrendingUp, 
  TrendingDown,
  Zap,
  Target,
  Calendar
} from "lucide-react"
import {
  AreaChart,
  Area,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
} from "recharts"

interface AnalyticsScreenProps {
  weeklyStats: Array<{
    date: string
    dopamineScore: number
    focusMinutes: number
    totalScreenTime: number
    scrollSessions: number
  }>
  appUsage: Array<{
    appName: string
    icon: string
    usageMinutes: number
    dopamineImpact: 'low' | 'medium' | 'high'
    category: string
  }>
}

export function AnalyticsScreen({ weeklyStats, appUsage }: AnalyticsScreenProps) {
  const chartData = weeklyStats.map(stat => ({
    ...stat,
    day: new Date(stat.date).toLocaleDateString('en-US', { weekday: 'short' }),
    focusHours: Math.round(stat.focusMinutes / 60 * 10) / 10,
    screenHours: Math.round(stat.totalScreenTime / 60 * 10) / 10,
  }))

  const avgDopamineScore = Math.round(
    weeklyStats.reduce((acc, s) => acc + s.dopamineScore, 0) / weeklyStats.length
  )

  const totalFocusTime = weeklyStats.reduce((acc, s) => acc + s.focusMinutes, 0)
  const avgFocusTime = Math.round(totalFocusTime / weeklyStats.length)

  const totalScrollSessions = weeklyStats.reduce((acc, s) => acc + s.scrollSessions, 0)

  const sortedApps = [...appUsage].sort((a, b) => b.usageMinutes - a.usageMinutes)

  const getDopamineColor = (impact: string) => {
    switch (impact) {
      case 'high': return 'bg-dopamine-high'
      case 'medium': return 'bg-dopamine-medium'
      case 'low': return 'bg-dopamine-low'
      default: return 'bg-muted'
    }
  }

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header */}
      <header className="px-6 pt-6 pb-4">
        <div className="flex items-center gap-2 mb-1">
          <BarChart3 className="w-5 h-5" />
          <h1 className="text-xl font-semibold tracking-tight">Analytics</h1>
        </div>
        <p className="text-sm text-muted-foreground">Your attention health insights</p>
      </header>

      {/* Main content */}
      <main className="px-6 space-y-4">
        {/* Summary Stats */}
        <div className="grid grid-cols-3 gap-3">
          <Card>
            <CardContent className="p-4 text-center">
              <div className="text-2xl font-semibold text-dopamine-low">{avgDopamineScore}</div>
              <div className="text-xs text-muted-foreground mt-1">Avg Score</div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="p-4 text-center">
              <div className="text-2xl font-semibold">{avgFocusTime}</div>
              <div className="text-xs text-muted-foreground mt-1">Focus Min/Day</div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="p-4 text-center">
              <div className="text-2xl font-semibold text-dopamine-high">{totalScrollSessions}</div>
              <div className="text-xs text-muted-foreground mt-1">Scroll Sessions</div>
            </CardContent>
          </Card>
        </div>

        {/* Charts */}
        <Tabs defaultValue="score" className="w-full">
          <TabsList className="w-full grid grid-cols-3 h-10">
            <TabsTrigger value="score" className="text-xs">Score</TabsTrigger>
            <TabsTrigger value="focus" className="text-xs">Focus</TabsTrigger>
            <TabsTrigger value="screen" className="text-xs">Screen Time</TabsTrigger>
          </TabsList>

          <TabsContent value="score" className="mt-4">
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm font-medium flex items-center gap-2">
                  <Target className="w-4 h-4" />
                  Dopamine Score Trend
                </CardTitle>
              </CardHeader>
              <CardContent className="pt-0">
                <div className="h-48">
                  <ResponsiveContainer width="100%" height="100%">
                    <AreaChart data={chartData}>
                      <defs>
                        <linearGradient id="scoreGradient" x1="0" y1="0" x2="0" y2="1">
                          <stop offset="5%" stopColor="hsl(var(--chart-2))" stopOpacity={0.3}/>
                          <stop offset="95%" stopColor="hsl(var(--chart-2))" stopOpacity={0}/>
                        </linearGradient>
                      </defs>
                      <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                      <XAxis 
                        dataKey="day" 
                        tick={{ fontSize: 11, fill: 'hsl(var(--muted-foreground))' }}
                        axisLine={{ stroke: 'hsl(var(--border))' }}
                        tickLine={false}
                      />
                      <YAxis 
                        domain={[0, 100]}
                        tick={{ fontSize: 11, fill: 'hsl(var(--muted-foreground))' }}
                        axisLine={{ stroke: 'hsl(var(--border))' }}
                        tickLine={false}
                      />
                      <Tooltip 
                        contentStyle={{ 
                          backgroundColor: 'hsl(var(--card))', 
                          border: '1px solid hsl(var(--border))',
                          borderRadius: '8px',
                          fontSize: '12px'
                        }}
                      />
                      <Area 
                        type="monotone" 
                        dataKey="dopamineScore" 
                        stroke="hsl(var(--chart-2))" 
                        strokeWidth={2}
                        fill="url(#scoreGradient)" 
                      />
                    </AreaChart>
                  </ResponsiveContainer>
                </div>
                <div className="flex items-center gap-2 mt-3 text-sm">
                  <TrendingUp className="w-4 h-4 text-dopamine-low" />
                  <span className="text-muted-foreground">Score improving this week</span>
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="focus" className="mt-4">
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm font-medium flex items-center gap-2">
                  <Clock className="w-4 h-4" />
                  Daily Focus Time
                </CardTitle>
              </CardHeader>
              <CardContent className="pt-0">
                <div className="h-48">
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart data={chartData}>
                      <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                      <XAxis 
                        dataKey="day" 
                        tick={{ fontSize: 11, fill: 'hsl(var(--muted-foreground))' }}
                        axisLine={{ stroke: 'hsl(var(--border))' }}
                        tickLine={false}
                      />
                      <YAxis 
                        tick={{ fontSize: 11, fill: 'hsl(var(--muted-foreground))' }}
                        axisLine={{ stroke: 'hsl(var(--border))' }}
                        tickLine={false}
                      />
                      <Tooltip 
                        contentStyle={{ 
                          backgroundColor: 'hsl(var(--card))', 
                          border: '1px solid hsl(var(--border))',
                          borderRadius: '8px',
                          fontSize: '12px'
                        }}
                      />
                      <Bar 
                        dataKey="focusMinutes" 
                        fill="hsl(var(--chart-1))" 
                        radius={[4, 4, 0, 0]}
                      />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="screen" className="mt-4">
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm font-medium flex items-center gap-2">
                  <Calendar className="w-4 h-4" />
                  Screen Time (hours)
                </CardTitle>
              </CardHeader>
              <CardContent className="pt-0">
                <div className="h-48">
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart data={chartData}>
                      <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                      <XAxis 
                        dataKey="day" 
                        tick={{ fontSize: 11, fill: 'hsl(var(--muted-foreground))' }}
                        axisLine={{ stroke: 'hsl(var(--border))' }}
                        tickLine={false}
                      />
                      <YAxis 
                        tick={{ fontSize: 11, fill: 'hsl(var(--muted-foreground))' }}
                        axisLine={{ stroke: 'hsl(var(--border))' }}
                        tickLine={false}
                      />
                      <Tooltip 
                        contentStyle={{ 
                          backgroundColor: 'hsl(var(--card))', 
                          border: '1px solid hsl(var(--border))',
                          borderRadius: '8px',
                          fontSize: '12px'
                        }}
                      />
                      <Bar 
                        dataKey="screenHours" 
                        fill="hsl(var(--chart-5))" 
                        radius={[4, 4, 0, 0]}
                      />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
                <div className="flex items-center gap-2 mt-3 text-sm">
                  <TrendingDown className="w-4 h-4 text-dopamine-low" />
                  <span className="text-muted-foreground">12% less than last week</span>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>

        {/* App Usage Breakdown */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base font-medium flex items-center gap-2">
              <Zap className="w-4 h-4" />
              App Usage Today
            </CardTitle>
          </CardHeader>
          <CardContent className="pt-0">
            <div className="space-y-4">
              {sortedApps.map((app) => (
                <div key={app.appName} className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-muted flex items-center justify-center text-lg">
                    {app.icon}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between mb-1">
                      <p className="text-sm font-medium">{app.appName}</p>
                      <p className="text-xs text-muted-foreground">{app.usageMinutes} min</p>
                    </div>
                    <div className="h-1.5 rounded-full bg-muted overflow-hidden">
                      <div 
                        className={`h-full rounded-full ${getDopamineColor(app.dopamineImpact)}`}
                        style={{ width: `${Math.min((app.usageMinutes / 120) * 100, 100)}%` }}
                      />
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Legend */}
            <div className="flex items-center justify-center gap-4 mt-6 pt-4 border-t border-border">
              <div className="flex items-center gap-1.5">
                <div className="w-2 h-2 rounded-full bg-dopamine-low" />
                <span className="text-xs text-muted-foreground">Low</span>
              </div>
              <div className="flex items-center gap-1.5">
                <div className="w-2 h-2 rounded-full bg-dopamine-medium" />
                <span className="text-xs text-muted-foreground">Medium</span>
              </div>
              <div className="flex items-center gap-1.5">
                <div className="w-2 h-2 rounded-full bg-dopamine-high" />
                <span className="text-xs text-muted-foreground">High</span>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Peak Distraction Hours */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-sm font-medium">Peak Distraction Hours</CardTitle>
          </CardHeader>
          <CardContent className="pt-0">
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">9:00 PM - 11:00 PM</span>
                <span className="text-sm font-medium text-dopamine-high">Most Active</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">12:00 PM - 1:00 PM</span>
                <span className="text-sm font-medium text-dopamine-medium">Moderate</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">7:00 AM - 8:00 AM</span>
                <span className="text-sm font-medium text-dopamine-low">Low</span>
              </div>
            </div>
          </CardContent>
        </Card>
      </main>
    </div>
  )
}

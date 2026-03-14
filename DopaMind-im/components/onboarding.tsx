"use client"

import { useState } from "react"
import { motion, AnimatePresence } from "framer-motion"
import { Button } from "@/components/ui/button"
import { Brain, Shield, Target, Sparkles, ChevronRight } from "lucide-react"

interface OnboardingProps {
  onComplete: () => void
}

const slides = [
  {
    icon: Brain,
    title: "Predict Your Digital Habits",
    description: "Our AI analyzes your smartphone usage patterns to predict when you're about to enter an addictive scrolling loop.",
    gradient: "from-chart-1/20 to-chart-2/20",
  },
  {
    icon: Shield,
    title: "Break Dopamine Loops",
    description: "Get intelligent interventions before endless scrolling begins. Take control of your attention and digital wellbeing.",
    gradient: "from-chart-2/20 to-chart-3/20",
  },
  {
    icon: Target,
    title: "Improve Focus & Productivity",
    description: "Smart Focus Mode blocks distracting apps automatically when high dopamine activity is detected.",
    gradient: "from-chart-3/20 to-chart-4/20",
  },
  {
    icon: Sparkles,
    title: "Build Healthier Habits",
    description: "Your AI Habit Coach suggests alternatives and tracks your progress toward a balanced digital lifestyle.",
    gradient: "from-chart-4/20 to-chart-1/20",
  },
]

export function Onboarding({ onComplete }: OnboardingProps) {
  const [currentSlide, setCurrentSlide] = useState(0)

  const nextSlide = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide(currentSlide + 1)
    } else {
      onComplete()
    }
  }

  const skipToEnd = () => {
    onComplete()
  }

  return (
    <div className="min-h-screen flex flex-col bg-background">
      {/* Header */}
      <header className="flex items-center justify-between px-6 py-4">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-lg bg-primary flex items-center justify-center">
            <Brain className="w-5 h-5 text-primary-foreground" />
          </div>
          <span className="font-semibold text-lg tracking-tight">DopamineOS</span>
        </div>
        <Button 
          variant="ghost" 
          size="sm" 
          onClick={skipToEnd}
          className="text-muted-foreground hover:text-foreground"
        >
          Skip
        </Button>
      </header>

      {/* Main content */}
      <main className="flex-1 flex flex-col items-center justify-center px-6 pb-8">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentSlide}
            initial={{ opacity: 0, x: 50 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -50 }}
            transition={{ duration: 0.3, ease: "easeInOut" }}
            className="flex flex-col items-center text-center max-w-sm"
          >
            {/* Icon container */}
            <div className={`w-32 h-32 rounded-3xl bg-gradient-to-br ${slides[currentSlide].gradient} flex items-center justify-center mb-8`}>
              {(() => {
                const Icon = slides[currentSlide].icon
                return <Icon className="w-16 h-16 text-foreground/80" strokeWidth={1.5} />
              })()}
            </div>

            {/* Title */}
            <h1 className="text-2xl font-semibold tracking-tight text-balance mb-4">
              {slides[currentSlide].title}
            </h1>

            {/* Description */}
            <p className="text-muted-foreground leading-relaxed text-pretty">
              {slides[currentSlide].description}
            </p>
          </motion.div>
        </AnimatePresence>
      </main>

      {/* Footer */}
      <footer className="px-6 pb-8 space-y-6">
        {/* Progress dots */}
        <div className="flex items-center justify-center gap-2">
          {slides.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentSlide(index)}
              className={`w-2 h-2 rounded-full transition-all duration-300 ${
                index === currentSlide 
                  ? "w-6 bg-primary" 
                  : "bg-muted-foreground/30 hover:bg-muted-foreground/50"
              }`}
            />
          ))}
        </div>

        {/* Action buttons */}
        <div className="flex gap-3">
          <Button 
            onClick={nextSlide}
            className="flex-1 h-12 text-base font-medium"
            size="lg"
          >
            {currentSlide === slides.length - 1 ? (
              "Get Started"
            ) : (
              <>
                Next
                <ChevronRight className="w-4 h-4 ml-1" />
              </>
            )}
          </Button>
        </div>
      </footer>
    </div>
  )
}

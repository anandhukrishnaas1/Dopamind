# DopamineOS - AI Digital Behavior Prediction System

A premium mobile web app designed to help users monitor, understand, and improve their digital wellness by tracking dopamine triggers, managing screen time, and building healthier smartphone habits.

## Features

- **Dopamine Score Tracking**: Real-time AI analysis of your app usage patterns and dopamine triggers
- **Focus Modes**: Study, Work, and Digital Detox modes with app blocking and time management
- **Analytics Dashboard**: Visual insights into your screen time, app usage, and focus patterns
- **AI Habit Coach**: Personalized recommendations and daily goals for digital wellbeing
- **Smart Notifications**: Intelligent alerts about high-dopamine activities
- **Dark Mode**: Eye-friendly interface with customizable appearance settings

## Tech Stack

- **Frontend**: Next.js 16, React 19, TypeScript
- **State Management**: Zustand
- **Styling**: Tailwind CSS v4
- **UI Components**: shadcn/ui
- **Animations**: Framer Motion
- **Forms**: React Hook Form

## Getting Started

### Prerequisites

- Node.js 18+
- pnpm (recommended) or npm

### Installation

```bash
# Clone the repository
git clone https://github.com/anandhukrishnaas1/Dopamind.git
cd Dopamind

# Install dependencies
pnpm install

# Run the development server
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser to see the app.

## Project Structure

```
├── app/
│   ├── layout.tsx          # Root layout with theme provider
│   ├── globals.css         # Global styles and design tokens
│   └── page.tsx            # Main app orchestrator
├── components/
│   ├── onboarding.tsx      # 4-screen onboarding flow
│   ├── auth-screen.tsx     # Login/Sign up screens
│   ├── dashboard.tsx       # Main dashboard with dopamine score
│   ├── focus-mode-screen.tsx
│   ├── analytics-screen.tsx
│   ├── habit-coach-screen.tsx
│   ├── settings-screen.tsx
│   └── bottom-nav.tsx      # Navigation bar
├── lib/
│   ├── store.ts            # Zustand state management
│   └── utils.ts            # Utility functions
└── public/                 # Static assets
```

## Key Screens

1. **Onboarding** - Introduction to app features with smooth animations
2. **Authentication** - Secure login/sign-up with Google OAuth option
3. **Dashboard** - Central hub showing dopamine score, focus mode controls, and alerts
4. **Analytics** - Charts and insights into usage patterns and trends
5. **Focus Mode** - Activate study/work sessions with app blocking
6. **Habit Coach** - AI-powered recommendations and progress tracking
7. **Settings** - Customize appearance, notifications, and privacy

## Design Philosophy

- **Minimalist Aesthetic**: Clean, distraction-free interface inspired by premium Apple apps
- **Mobile-First**: Responsive design optimized for phone experiences
- **Dark Mode**: Easy on the eyes with elegant platinum/silver/black palette
- **Smooth Animations**: Framer Motion for delightful micro-interactions

## State Management

The app uses Zustand for lightweight, efficient state management with persistence:

```typescript
// Access state from anywhere
const { user, dopamineScore, focusMode } = useStore();

// Update state
useStore.setState({ focusMode: 'active' });
```

## Converting to Native Android

To build this as a native Android app, use Capacitor:

```bash
# Install Capacitor
npm install @capacitor/core @capacitor/cli
npx cap init DopamineOS com.dopamind.app

# Add Android platform
npx cap add android

# Build web assets
pnpm build

# Copy to Capacitor
npx cap copy

# Open in Android Studio
npx cap open android
```

Then use Android Studio to build and deploy the APK.

## Environment Variables

Create a `.env.local` file for local development:

```
NEXT_PUBLIC_APP_NAME=DopamineOS
NEXT_PUBLIC_API_URL=http://localhost:3000/api
```

## Deployment

### Deploy to Vercel

```bash
npm install -g vercel
vercel
```

### Deploy to GitHub Pages

```bash
npm run build
npm run export
```

## Future Enhancements

- Backend integration with real app usage tracking
- Cloud sync across devices
- Advanced AI recommendations
- Community features and challenges
- Integration with health apps (Apple Health, Google Fit)
- Wearable app support

## License

MIT

## Support

For issues and feature requests, please open an issue on GitHub.

---

**Built with focus on digital wellbeing and mindful technology use.**

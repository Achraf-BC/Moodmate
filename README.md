# AI MoodMate

A lightweight mental wellness app for teenagers and young adults (18-25 years old) that helps users check in with their mood, get AI-powered supportive responses, and view anonymous mood posts from the community.

## Features

- **Mood Check-In**: Share your feelings and get supportive AI responses
- **Vibe Wall**: View anonymous mood posts from the community
- **AI-Powered Support**: GPT-3.5 powered responses for emotional support
- **Privacy-First**: Anonymous authentication and data handling
- **Clean UI**: Minimalist design optimized for Gen Z

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase (Auth, Firestore, Analytics)
- **AI**: OpenAI GPT-3.5 API
- **State Management**: Provider
- **Local Storage**: SharedPreferences

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (3.0.0 or higher)
- Firebase project
- OpenAI API key

### 2. Firebase Setup

1. Create a new Firebase project
2. Enable Authentication (Anonymous sign-in)
3. Enable Firestore Database
4. Add your app to Firebase and download configuration files:
   - `android/app/google-services.json` (for Android)
   - `ios/Runner/GoogleService-Info.plist` (for iOS)

### 3. Environment Configuration

1. Copy `.env.example` to `.env`
2. Add your OpenAI API key:
   ```
   OPENAI_API_KEY=your_actual_api_key_here
   ```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── mood_post.dart       # Data models
├── services/
│   ├── auth_service.dart    # Firebase authentication
│   ├── mood_service.dart    # Firestore operations
│   └── openai_service.dart  # OpenAI API integration
├── screens/
│   ├── home_screen.dart     # Main navigation
│   ├── mood_checkin_screen.dart  # Mood input & AI response
│   └── vibe_wall_screen.dart     # Community feed
└── widgets/                 # Reusable UI components
```

## Key Features Implementation

### Authentication
- Anonymous sign-in for privacy
- Automatic authentication on app start

### Mood Check-In
- Text input for mood sharing
- GPT-3.5 powered supportive responses
- Option to share to Vibe Wall

### Vibe Wall
- Real-time Firestore stream
- Anonymous posts with timestamps
- Pull-to-refresh functionality
- AI responses displayed inline

### Security & Privacy
- No personal data collection
- Anonymous posts only
- Secure API key handling via environment variables

## Performance Optimizations

- Stream-based real-time updates
- Efficient Firestore queries with limits
- Minimal API calls to OpenAI
- Lightweight UI components

## Accessibility

- High contrast text
- Proper touch targets
- Screen reader friendly
- Responsive design

## Next Steps

1. **Mood History**: Add local storage for personal mood tracking
2. **Push Notifications**: Remind users to check in
3. **Mood Analytics**: Visualize mood patterns
4. **Community Features**: Like/react to posts
5. **Offline Support**: Cache posts for offline viewing

## Contributing

This is a personal wellness app. Please respect user privacy and mental health when contributing.

## License

MIT License - see LICENSE file for details.
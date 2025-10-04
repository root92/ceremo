# Ceremo Mobile App

A Flutter mobile application for ceremony and project management, integrated with the existing Haaju backend API.

## Features

- 🔐 **Authentication Flow** - Login and signup with beautiful UI
- 🏢 **Organization Management** - Multi-tenant support
- 📊 **Project Management** - Create and manage ceremony projects
- 📱 **Modern UI** - Material 3 design with orange theme
- 🔌 **API Integration** - GraphQL client with authentication

## Tech Stack

- **Flutter** - Cross-platform mobile development
- **GraphQL** - API communication with backend
- **Provider** - State management
- **SharedPreferences** - Local storage
- **Material 3** - Modern UI design

## Project Structure

```
lib/
├── services/           # API services
│   ├── api_config.dart
│   ├── graphql_client.dart
│   ├── auth_service.dart
│   ├── organization_service.dart
│   └── project_service.dart
├── providers/          # State management
│   └── auth_provider.dart
├── screens/            # UI screens
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   └── dashboard_screen.dart
├── widgets/            # Reusable widgets
│   ├── loading_screen.dart
│   └── error_screen.dart
└── main.dart           # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.29.2 or later)
- iOS Simulator or Android Emulator
- Backend API running on localhost:8001

### Installation

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

### Backend Integration

The app is configured to connect to the Haaju backend API:

- **GraphQL Endpoint:** `http://localhost:8001/graphql/`
- **Authentication:** JWT token-based
- **Organization Support:** Multi-tenant architecture

## API Services

### Authentication Service
- User login/logout
- User registration
- Token management
- User profile management

### Organization Service
- List user organizations
- Create new organizations
- Manage organization members

### Project Service
- List user projects
- Create new projects
- Update project details
- View project analytics

## Development

### Running on iOS Simulator
```bash
flutter run -d "iPhone 16 Plus"
```

### Running on Android Emulator
```bash
flutter run -d "emulator-5554"
```

### Hot Reload
The app supports hot reload for fast development:
```bash
# Press 'r' in the terminal or use your IDE
```

## Features in Development

- [ ] Project creation and management
- [ ] Organization switching
- [ ] Real-time notifications
- [ ] Offline support
- [ ] Push notifications

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is part of the Haaju project ecosystem.
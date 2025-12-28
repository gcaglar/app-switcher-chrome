# App Switcher Chrome

A Flutter web app featuring a chrome/shell with an app switcher, phone-like viewport, and three starter apps.

## Features

- **App Switcher**: Pill-style tabs to switch between apps
- **Phone Viewport**: Simulates mobile device screens with preset sizes
  - iPhone SE (375 x 667)
  - iPhone 14 (390 x 844)
  - Pixel 7 (412 x 915)
- **Starter Apps**:
  - **To-Do**: Add, complete, and swipe-to-delete tasks
  - **Tic-Tac-Toe**: Classic game with win detection
  - **Snake**: Arrow keys + touch controls

## Prerequisites

- macOS or Linux
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0+)
- Google Chrome (for web development)

## Quick Start

### Option 1: Automated Installation (macOS)

Run the install script to automatically install all dependencies:

```bash
# Make the script executable
chmod +x scripts/install.sh

# Run the install script
./scripts/install.sh
```

### Option 2: Manual Installation

1. **Install Flutter**: Follow the [official guide](https://docs.flutter.dev/get-started/install)

2. **Enable web support**:
   ```bash
   flutter config --enable-web
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

## Running Locally

### Run in Chrome (Development)

```bash
flutter run -d chrome
```

**Hot reload controls:**
- `r` - Hot reload (apply changes without restarting)
- `R` - Hot restart (full restart)
- `q` - Quit

### Build for Production

```bash
flutter build web --release
```

The build output will be in `build/web/`. You can serve it with any static file server:

```bash
cd build/web
python3 -m http.server 8000
```

Then open http://localhost:8000 in your browser.

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── app_chrome.dart           # Main chrome shell
├── models/
│   └── app_state.dart        # State management
├── widgets/
│   ├── app_switcher.dart     # Pill tabs
│   ├── viewport_container.dart
│   └── viewport_settings.dart
└── apps/
    ├── todo_app.dart
    ├── tic_tac_toe.dart
    └── snake_game.dart
```

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Target**: Web (Chrome)

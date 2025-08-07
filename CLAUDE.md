# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Japanese cafe ordering app built with Flutter, implementing Clean Architecture with Riverpod for state management. The app allows customers to browse a menu, add items to cart, and place orders through a mobile-friendly interface.

**Language**: Japanese (UI text, comments, and documentation)

## Common Development Commands

### Flutter Commands (run from `/workspace/flutter_app/`)
- `flutter pub get` - Install dependencies
- `flutter run` - Run the app in debug mode
- `flutter test` - Run all unit tests
- `flutter analyze` - Run static analysis/linting
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires macOS)
- `flutter pub deps` - Show dependency tree
- `flutter clean` - Clean build artifacts

### Testing Commands
- `flutter test` - Run all unit tests
- `flutter test test/specific_test.dart` - Run specific test file
- `npx cypress run` - Run Cypress E2E tests (from flutter_app directory)
- `npx cypress open` - Open Cypress test runner

### Code Generation (if needed)
- `flutter packages pub run build_runner build` - Generate code (mockito, etc.)

## Architecture Overview

### Clean Architecture Structure
```
lib/
├── data/           # Data layer (repositories, data sources, mock data)
├── domain/         # Business logic (entities, repositories interfaces, use cases)
├── models/         # Data models (Cart, CartItem, MenuItem)
├── providers/      # Riverpod state providers
└── widgets/        # UI components
```

### Key Architecture Components
- **State Management**: Flutter Riverpod with StateNotifier pattern
- **Data Layer**: Mock data sources (no real backend, mock files simulate API)
- **Repository Pattern**: Abstraction between data sources and business logic
- **Use Cases**: Business logic encapsulation (e.g., PlaceOrderUseCase)

### Important Files
- `lib/main.dart` - App entry point with theme configuration
- `lib/data/menu_data.dart` - Mock menu data
- `lib/providers/cart_provider.dart` - Cart state management
- `lib/widgets/menu_card.dart` - Menu item display component
- `lib/widgets/cart_view.dart` - Shopping cart UI component

### Key Features
- **Responsive Layout**: Grid layout adapts to screen size
- **Category Filtering**: Menu items filterable by category (コーヒー, お茶, パスタ, サンドイッチ)
- **Cart Management**: Add/remove items, calculate totals
- **Order Processing**: Mock order placement with cart clearing
- **Japanese UI**: All interface text in Japanese

### Development Notes
- Uses brown/beige color theme for cafe aesthetic
- Menu items stored as assets in `assets/menus/`
- Test coverage includes unit tests and Cypress E2E tests
- Mock data approach eliminates need for real backend during development

### Dependencies
- **flutter_riverpod**: State management
- **http**: Network requests (for future real backend)
- **mockito**: Mock generation for testing
- **cypress**: E2E testing framework
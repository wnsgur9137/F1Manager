# F1Manager Project Guidelines

## Project Overview
F1Manager is an iOS application built on modularized Clean Architecture principles, providing comprehensive Formula 1 race and driver information with an official F1 app-inspired design.

## Architecture Structure
- **Clean Architecture**: Separation of Domain, Data, and Presentation layers
- **Tuist**: Modularized project management
- **DI Container**: Dependency injection pattern
- **Coordinator Pattern**: Navigation flow management
- **ReactorKit**: Reactive programming (RxSwift-based)

## Directory Structure
```
Projects/
├── Application/         # Main app target
├── Base/               # Common base modules
│   ├── BaseData/       # Common data layer
│   ├── BaseDomain/     # Common domain layer
│   └── BasePresentation/ # Common presentation layer
├── Feature/            # Feature-specific modules
│   ├── Features/       # TabBar management
│   ├── Home/          # Home feature (Drivers & Races)
│   ├── Onboarding/    # Onboarding feature
│   └── Splash/        # Splash feature
├── Infrastructure/     # Infrastructure layer
│   └── NetworkInfra/  # Network management
├── InjectionManager/   # DI container
└── LibraryManager/     # External library management
```

## Feature Implementation

### Home Module
The Home module contains comprehensive race and driver functionality:

#### Driver Features
- **Driver List**: Complete driver standings and information
- **Driver Detail**: Detailed driver statistics and information
- **Driver Cards**: Compact driver representation with team colors and positions

#### Race Features
- **Race Calendar**: Complete 2025 F1 season race list with filtering
- **Race Detail**: Comprehensive race information with weekend schedule
- **Race Cards**: Upcoming race preview with dates and locations
- **Smart Filtering**: Automatic filtering to show upcoming races first

#### UI Components
- **F1-Inspired Design**: Official F1 app styling with red branding
- **Gradient Backgrounds**: Dynamic color schemes matching F1 aesthetics
- **Shadow Effects**: Premium card-based layout design
- **Status Indicators**: Color-coded race status (upcoming/today/completed)

## Coding Conventions

### Swift Style Guide
- **Naming Conventions**: 
  - Classes/Structs: PascalCase (e.g., `UserRepository`)
  - Variables/Functions: camelCase (e.g., `getUserData`)
  - Constants: camelCase (e.g., `defaultTimeout`)
  - Enums: PascalCase, cases are camelCase

### File Structure
- Separate Data, Domain, and Presentation layers for each feature
- Each layer is managed as a separate target
- Project generation and management through Tuist

### UI Layout Conventions
- **Individual addSubview calls**: Prefer explicit individual calls over forEach loops
  ```swift
  // ✅ Preferred
  containerView.addSubview(titleLabel)
  containerView.addSubview(subtitleLabel)
  
  // ❌ Avoid
  [titleLabel, subtitleLabel].forEach { containerView.addSubview($0) }
  ```
- **F1 Design System**: Consistent use of F1 branding colors, fonts, and styling
- **Localization**: Use English locale for date formatting (`en_US`)

### Dependency Management
- Dependency injection through DI Container
- Protocol-based interface definitions
- Mock objects for testing support

### Networking
- Use NetworkInfra module
- Protocol-based networking (TargetType)
- Error handling with NetworkError
- Logging through Logger

## Data Flow Architecture

### Race & Driver Data Flow
```
API Layer (NetworkInfra)
    ↓
Repository Layer (BaseData)
    ↓
UseCase Layer (BaseDomain)
    ↓
Reactor Layer (Presentation)
    ↓
ViewController/View Layer
```

### Navigation Flow
```
Home → Race List → Race Detail
Home → Driver List → Driver Detail
```

## Code Review Guidelines

### Checkpoint Items
1. **Architecture Compliance**: Adherence to Clean Architecture principles
2. **Module Separation**: Proper layer separation and dependency direction
3. **Naming Conventions**: Compliance with Swift naming guidelines
4. **Test Code**: Testing of business logic
5. **Memory Management**: Prevention of retain cycles (proper use of weak, unowned)
6. **UI Consistency**: F1 design system compliance

### Prohibited Practices
- Direct UI updates (outside main thread)
- Hard-coded strings (use Localizable.strings)
- Strong reference cycles causing memory leaks
- Inappropriate dependencies between layers
- forEach loops in addSubview operations

## Testing Guidelines
- Business logic testing at UseCase level
- Data layer testing through Repository pattern
- Unit testing with Mock objects
- UI testing only for critical user flows

## Library Usage Policy
- Dependency management through SPM (Swift Package Manager)
- Library modularization through Tuist
- Maintain latest versions and security vulnerability checks

## Performance Considerations
- Image loading optimization
- Network request caching
- Memory usage monitoring
- Battery efficiency considerations

## Build Commands
```bash
# Generate project with Tuist
tuist generate

# Build for iOS Simulator
xcodebuild -workspace F1Manager.xcworkspace -scheme F1Manager -destination 'platform=iOS Simulator,id=<DEVICE_ID>' build
```
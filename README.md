# Muzz Chat Exercise - Implementation

## Overview
This is a SwiftUI-based chat interface implementation for the Muzz iOS exercise, featuring message persistence, grouping logic, and iMessage-style animations.

## Implementation Decisions

### Architecture
- **MVVM Pattern**: Clean separation between View, ViewModel, and Model layers
- **SwiftUI**: Chosen for modern declarative UI and built-in animation support
- **Combine**: Used for reactive data binding between ViewModel and Views
- **Core Data**: Selected for message persistence (could easily swap for SwiftData)

### Key Features Implemented

#### 1. Message Bubbles
- Left-aligned for received messages (light gray background)
- Right-aligned for sent messages (pink/red background matching Muzz branding)
- Rounded corners (18pt radius) with appropriate padding
- Dynamic text sizing with emoji support
- Read receipts (checkmark) on sent messages

#### 2. Message Grouping Logic
- **Timestamp Sections**: Messages separated by >1 hour show date/time header
- **Visual Grouping**: Messages from same sender within 20 seconds have reduced spacing
- Implemented in `Message` model extensions for reusability

#### 3. Inverted Scrolling
- ScrollView with messages ordered oldest-to-newest (top-to-bottom)
- Auto-scroll to bottom when new messages arrive
- Smooth animations using `ScrollViewProxy`

#### 4. Send Animation
- iMessage-style spring animation when sending messages
- Scale and opacity transitions
- Animates from input bar to message list position

#### 5. Dynamic Input Bar
- TextEditor that grows with content (36px to 120px max)
- Placeholder text when empty
- Send button disabled for empty messages
- Clears after sending

#### 6. Message Persistence
- Core Data with `MessageEntity`
- Automatic save on message send
- Fetch on app launch
- In-memory store for tests and previews

### Code Structure

```
MuzzChat/
├── MuzzChatApp.swift           # App entry point
├── Models/
│   └── Message.swift           # Message model with grouping logic
├── ViewModels/
│   └── ChatViewModel.swift     # MVVM ViewModel with Combine
├── Views/
│   ├── ChatView.swift          # Main chat interface
│   ├── MessageBubbleView.swift # Individual message bubble
│   ├── TimestampView.swift     # Timestamp section headers
│   └── InputBarView.swift      # Dynamic input bar
├── Persistence/
│   ├── PersistenceController.swift
│   └── MuzzChat.xcdatamodeld   # Core Data model
└── Tests/
    ├── ChatViewModelTests.swift
    └── MessageTests.swift
```

### Technical Highlights

1. **Separation of Concerns**: Business logic in ViewModel, UI in Views, data in Models
2. **Testability**: Unit tests for message grouping, timestamp logic, and persistence
3. **Reusability**: Message grouping logic in model extensions, reusable view components
4. **Performance**: LazyVStack for efficient rendering of large message lists
5. **Type Safety**: Strong typing throughout, no force unwrapping

## Limitations & Known Issues

1. **No Network Layer**: Messages are local-only (would add WebSocket/REST API in production)
2. **Single Conversation**: Hardcoded to "Alisha" (would add conversation list in production)
3. **No Image Support**: Text-only messages (would add media picker and display)
4. **Basic Animation**: Send animation is simplified (could enhance with more sophisticated transitions)
5. **No Read Receipts**: Missing checkmarks/read indicators
6. **No Typing Indicators**: Would add in production
7. **Limited Error Handling**: Core Data errors logged but not shown to user
8. **No Pagination**: Loads all messages at once (would add pagination for large histories)

## What I Would Add With More Time

### High Priority
- [ ] Comprehensive unit test coverage (currently ~40%)
- [ ] UI tests with XCTest or Appium
- [ ] Network layer with mock API
- [ ] Message editing and deletion
- [ ] Image/media message support
- [ ] Push notifications

### Medium Priority
- [ ] Conversation list view
- [ ] User profile view
- [ ] Search functionality
- [ ] Message reactions (emoji)
- [ ] Typing indicators
- [ ] Read receipts with checkmarks

### Low Priority
- [ ] Dark mode optimization
- [ ] Accessibility improvements (VoiceOver, Dynamic Type)
- [ ] Localization support
- [ ] Message forwarding
- [ ] Voice messages
- [ ] Video calls integration

## Time Spent
Approximately **3-4 hours** including:
- Architecture planning (30 min)
- Core implementation (2 hours)
- Testing and refinement (1 hour)
- Documentation (30 min)

## Running the Project

### Requirements
- Xcode 15.0+
- iOS 17.0+ (can be adjusted in project settings)
- macOS Sonoma or later

### Steps
1. Open `MuzzChat.xcodeproj` in Xcode
2. Select a simulator or device
3. Press Cmd+R to build and run
4. Type messages in the input bar and tap send

### Running Tests
1. Press Cmd+U to run all tests
2. Or use Test Navigator (Cmd+6) to run individual tests

## Design Decisions Explained

### Why SwiftUI over UIKit?
- Modern, declarative syntax reduces boilerplate
- Built-in animation support simplifies iMessage-style transitions
- Better state management with @Published and @State
- Easier to maintain and test

### Why Core Data over Realm?
- Native Apple framework, no third-party dependencies
- Better integration with SwiftUI via @FetchRequest
- Easier to set up for this scope
- Note: Could easily swap for SwiftData in iOS 17+

### Why MVVM?
- Clear separation of concerns
- Testable business logic
- Aligns with SwiftUI's reactive patterns
- Industry standard for iOS apps

### Message Grouping Algorithm
Implemented as model extensions for:
- **Reusability**: Can be used in multiple views
- **Testability**: Easy to unit test in isolation
- **Clarity**: Logic lives with the data it operates on

## Assumptions Made

1. **Single User**: App represents one user's perspective (sent vs received)
2. **Local Only**: No backend integration required for exercise
3. **English Only**: No localization needed
4. **Portrait Only**: No landscape orientation handling
5. **Modern iOS**: Targeting iOS 17+ for latest APIs
6. **Sample Data**: "Alisha" is hardcoded as conversation partner

## Code Quality Notes

- **No Force Unwrapping**: Safe optional handling throughout
- **Consistent Naming**: Following Swift API Design Guidelines
- **Comments**: Added where logic is non-obvious
- **SwiftLint Ready**: Code follows standard Swift style
- **No Warnings**: Clean build with zero warnings

## Contact
For questions about implementation decisions or to discuss the code, please reach out!

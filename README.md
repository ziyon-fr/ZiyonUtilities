# ZiyonUtilities

**ZiyonUtilities** is an internal private Swift package that provides a collection of reusable UI components, animations, and extensions for `String`, `Bool`, `View`, and more. Designed to simplify and accelerate the development process, it ensures a cleaner, more efficient SwiftUI coding experience.

---

## ✨ Features

- **UI Components**: Reusable SwiftUI views for consistent UI design.
- **Animations**: Predefined smooth and efficient animations.
- **Extensions**:
  - `String` extensions for easy manipulation.
  - `Bool` utilities for logical enhancements.
  - `View` modifiers to streamline UI construction.
- **Utility Functions**: Common helper methods to reduce boilerplate code.

---

## 📦 Installation

Since **ZiyonUtilities** is a private package, add it manually to your project using Swift Package Manager (SPM).

### Using Xcode

1. Open your project in Xcode.
2. Navigate to **File → Add Packages...**
3. Enter the repository URL:
4. Choose the appropriate branch or tag.
5. Click **Add Package**.

### Using `Package.swift`

If adding manually, update your `Package.swift`:

```swift
dependencies: [
 .package(url: "https://github.com/fr.ziyon/ZiyonUtilities.git", .branch("main"))
],
targets: [
 .target(
     name: "YourTarget",
     dependencies: ["ZiyonUtilities"]
 )
]
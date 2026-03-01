# SelfConcept

An iOS app that visualizes how close you are to your ideal self.

## Concept

SelfConcept helps you track the gap between your actual behavior and your ideal self-image. For each identity statement (e.g., "I'm fit"), you log whether you embodied that identity each day. The app then shows you this visually:

- **Top half (saturated green)**: Your ideal self
- **Bottom half (pastel/less saturated green)**: Your actual self based on your logging

The color saturation increases as you get closer to your ideal.

## Features

- **Setup**: Define your identity statements and the action that represents each one
- **Write**: Log daily whether you completed each action. Backfill past days as needed.
- **Read**: View your progress with adjustable time windows (7, 14, or 30 days)
- **Detail View**: See the split-screen visualization for a single identity

## Tech Stack

- SwiftUI (iOS 17+)
- Swift Observation framework
- JSON persistence to local Documents folder

## Getting Started

1. Open the project in Xcode
2. Build and run on iOS simulator or device
3. Go to **Setup** to add your first identity
4. Use **Write** to log your daily actions
5. Check **Read** to visualize your progress

## Project Structure

```
SelfConcept/
├── Models/
│   └── DataModels.swift
├── ViewModels/
│   └── AppViewModel.swift
├── Managers/
│   └── PersistenceManager.swift
├── Views/
│   ├── ContentView.swift
│   ├── SetupView.swift
│   ├── WriteView.swift
│   ├── ReadView.swift
│   └── DetailView.swift
└── SelfConceptApp.swift
```

## Future Ideas

- Description/elaboration for actions
- Notes on daily logs with pattern recognition
- Dark mode support
- Export/backup functionality
- Time-based trends and analytics

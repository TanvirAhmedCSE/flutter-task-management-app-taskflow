<div align="center">

<br/>

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/GetX-8B5CF6?style=for-the-badge&logo=getx&logoColor=white" />
<img src="https://img.shields.io/badge/Hive-FFB300?style=for-the-badge&logo=hive&logoColor=white" />

<br/><br/>

# 📋 TaskFlow - A Flutter Task Management App

### A clean, minimal task manager built with Flutter

*Filter · Sort · Star · Reorder — all offline, all fast.*

</div>

---

## ✨ Features

- **Task Management** — Add, edit, delete tasks with title, description, priority, category, and due date
- **6 Filter Tabs** — All · Active · Done · Starred · Higher Priority · Closer Due Date
- **Category Chips** — Filter by Personal, Work, Shopping, Health, Study, Other
- **Drag & Reorder** — Manually reorder tasks in the All view (drag handle + up/down arrows)
- **Swipe to Delete** — Swipe left on any card to reveal the delete button
- **Star Important Tasks** — Quick star/unstar from the task card
- **Search** — Live search across task titles and descriptions
- **Progress Bar** — Animated progress indicator showing overall completion rate
- **Stats Sheet** — Overview of Total, Done, Active, Starred, Overdue, and Rate — plus per-category breakdown
- **Overdue Detection** — Tasks past their due date are automatically flagged red
- **Greeting** — Time-aware greeting (Good morning / afternoon / evening / night)
- **Offline First** — All data stored locally with Hive, no internet required
- **Haptic Feedback** — Tactile feedback on add, delete, complete, and reorder

---

## 📱 Screenshots

<div align="center">

| | | | |
|:---:|:---:|:---:|:---:|
| <img src="app screenshots/Screenshot_20260522_211022_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> | <img src="app screenshots/Screenshot_20260522_211230_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> | <img src="app screenshots/Screenshot_20260522_211232_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> | <img src="app screenshots/Screenshot_20260522_211237_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> |
| **Home (All)** | **Active Filter** | **Done Filter** | **Starred Filter** |
| <img src="app screenshots/Screenshot_20260522_211246_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> | <img src="app screenshots/Screenshot_20260522_211251_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> | <img src="app screenshots/Screenshot_20260522_211415_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> | <img src="app screenshots/Screenshot_20260522_211430_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> |
| **Higher Priority** | **Closer Due Date** | **Work + Priority** | **Study + Priority** |
| <img src="app screenshots/Screenshot_20260522_211541_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> | <img src="app screenshots/Screenshot_20260522_211637_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> | <img src="app screenshots/Screenshot_20260522_211640_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> | <img src="app screenshots/Screenshot_20260522_211222_com_example_to_do_app_flutter_MainActivity.jpg" width="160"/> |
| **New Task Form** | **Task List** | **Swipe Delete** | **Search** |

</div>

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart |
| State Management | GetX |
| Local Storage | Hive + Hive Flutter |
| Date Formatting | intl |

---

## 📁 Project Structure

```
lib/
├── adapters/
│   ├── priority_adapter.dart       # Hive TypeAdapter for Priority enum
│   ├── task_adapter.dart           # Hive TypeAdapter for Task model
│   └── task_category_adapter.dart  # Hive TypeAdapter for TaskCategory enum
├── controllers/
│   └── task_controller.dart        # GetX controller — all state & business logic
├── models/
│   ├── enums.dart                  # Priority & TaskCategory enums
│   └── task.dart                   # Task HiveObject model
├── sheets/
│   ├── stats_sheet.dart            # Bottom sheet — stats overview
│   └── task_form_sheet.dart        # Bottom sheet — add/edit task
├── theme/
│   └── app_colors.dart             # Centralized color palette
├── views/
│   └── home_view/
│       ├── home_view.dart          # Main screen
│       └── widgets/
│           └── task_card.dart      # Individual task card widget
└── main.dart                       # App entry point + Hive init
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.x`
- Dart SDK `^3.11.3`

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/TanvirAhmedCSE/flutter-task-management-app-taskflow.git
cd flutter-task-management-app-taskflow

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.3          # State management, navigation, DI
  hive_flutter: ^1.1.0 # Local NoSQL storage
  intl: ^0.20.2        # Date formatting
```

---

## 🎨 Design Decisions

- **Pure dark-warm palette** — Off-white `#F7F5F2` background with `#4F46A3` accent gives a calm, focused feel
- **Priority stripe** — Left-edge colored stripe on each card gives instant priority feedback without cluttering the layout
- **Drag only on All view** — Manual reordering is intentionally locked to the unfiltered All view to keep `sortOrder` consistent
- **No internet required** — Everything lives in a local Hive box; the app works fully offline
- **Haptic feedback** — Add (medium), delete (heavy), toggle complete (selection click) for tactile confirmation

---

## 📄 License

```
MIT License

Copyright (c) 2026 TanvirAhmedCSE

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
```

---

<div align="center">

Made with ❤️ and Flutter by **[TanvirAhmedCSE](https://github.com/TanvirAhmedCSE)**

*If you like this project, give it a ⭐ on GitHub!*

</div>
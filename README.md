# 🎓 College Club Management

> **B.Tech Flutter Laboratory Project**
> A mobile application built with Flutter & Dart to manage college clubs, events, and student memberships.

---

## 👨‍💻 Student Details

| Field | Details |
|---|---|
| **Name** | Mahesh |
| **Roll Number** | 24XZ1A1219 |
| **Department** | Information Technology (IT) |
| **Year** | B.Tech – 3rd Year |

---

## 📱 About the App

**College Club Management** is a Flutter-based mobile application that allows students to:
- Browse and join college clubs
- View and register for upcoming events
- Manage their club memberships
- Get event confirmation passes with their roll number

---

## 🏛️ Clubs in the App

| Club | Category |
|---|---|
| 💻 Coding Club | Technical |
| 🎭 Cultural Club | Cultural |
| ⚽ Sports Club | Sports |
| 📸 Photography Club | Photography |
| 🎵 Music Club | Music |

---

## ✨ Features

- 🔐 **Login Screen** — Roll Number or Email-based login with validation
- 🏠 **Dashboard** — Overview with stats (clubs, events, registrations)
- 👥 **Clubs Screen** — Browse, search, and filter clubs by category
- 📅 **Events Screen** — View upcoming events with date/time/venue details
- ⭐ **My Clubs** — Manage joined clubs
- 📋 **Event Registration Pass** — Confirmation ticket with student roll number
- 💾 **Local Persistence** — Session and data stored via SharedPreferences
- 🔔 **Toast Notifications** — Feedback for join/leave/register actions

---

## 🛠️ Tech Stack

| Technology | Details |
|---|---|
| **Framework** | Flutter 3.x |
| **Language** | Dart |
| **State Management** | StatefulWidget + setState |
| **Local Storage** | SharedPreferences |
| **Navigation** | Named Routes + PageRouteBuilder |
| **UI Components** | Material Design Widgets |

---

## 📚 Flutter Concepts Demonstrated

- ✅ **Widgets** — Stateless & Stateful widgets
- ✅ **Navigation & Routing** — Multi-screen navigation with BottomNavigationBar
- ✅ **Forms & Validation** — Login form with input validation
- ✅ **State Handling** — Dynamic counters, reactive UI updates
- ✅ **Data Modeling** — Dart classes for Club, Event, User
- ✅ **Local Persistence** — SharedPreferences for session management
- ✅ **Lists & Filtering** — Search and category-based filtering
- ✅ **Animations** — Splash screen and page transitions

---

## 📁 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── club.dart
│   ├── event.dart
│   └── user.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── dashboard_screen.dart
│   ├── clubs_screen.dart
│   ├── club_details_screen.dart
│   ├── events_screen.dart
│   ├── event_details_screen.dart
│   ├── my_clubs_screen.dart
│   └── about_screen.dart
├── services/
│   ├── club_service.dart
│   ├── event_service.dart
│   └── storage_service.dart
├── utils/
│   ├── constants.dart
│   ├── app_theme.dart
│   └── validators.dart
└── widgets/
    ├── club_card.dart
    ├── event_card.dart
    └── stat_card.dart
```

---

## 🚀 How to Run

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

**Login Credentials:**
- Roll Number: `24XZ1A1219`
- Password: `password123`

---

## 📝 License

This project is developed for **B.Tech Flutter Laboratory** academic purposes.

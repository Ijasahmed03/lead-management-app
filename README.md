 Mini Lead Management App
A Flutter project for Sankar Group Internship Assignment
This is a simple, clean, and fully functional Lead Management App built using Flutter, Riverpod, and SQLite. The project demonstrates practical skills in UI design, local storage, CRUD operations, state management, and mobile app architecture.

🚀 Features
Core Features:
  Add new leads
  View all leads
  Edit lead information
  Update lead status (New → Contacted → Converted / Lost)
  Delete leads
  Local storage using SQLite (sqflite)
  State management using Riverpod StateNotifier
🎨 UI/UX Enhancements
  Light & Dark theme toggle
  Modern card-based UI
  Status badges with animations
  Search leads by name
  Swipe-to-refresh
  Animated empty state
  Slight FAB animation on tap
  
🗂️ Project Structure
  lib/
 ├─ models/
 │    └─ lead.dart
 ├─ services/
 │    └─ db_service.dart
 ├─ providers/
 │    ├─ db_provider.dart
 │    ├─ lead_list_provider.dart
 │    └─ theme_provider.dart
 ├─ screens/
 │    ├─ lead_list_screen.dart
 │    ├─ add_lead_screen.dart
 │    └─ lead_detail_screen.dart
 ├─ widgets/
 │    └─ lead_tile.dart
 └─ main.dart

 🛠️ Technologies Used
Technology	Purpose
Flutter	UI framework
Riverpod	State management
SQLite (sqflite)	Persistent local storage
Material 3	Modern UI styling

📦 Packages Used
flutter_riverpod: ^2.3.6
sqflite: ^2.2.8
path: ^1.8.4
cupertino_icons: ^1.0.8

▶️ How to Run
1. Clone the repository
   git clone https://github.com/<your-username>/leadapp.git
cd leadapp
2.Install Dependencies
 flutter pub get
3.Run the app
 flutter run
4.Build APK
flutter build apk --debug
APK output location:build/app/outputs/flutter-apk/app-debug.apk

What This Project Demonstrates:
 Clean and organized architecture
 State management using Riverpod
 Offline-first local storage
 Modern UI with Material 3
 Clear understanding of CRUD apps
 Ability to follow real-world requirements
 
Author
Ijas Ahhammed T

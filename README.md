# 📞 Flutter Video Calling App

A **Flutter-based Video Calling App** built using the **Agora SDK** for real-time video and audio communication.  
The app includes user authentication (signup/login) and a user list screen where users can either **host** a video call or **join** as an **audience**.

---

## 🚀 Features

- 🔐 **User Authentication** (Sign Up & Login using Firestore)
- 👥 **User List Screen** showing all active users
- 🎥 **Host or Join Video Calls** using Agora
- 🔄 **Real-time updates** for user call status
- 🎙️ **Camera & Mic toggle**, **screen share**, and **switch camera**
- 🧱 Built with **BLoC** state management for clean architecture
- 📱 Runs on **Android**, **iOS**, and **Web**

---

## 🧭 App Working (Flow)

1. **Sign Up**
   - New users can create an account using their name, email, and password.
   - User data is stored in **Firestore**.

2. **Login**
   - After successful login, users are redirected to the **User List** screen.

3. **User List Screen**
   - Displays all registered users.
   - If a user is currently hosting a call, it shows a **“Join as Audience”** option.
   - Otherwise, users can create their own video call session.

4. **Join or Host a Call**
   - Tap on another user’s hosted call → join as **Audience**.
   - Tap the **Floating Action Button (FAB)** ➕ to **create and host a new call**.

5. **Call Screen**
   - Once in a call:
     - Toggle **camera** or **microphone**
     - **Switch camera** between front/rear
     - **End call** to return to the user list

---

## ⚙️ SDK Setup & Configuration

### 1. Create an Agora Project
1. Visit [Agora Console](https://console.agora.io/).
2. Create a **new project** (Testing Mode or Production Mode).
3. Copy your **App ID** and **Temporary Token**.

### 2. Add Agora Credentials
In your Flutter app (e.g. `lib/core/utils/constants/app_constants.dart`):
```dart
const String agoraAppId = "YOUR_AGORA_APP_ID";
const String tempToken = "YOUR_TEMP_TOKEN";
const String channelName = "test_channel";
```

## Limitations
🧠 Assumptions & Limitations
Assumptions

User authentication handled via Firebase Authentication and Firestore.

Call channels created and joined using Agora SDK.

All users have unique IDs to avoid channel conflicts.

Internet connection is stable for real-time communication.

Limitations

Supports 1-to-1 calling only (group calling can be added later).

Temporary Agora token must be manually refreshed every 24 hours.

No backend for dynamic token generation yet.

UI currently optimized for mobile portrait view.

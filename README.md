# Flutter Firebase Chat App 💬

A real-time one-to-one chat application built using **Flutter** and **Firebase**.  
This project demonstrates clean chat architecture, authentication, presence tracking, and real-time messaging.

---

## 🚀 Features

- Email & Password Authentication (Firebase Auth)
- Real-time one-to-one chat (Cloud Firestore)
- UID-based chat room creation (collision-free)
- Online / Offline user presence
- Message bubbles with sender/receiver alignment
- Splash screen and authentication flow
- Clean, scalable Flutter project structure

---

## 🛠 Tech Stack

- **Flutter** (Frontend)
- **Firebase Authentication**
- **Cloud Firestore**
- **Dart**

---

## 📂 Project Structure (Simplified)

```
lib/
 ├── screens/
 │    ├── splashscreen.dart
 │    ├── loginscreen.dart
 │    ├── registrationscreen.dart
 │    ├── homescreen.dart
 │    └── chatroom.dart
 ├── uihelper.dart
 ├── methods.dart
 └── main.dart
```

---

## ⚙️ Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/flutter-firebase-chat-app.git
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Create a Firebase project
   - Enable **Email/Password Authentication**
   - Create a **Cloud Firestore** database
   - Run:
     ```bash
     flutterfire configure
     ```

4. Run the app:
   ```bash
   flutter run
   ```

---

## 🔐 Firestore Data Model

### users collection
```json
{
  "uid": "firebase-auth-uid",
  "name": "User Name",
  "email": "user@email.com",
  "status": "online | offline",
  "lastSeen": "timestamp"
}
```

### chatroom/{chatRoomId}/chats
```json
{
  "sendBy": "sender-uid",
  "message": "Hello!",
  "time": "timestamp"
}
```

---

## 🧠 Key Learnings

- Why UID-based chat rooms are critical
- Handling real-time streams with StreamBuilder
- Managing app lifecycle for presence detection
- Avoiding common Firebase + Flutter pitfalls

---

## 🔮 Future Improvements

- Last seen timestamps UI
- Message read receipts
- Media & image sharing
- Push notifications (FCM)
- Group chats
- Dark / Light theme toggle

---

## 📌 Note

This project was built step-by-step to understand **real-world Flutter + Firebase chat architecture**, not just to follow a tutorial.

---

### 👨‍💻 Built with consistency, patience, and clean code.

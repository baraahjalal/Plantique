# Plantique
### *Smart Plant Care & Monitoring Assistant*

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-%23039BE5.svg?style=flat&logo=firebase)](https://firebase.google.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

***Plantique*** is a modern, cross-platform mobile application designed to simplify plant care through technology. Built with **Flutter** and powered by **Firebase**, it helps you organize your digital garden, monitor growth, and manage care routines in one intuitive interface.

---

## ✨ Key Highlights

*   **Clean UI**: Intuitive and modern Material Design.
*   **Real-time Sync**: Seamless cloud synchronization across devices.
*   **Secure Auth**: Robust user authentication via Firebase.
*   **Cross-Platform**: Native performance on Android, iOS, and Web.

---

## 📱 App Preview

| Welcome Screen | Dashboard | Plant Details |
|:--------------:|:---------:|:-------------:|
| <img width="381" height="801" alt="Screenshot 2026-01-01 at 5 10 42 PM" src="https://github.com/user-attachments/assets/dc291f8a-47e2-49a0-becf-53c1c0c3395d" /> | <img width="380" height="790" alt="Screenshot 2026-01-01 at 5 11 08 PM" src="https://github.com/user-attachments/assets/122b2330-d540-475d-babd-9c7933fd3249" /> | <img width="369" height="797" alt="Screenshot 2026-01-01 at 5 11 36 PM" src="https://github.com/user-attachments/assets/8b545e90-6d12-4f6d-bf5b-b6f27f21dd4e" /> |


---

## 🪴 Features

### 🔒 Authentication & Security
*   Secure sign-up and login powered by **Firebase Authentication**.

### 🌿 Personal Plant Collection
*   Create and manage a personalized digital garden.
*   Store detailed profiles (name, category, custom notes).

### ☁️ Cloud Integration
*   **Firestore:** Real-time data synchronization.
*   **Firebase Storage:** Secure hosting for your plant photography.

### ⚙️ Advanced Functionality
*   **Offline Support:** Access your garden even without internet.
*   **Search & Filter:** Quickly find specific plants in large collections.
*   **Responsive Layout:** Optimized for phones, tablets, and web browsers.

---

## 💻 Technical Stack

*   **Frontend:** Flutter (Dart)
*   **Backend (BaaS):** Firebase (Auth, Firestore, Storage)
*   **State Management:** Provider
*   **Architecture:** Clean, modular directory structure

---

## 🗂️ Project Structure

```text
lib/
├── models/     # Data models (User, Plant, Category)
├── providers/  # State management logic
├── screens/    # UI screens (Auth, Home, Details, Profile)
├── services/   # Firebase and backend services
├── widgets/    # Reusable UI components
└── utils/      # Constants, themes, and helpers
```

---

## 🛠️ Installation & Setup

Clone the repository

```bash
git clone [https://github.com/your-username/plantique.git](https://github.com/your-username/plantique.git)
cd plantique
```

Install dependencies

```bash
flutter pub get
```

Configure Firebase

1.  Create a project in the Firebase Console.
2.  Add Android/iOS apps and download the `google-services.json` or `GoogleService-Info.plist` files.
3.  Place them in the respective directories.

Run the App

```
flutter run
```

---

## 🗺️ Roadmap

*   [ ] Smart reminders for watering and fertilizing.
*   [ ] Push notifications for scheduled care.

## 📜 License

This project is licensed under the MIT License.

## ✍️ Author

Baraah, Fouz, Rawan

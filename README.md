# TripMate – AI Powered Travel Planner ✈️

TripMate is a **Flutter-based travel planning mobile application** that helps users plan trips, explore destinations, manage expenses, and get AI-powered travel assistance.

The app integrates **Firebase services, AI (Google Gemini), weather APIs, and maps** to provide a smart and seamless travel planning experience.

---

## 🚀 Features

* 🔐 **Firebase Authentication**

    * Email & Password login
    * Google Sign-In

* 🧠 **AI Travel Assistant**

    * Integrated with **Google Gemini API**
    * Users can ask travel-related questions and get intelligent suggestions

* 🌦 **Weather Information**

    * Real-time weather data for travel destinations

* 🗺 **Trip Map & Location Services**

    * Uses **OpenStreetMap & Geocoding**
    * Displays destination locations on a map

* 📅 **Trip Management**

    * Create and manage trips
    * Add itinerary details for each trip

* 💰 **Expense Tracker**

    * Track travel expenses
    * Monitor trip budget easily

* 🔎 **Destination Packages**

    * Explore travel packages for different countries

* 👤 **User Profile**

    * View and manage user information

---

## 🛠 Tech Stack

**Frontend**

* Flutter
* Dart

**Backend & Services**

* Firebase Authentication
* Cloud Firestore
* Firebase Storage

**APIs & Integrations**

* Google Gemini AI API
* Weather API
* OpenStreetMap (Geocoding & Maps)

**Tools**

* Android Studio
* Git & GitHub

---

## 📱 Screens

The app includes multiple screens such as:

* Login & Signup
* Home Dashboard
* AI Chat Assistant
* Trip Planner
* Expense Tracker
* Travel Packages
* User Profile

---

## 📂 Project Structure

```
lib
 ├── screens        # UI screens
 ├── services       # API integrations and backend logic
 ├── widgets        # Reusable UI components
 ├── theme          # App theme and styling
 └── main.dart      # App entry point
```

---

## ⚙️ Setup Instructions

1. Clone the repository

```
git clone https://github.com/your-username/tripmate-flutter.git
```

2. Navigate to project folder

```
cd tripmate-flutter
```

3. Install dependencies

```
flutter pub get
```

4. Add your API keys

Create a file:

```
lib/services/api_keys.dart
```

Example:

```
class ApiKeys {
  static const String geminiApiKey = "YOUR_GEMINI_API_KEY";
  static const String weatherApiKey = "YOUR_WEATHER_API_KEY";
}
```

5. Run the app

```
flutter run
```

---

## 🔒 Security Note

API keys are not stored in the repository.
Sensitive keys are excluded using `.gitignore`.

---

## 🎓 Project Info

This project was developed as a **college project** to demonstrate:

* Flutter mobile development
* Firebase integration
* API integration
* Clean architecture and modular code structure

---

## 👨‍💻 Author

**Tushar Lakhanpal**

GitHub: https://github.com/tusharlakhanpal285
LinkedIn: https://www.linkedin.com/in/tushar-lakhanpal-9935b3315/

---

⭐ If you like this project, feel free to give it a star!

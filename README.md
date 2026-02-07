# 🎵 Music Box

**Music Box** is a modern Flutter-based music streaming application designed with scalability, maintainability, and performance in mind.  
It allows users to stream music online, download tracks, and enjoy offline playback with full background support.

Built using **Clean Architecture**, **SOLID principles**, and **BLoC state management**, this project is a strong foundation for a production-ready music app.

---

## ✨ Features

### 🏠 Home Screen
- Popular playlists
- Latest released music
- Smooth and responsive UI

### 🗂 Categories
- Browse music by categories
- Easy navigation between different genres

### ⬇️ Downloads
- Access all downloaded tracks
- Offline playback support

---

## 🎧 Music Playback Capabilities

- Online music streaming
- Playlist playback
- Offline music playback
- Background audio playback
- Full playback controls:
  - Play / Pause
  - Next / Previous
  - Stop
  - Shuffle
  - Seek forward & backward
- Volume control
- Audio progress indicator

---

## 🧱 Architecture & Design

This project follows **Clean Architecture** to ensure separation of concerns and high testability.

### Architectural Layers:
- **Presentation Layer** (UI + BLoC)
- **Domain Layer** (Entities, Use Cases)
- **Data Layer** (Repositories, Data Sources)

### Key Principles:
- SOLID principles
- Dependency Injection using `get_it`
- Immutable states
- Testable and scalable structure

---

## 🔁 State Management

- **BLoC (Business Logic Component)**
- `flutter_bloc` for UI integration
- `equatable` for state comparison
- `dartz` for functional programming (Either, Failure handling)
- `rxdart` for stream transformations

---

## 📦 Packages Used

### 🎧 Audio & Media
- audio_session
- audio_service
- just_audio
- on_audio_query
- audiotagger
- youtube_explode_dart
- audio_video_progress_bar
- volume_controller

### ⬇️ Download & Storage
- flutter_downloader
- path_provider
- hive
- hive_flutter
- shared_preferences

### 🌐 Network & Utilities
- http
- url_launcher
- permission_handler
- cached_network_image
- fluttertoast
- logger

### 🧠 State Management & Architecture
- bloc
- flutter_bloc
- equatable
- dartz
- get_it
- rxdart

### 🎨 UI & UX
- cupertino_icons
- shimmer
- percent_indicator
- custom_sliding_segmented_control
- palette_generator
- flutter_blurhash

### 🧪 Testing & Analysis
- mockito
- analyzer

### 🔐 Permissions

The app requires the following permissions:

Storage access (for downloading and offline playback)

Internet access (for streaming music)

Background audio playback

### 🚀 Getting Started

Clone the repository:

. git clone https://github.com/your-username/music-box.git


. Install dependencies:

. flutter pub get


Run the app:

flutter run

### 🧪 Testing

Unit tests implemented using mockito

Clean separation allows easy testing of:

Use cases

Repositories

### BLoC logic

📌 Future Improvements

Search functionality

User authentication

Cloud-based playlists

Lyrics support

UI animations & theming improvements

### 🤝 Contributing

Contributions are welcome!
Feel free to open issues or submit pull requests to improve the project.

This project is licensed under the MIT License.

Music Box — Stream. Download. Enjoy. 🎶

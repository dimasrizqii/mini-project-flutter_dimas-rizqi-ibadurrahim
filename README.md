# TMDB App - Dokumentasi Aplikasi

## 📱 Deskripsi Aplikasi

**TMDB App** adalah aplikasi mobile movie database yang dibangun menggunakan Flutter. Aplikasi ini memungkinkan pengguna untuk browsing film terbaru, mencari film favorit, melihat detail lengkap film, dan menyimpan film ke dalam daftar favorit dengan autentikasi Firebase.

Aplikasi ini mengimplementasikan arsitektur **MVVM (Model-View-ViewModel)** dengan **Provider** pattern untuk state management, memastikan kode yang terstruktur, scalable, dan mudah di-maintain.

---

## ✨ Fitur Utama

### 1. **Autentikasi Pengguna**
- **Login dengan Email/Password**: Pengguna dapat masuk menggunakan email dan password
- **Register**: Pendaftaran akun baru dengan validasi form
- **Google Sign-In**: Login cepat menggunakan akun Google
- **Firebase Authentication**: Autentikasi terintegrasi dengan Firebase Auth
- **Session Persistence**: Session pengguna tersimpan secara otomatis dengan SharedPreferences
- **Reset Password**: Fitur reset password melalui email
- **Update Profile**: Update display name dan photo URL

### 2. **Discover Movies**
- **Katalog Film**: Menampilkan film-film terbaru dan trending dari TMDB API
- **Carousel Slider**: Showcase film dengan tampilan carousel yang menarik
- **View All**: Halaman khusus untuk melihat semua discover movies dengan infinite scroll
- **Loading Animation**: Shimmer loading untuk UX yang lebih baik

### 3. **Top Rated Movies**
- **Film Rating Tertinggi**: Menampilkan daftar film dengan rating tertinggi
- **Sorted by Rating**: Film diurutkan berdasarkan vote average
- **Infinite Scroll Pagination**: Load more movies saat scroll ke bawah
- **View All Page**: Halaman khusus untuk browsing top rated movies

### 4. **Detail Film**
- **Informasi Lengkap**: Menampilkan judul, poster, rating, overview, release date, dan genre
- **High Quality Images**: Poster dan backdrop dalam resolusi tinggi (original & w500)
- **Add to Favorites**: Tombol untuk menambahkan/menghapus film dari favorit
- **Share Functionality**: Berbagi film favorit ke platform lain
- **URL Launcher**: Membuka link terkait film

### 5. **Search Movies**
- **Real-time Search**: Pencarian film secara real-time saat mengetik
- **Infinite Scroll**: Load more hasil pencarian otomatis
- **Responsive UI**: Tampilan hasil pencarian yang responsive
- **Empty State**: Handling untuk kondisi tidak ada hasil pencarian

### 6. **Favorites (Daftar Favorit)**
- **Save to Favorites**: Menyimpan film favorit dengan satu tap
- **Remove from Favorites**: Menghapus film dari favorit
- **Toggle Favorite**: Add/remove otomatis dengan toggle button
- **Firestore Integration**: Data favorit tersimpan di Cloud Firestore
- **Real-time Sync**: Sinkronisasi real-time favorit antar devices
- **Favorites Page**: Halaman khusus untuk melihat semua film favorit
- **Favorite Count**: Menampilkan jumlah film favorit

### 7. **Navigasi dan UI/UX**
- **Material Design**: Menggunakan Material Design principles
- **Dark Theme**: Tampilan dark theme yang modern dan eye-friendly
- **Smooth Navigation**: Navigasi yang smooth antar halaman
- **Responsive Design**: Tampilan responsive untuk berbagai ukuran layar
- **Cached Images**: Image caching untuk performa optimal
- **Shimmer Loading**: Loading state dengan shimmer animation
- **Floating Action Button**: Quick access untuk search

### 8. **Profil Pengguna**
- **User Information**: Menampilkan nama dan email pengguna
- **Avatar**: Initial avatar berdasarkan nama pengguna
- **Logout**: Keluar dari aplikasi dengan aman
- **Profile Menu**: Dropdown menu dengan akses ke favorites dan logout

---

## 🔌 API yang Digunakan

### 1. **The Movie Database (TMDB) API** (https://api.themoviedb.org/3)

API eksternal untuk mendapatkan data film dari database terbesar di dunia. Aplikasi menggunakan beberapa endpoint:

#### Endpoints:

| Endpoint | Method | Deskripsi |
|----------|--------|-----------|
| `/discover/movie` | GET | Mengambil daftar discover movies dengan pagination |
| `/movie/top_rated` | GET | Mengambil daftar film dengan rating tertinggi |
| `/movie/{id}` | GET | Mengambil detail lengkap film berdasarkan ID |
| `/search/movie` | GET | Mencari film berdasarkan query string |

#### Query Parameters:

- `page`: Nomor halaman untuk pagination (default: 1)
- `query`: Keyword pencarian untuk search endpoint
- `api_key`: API key untuk autentikasi (required)

#### Model Data Movie:
```json
{
  "id": 550,
  "title": "Fight Club",
  "overview": "A ticking-time-bomb insomniac...",
  "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
  "backdrop_path": "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
  "release_date": "1999-10-15",
  "vote_average": 8.4,
  "vote_count": 26280,
  "genres": [
    {"id": 18, "name": "Drama"}
  ]
}
```

#### Image URLs:
- **Poster W500**: `https://image.tmdb.org/t/p/w500/{poster_path}`
- **Original Size**: `https://image.tmdb.org/t/p/original/{backdrop_path}`

---

### 2. **Firebase Services**

#### a. **Firebase Authentication**
- **Package**: `firebase_auth: ^5.3.4`
- **Fungsi**: Autentikasi pengguna dengan berbagai metode
- **Methods**:
  - `signInWithEmailAndPassword()` - Login dengan email/password
  - `createUserWithEmailAndPassword()` - Registrasi pengguna baru
  - `signInWithCredential()` - Login dengan Google
  - `signOut()` - Logout pengguna
  - `updateDisplayName()` - Update nama pengguna
  - `sendPasswordResetEmail()` - Reset password
  - `getIdToken()` - Mendapatkan token autentikasi

#### b. **Cloud Firestore**
- **Package**: `cloud_firestore: ^5.5.2`
- **Fungsi**: Menyimpan dan sinkronisasi data favorit & user profile
- **Collection Structure**:
  ```
  users/
    └── {userId}
        ├── uid: string
        ├── email: string
        ├── displayName: string
        └── photoUrl: string (optional)

  favorites/
    └── {userId}_{movieId}
        ├── userId: string
        ├── movieId: int
        ├── title: string
        ├── posterPath: string
        ├── voteAverage: double
        └── addedAt: timestamp
  ```

#### c. **Google Sign-In**
- **Package**: `google_sign_in: ^6.2.2`
- **Fungsi**: Autentikasi menggunakan akun Google
- **Flow**: Google Sign-In → Firebase Authentication → Firestore

#### d. **Firebase Core**
- **Package**: `firebase_core: ^3.8.1`
- **Fungsi**: Inisialisasi Firebase dan konfigurasi platform

---

## 🏗️ Arsitektur Aplikasi

### MVVM (Model-View-ViewModel) Architecture

Aplikasi menggunakan MVVM Architecture dengan pembagian layer yang jelas:

```
lib/
├── constant/                    # Konstanta aplikasi
│   └── tmdb_api_constant.dart   # API URLs dan API key
├── di/                          # Dependency Injection
│   └── injection.dart           # GetIt setup
├── models/                      # Data models
│   ├── repository/              # Repository layer
│   │   └── movie_repository.dart
│   ├── tmdb_responses/          # Response models dari API
│   │   ├── movie_response_model.dart
│   │   └── detail_movie_response_model.dart
│   ├── user_model.dart          # User data model
│   └── favorite_movie_model.dart
├── services/                    # Business logic services
│   ├── auth_service.dart        # Authentication service
│   └── favorites_service.dart   # Favorites management
├── ui/                          # Presentation layer
│   ├── auth/                    # Authentication pages
│   │   ├── auth_view_model.dart
│   │   ├── login_page.dart
│   │   └── register_page.dart
│   ├── home/                    # Home page
│   │   └── list_movie_page.dart
│   ├── discover/                # Discover movies
│   │   ├── discover_movie_view_model.dart
│   │   ├── discover_movie_widget.dart
│   │   └── view_all_discover_movie_page.dart
│   ├── top_rated/               # Top rated movies
│   │   ├── top_rated_movie_view_model.dart
│   │   ├── top_rated_movie_widget.dart
│   │   └── view_all_popular_movie_page.dart
│   ├── detail/                  # Movie detail
│   │   ├── detail_movie_view_model.dart
│   │   ├── detail_movie_page.dart
│   │   └── detail_item_movie_widget.dart
│   ├── search/                  # Search functionality
│   │   ├── search_movie_view_model.dart
│   │   └── search_movie_page.dart
│   └── favorites/               # Favorites page
│       ├── favorites_view_model.dart
│       └── favorites_page.dart
├── widgets/                     # Reusable widgets
│   ├── item_movie_widget.dart
│   └── shimmer_loading.dart
├── firebase_options.dart        # Firebase configuration
└── main.dart                    # Entry point
```

### State Management: Provider Pattern

Aplikasi menggunakan **Provider** untuk state management dengan ViewModel:

- **AuthViewModel**: Mengelola state autentikasi (login, register, logout)
- **DiscoverMovieViewModel**: Mengelola state discover movies
- **TopRatedMovieViewModel**: Mengelola state top rated movies
- **DetailMovieViewModel**: Mengelola state detail film
- **SearchMovieViewModel**: Mengelola state pencarian film
- **FavoritesViewModel**: Mengelola state daftar favorit

### Design Patterns

1. **Repository Pattern**: Abstraksi layer data dan API calls
2. **MVVM Pattern**: Separation of concerns (View, ViewModel, Model)
3. **Dependency Injection**: Menggunakan GetIt untuk DI container
4. **Either Pattern**: Error handling dengan Dartz (Left = Error, Right = Success)

---

## 📦 Dependencies

### Core
- `flutter` - Flutter SDK
- `cupertino_icons: ^1.0.8` - iOS style icons

### State Management
- `provider: ^6.1.5` - State management dengan Provider pattern

### Network & API
- `dio: ^5.8.0` - HTTP client untuk REST API calls

### Firebase
- `firebase_core: ^3.8.1` - Firebase initialization
- `firebase_auth: ^5.3.4` - Authentication service
- `cloud_firestore: ^5.5.2` - Cloud database
- `google_sign_in: ^6.2.2` - Google authentication

### Storage
- `shared_preferences: ^2.3.4` - Local storage untuk token persistence

### UI Components
- `carousel_slider: ^5.0.0` - Carousel slider untuk showcase
- `infinite_scroll_pagination: ^4.1.0` - Infinite scroll pagination
- `smooth_page_indicator: ^1.2.0` - Page indicators
- `sliver_tools: ^0.2.12` - Advanced sliver widgets

### Image Handling
- `cached_network_image: ^3.4.1` - Image caching
- `shimmer: ^3.0.0` - Shimmer loading animation

### Utilities
- `get_it: ^8.0.2` - Dependency injection
- `dartz: ^0.10.1` - Functional programming (Either, Option)
- `share_plus: ^10.1.3` - Share functionality
- `url_launcher: ^6.3.1` - URL launcher

---

## 🚀 Cara Menjalankan Aplikasi

### Prerequisites
- Flutter SDK (>=3.0.0 <4.0.0)
- Firebase Project dengan konfigurasi (Android/iOS)
- TMDB API Key (dari https://www.themoviedb.org/settings/api)
- Editor (VS Code / Android Studio)

### Langkah-langkah:

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd mini-project-flutter_dimas-rizqi-ibadurrahim
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup TMDB API Key**
   - Buat akun di https://www.themoviedb.org
   - Dapatkan API key dari Settings → API
   - Update API key di `lib/constant/tmdb_api_constant.dart`
   ```dart
   const String apiKey = 'YOUR_API_KEY_HERE';
   ```

4. **Setup Firebase**
   - Pastikan file `firebase_options.dart` sudah dikonfigurasi
   - Setup Firebase project di console.firebase.google.com
   - Enable Authentication:
     - Email/Password provider
     - Google Sign-In provider
   - Enable Cloud Firestore
   - Download dan setup file konfigurasi:
     - Android: `google-services.json` → `android/app/`
     - iOS: `GoogleService-Info.plist` → `ios/Runner/`

5. **Setup Google Sign-In (Optional)**
   - Configure OAuth consent screen di Google Cloud Console
   - Add SHA-1 fingerprint untuk Android
   - Setup iOS URL schemes untuk iOS

6. **Run aplikasi**
   ```bash
   flutter run
   ```

---

## 🔐 Keamanan & Autentikasi

### Autentikasi Flow:
1. User melakukan login/register
2. Firebase Authentication memvalidasi kredensial
3. ID Token disimpan di SharedPreferences
4. User data disimpan di Firestore
5. Session persisten hingga logout

### Security Features:
- Password hashing oleh Firebase Auth
- Secure token storage dengan SharedPreferences
- Firebase Security Rules untuk Firestore
- Input validation pada form login/register

### Error Handling:
- Comprehensive error messages untuk Firebase Auth errors
- User-friendly error messages dalam Bahasa Indonesia
- Network error handling pada API calls
- Loading states untuk better UX

---

## 👨‍💻 Developer Notes

### Design Patterns
- **Repository Pattern**: Abstraksi data sources dan API calls
- **MVVM Pattern**: Clean separation antara UI, business logic, dan data
- **Dependency Injection**: Centralized DI dengan GetIt
- **Either Pattern**: Type-safe error handling dengan Dartz

### Best Practices
- Input validation pada form autentikasi
- Error handling yang comprehensive pada semua API calls
- Loading states dengan shimmer animation
- Responsive layout untuk berbagai screen size
- Cached images untuk performance optimization
- Pagination dengan infinite scroll untuk better UX
- Real-time sync untuk favorites dengan Firestore streams
- Clean code dengan proper naming conventions

### Code Quality
- Separation of concerns dengan layer architecture
- Reusable widgets untuk UI consistency
- Centralized constants untuk API URLs dan keys
- Proper null safety implementation
- Async/await untuk asynchronous operations

### Future Enhancements
- [ ] Movie recommendations berdasarkan preferences
- [ ] Advanced filters (genre, year, rating)
- [ ] Watchlist feature (separate from favorites)
- [ ] Movie reviews dan ratings from users
- [ ] Offline mode dengan local database
- [ ] Push notifications untuk new releases
- [ ] Social features (share favorites, follow users)
- [ ] Multi-language support (i18n)
- [ ] Dark/Light theme toggle
- [ ] Movie trailers integration
- [ ] Cast and crew information
- [ ] Similar movies suggestions

---

## 📝 API Error Codes

### TMDB API:
- `401`: Invalid API key
- `404`: Resource not found
- `429`: Too many requests (rate limit)

### Firebase Auth:
- `weak-password`: Password terlalu lemah
- `email-already-in-use`: Email sudah terdaftar
- `user-not-found`: User tidak ditemukan
- `wrong-password`: Password salah
- `too-many-requests`: Terlalu banyak percobaan login

---

## 🙏 Credits

- **TMDB API**: Data film dari The Movie Database (https://www.themoviedb.org)
- **Firebase**: Backend services dari Google Firebase
- **Flutter**: UI framework dari Google

---

## 📄 License

This project is for educational purposes.

---

**Developer**: Dimas Rizqi Ibadurrahim
**Versi**: 1.0.0
**Last Updated**: February 2026
**Built with**: Flutter & Firebase ❤️

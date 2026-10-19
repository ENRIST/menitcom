# Panduan Setup Project Backend Node.js & Flutter (Menitcom)

Dokumen ini berisi panduan langkah demi langkah untuk melakukan konfigurasi lingkungan kerja (setup environment) serta menjalankan layanan **Backend Node.js** dan aplikasi **Flutter**.

---

## 👥 Informasi Kelompok

* **Kelompok:** Kelompok 2
* **Nama Aplikasi (Plesetan dari Detikcom):** Menitcom

### Anggota Kelompok:
* Dimas Mahardika Salimi Pasa | 24051214141
* Steven Krisna Putra | 24051214142
* Ryan Ilma Ahmada | 24051214154
* Febby Aulia Diva Irdani | 24051214157
* Yosua Arthur Panogian Siburian | 24051214172
* Yusuf Aura Ramadhany | 24051214168

---

## 📋 Prasyarat Sistem

Sebelum memulai, pastikan perangkat Anda telah terinstal software berikut:

* **Node.js** (Download & Install via [nodejs.org](https://nodejs.org/))
* **XAMPP** (Untuk layanan MySQL & Apache)
* **Flutter SDK**
* **Visual Studio Code** (Atau IDE pilihan Anda)

## 📁 Struktur Direktori

Pastikan folder backend diletakkan sejajar (di luar) folder utama aplikasi Flutter (`menitcom`):

```
├── backend-node/             <-- Folder Backend
│   ├── node_modules/
│   ├── package.json
│   ├── package-lock.json
│   └── server.js
└── menitcom/                 <-- Folder Main Project Flutter
```

## 🚀 Langkah-Langkah Setup

### 1. Persiapan Database

1. Buka aplikasi **XAMPP Control Panel**.
2. Jalankan modul **Apache** dan **MySQL** (Klik *Start*).
3. Buka browser dan masuk ke `http://localhost/phpmyadmin`.
4. Buat database baru dan lakukan **Import** berkas `db_menitcom.sql`.

### 2. Setup & Instalasi Backend (Node.js)

1. Ekstrak file RAR `backend-node` dan letakkan di struktur folder yang sesuai.
2. Buka folder `backend-node` menggunakan **Visual Studio Code**.
3. Buka Terminal di VS Code (`Ctrl + ~` atau `Ctrl + ` ` `), lalu jalankan perintah berikut untuk menginstal seluruh *dependencies*:

   ```bash
   npm install
   ```

4. Tunggu hingga proses instalasi selesai dan folder `node_modules` terbentuk secara otomatis.

## 🏃‍♂️ Cara Menjalankan Project

> ⚠️ **PENTING:** Layanan Backend dan Aplikasi Flutter harus dijalankan secara bersamaan menggunakan **dua jendela (window) Visual Studio Code yang terpisah**.

### Step 1: Jalankan Database

* Pastikan **Apache** dan **MySQL** di XAMPP dalam status **Running**.

### Step 2: Jalankan Backend (Node.js)

1. Buka window VS Code pertama dengan project **`backend-node`**.
2. Jalankan perintah berikut di terminal:

   ```bash
   npm start
   ```

   *(Atau jalankan `npm run dev` jika menggunakan nodemon, atau `node server.js`)*

3. Jika koneksi berhasil, terminal akan menampilkan output:

   ```text
   Server running on port 3000
   Database connected successfully
   ```

### Step 3: Jalankan Front-end (Flutter)

1. Buka window VS Code kedua dengan project **`menitcom`**.
2. Jalankan perintah berikut di terminal untuk mengunduh package dependencies:

   ```bash
   flutter pub get
   ```

3. Setelah proses selesai, jalankan aplikasi Flutter:

   ```bash
   flutter run
   ```

## 📌 Ringkasan 3 Langkah Utama

1. **XAMPP**: Aktifkan MySQL & Apache.
2. **Backend**: Buka folder `backend-node` ➔ Terminal: `node server.js` / `npm start`.
3. **Flutter**: Buka folder `menitcom` ➔ Terminal: `flutter pub get` ➔ `flutter run`.
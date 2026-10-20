-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 18 Okt 2026 pada 05.57
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_menitcom`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `advertisements`
--

CREATE TABLE `advertisements` (
  `ad_id` int(11) NOT NULL,
  `ad_title` varchar(255) NOT NULL,
  `ad_image_url` text NOT NULL,
  `target_url` text DEFAULT NULL,
  `position` varchar(50) DEFAULT 'in_article'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `authors`
--

CREATE TABLE `authors` (
  `author_id` int(11) NOT NULL,
  `author_name` varchar(150) NOT NULL,
  `avatar_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `authors`
--

INSERT INTO `authors` (`author_id`, `author_name`, `avatar_url`) VALUES
(1, 'Matius Alfons Hutajulu', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop');

-- --------------------------------------------------------

--
-- Struktur dari tabel `bookmarks`
--

CREATE TABLE `bookmarks` (
  `bookmark_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `news_id` int(11) DEFAULT NULL,
  `saved_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `slug`) VALUES
(1, 'detiknews', 'detiknews'),
(2, 'detikFinance', 'detikfinance'),
(3, 'detikSport', 'detiksport'),
(22, 'Inet', 'inet'),
(23, 'Sport', 'sport'),
(24, 'Sepakbola', 'sepakbola'),
(25, 'Oto', 'oto'),
(26, 'Food', 'food'),
(27, 'Foto', 'foto'),
(28, 'Travel', 'travel'),
(29, 'Health', 'health'),
(30, 'Wolipop', 'wolipop'),
(31, 'menitX', 'menitx'),
(32, 'Edu', 'edu'),
(33, 'Hikmah', 'hikmah'),
(34, 'Properti', 'properti'),
(35, 'Pop', 'pop'),
(36, '20menit', '20menit');

-- --------------------------------------------------------

--
-- Struktur dari tabel `comments`
--

CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL,
  `news_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comment_content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `news`
--

CREATE TABLE `news` (
  `news_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `image_url` text NOT NULL,
  `image_caption` varchar(255) DEFAULT NULL,
  `published_at` varchar(100) NOT NULL,
  `views_count` int(11) DEFAULT 0,
  `is_breaking` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `news`
--

INSERT INTO `news` (`news_id`, `category_id`, `author_id`, `title`, `slug`, `content`, `image_url`, `image_caption`, `published_at`, `views_count`, `is_breaking`, `created_at`) VALUES
(1, 1, 1, 'Komisi III Minta MUI Segera Terbitkan Fatwa Haram Vape: Ini Hajat Hidup Umat', 'komisi-iii-minta-mui-segera-terbitkan-fatwa-haram-vape', 'Jakarta - Kapolri Jenderal Suyudi Ario Seto meminta dukungan kepada Majelis Ulama Indonesia (MUI) untuk mengeluarkan fatwa haram rokok elektrik karena bahaya narkotika berbentuk cair. Wakil Ketua Komisi III DPR Ahmad Sahroni meminta MUI segera menerbitkan fatwa haram terhadap vape karena ini mempengaruhi hajat hidup orang banyak.', 'https://images.unsplash.com/photo-1541872703-74c5e44368f9?q=80&w=800&auto=format&fit=crop', 'Foto: Wakil Ketua Komisi III DPR, Ahmad Sahroni (Firda/detikcom)', 'Minggu, 18 Oktober 2026 08:01 WIB', 0, 1, '2026-10-18 01:15:12'),
(2, 2, 1, 'Alasan MSCI Buka Peluang Turunkan Kasta Pasar Saham RI', 'alasan-msci-buka-peluang-turunkan-kasta-pasar-saham-ri', 'Bos Bursa memberikan penjelasan terkait pengumuman dari MSCI yang menyoroti pasar modal Indonesia. Standalone market bukan berarti kasta terendah, namun ada beberapa indikator likuiditas dan free float yang harus diperhatikan oleh regulator pasar modal Indonesia.', 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?q=80&w=300&auto=format&fit=crop', 'Foto: Ilustrasi Saham (Unsplash)', '1 jam lalu', 0, 0, '2026-10-18 01:15:12'),
(3, 3, 1, 'Hasil Laga Uji Coba: Timnas Indonesia Imbang Lawan Negara Eropa', 'hasil-laga-uji-coba-timnas-indonesia-imbang', 'Timnas Indonesia menunjukkan performa impresif dalam laga uji coba internasional menghadapi perwakilan negara Eropa. Pertandingan berjalan ketat dengan jual beli serangan sejak menit awal babak pertama hingga peluit panjang dibunyikan.', 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=300&auto=format&fit=crop', 'Foto: Timnas Indonesia saat berlatih (Unsplash)', '2 jam lalu', 0, 0, '2026-10-18 01:15:12'),
(44, 1, 1, 'Pemerintah Resmi Terapkan Kurikulum Baru untuk Tingkat Menengah', 'pemerintah-resmi-terapkan-kurikulum-baru', 'Kementerian Pendidikan mengumumkan implementasi kurikulum merdeka yang disempurnakan untuk meningkatkan daya saing global siswa Indonesia di era digital serta memperkuat pendidikan karakter.', 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Ruang Kelas (Unsplash)', '3 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(45, 2, 1, 'Sektor Perbankan Digital Catat Lonjakan Transaksi Selama Kuartal III', 'sektor-perbankan-digital-catat-lonjakan-transaksi', 'Bank-bank digital di Indonesia melaporkan pertumbuhan volume transaksi yang signifikan didorong oleh adopsi gaya hidup cashless masyarakat perkotaan yang semakin masif.', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Mobile Banking (Unsplash)', '4 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(46, 3, 1, 'Pebulu Tangkis Tunggal Putra Indonesia Melaju ke Babak Final', 'pebulu-tangkis-tunggal-putra-indonesia-melaju-ke-final', 'Melalui pertarungan sengit tiga gim melawan unggulan tuan rumah, wakil Indonesia sukses mengamankan tiket menuju partai puncak turnamen bulu tangkis level Super 750.', 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Bulu Tangkis (Unsplash)', '5 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(47, 1, 1, 'Proyek Pembangunan Jalan Tol Trans-Jawa Sesi Baru Resmi Dimulai', 'proyek-pembangunan-jalan-tol-trans-jawa-sesi-baru', 'Pemerintah pusat bekerja sama dengan pihak swasta kembali melanjutkan pembangunan infrastruktur strategis guna memangkas waktu tempuh logistik antarwilayah.', 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Jalan Tol (Unsplash)', '6 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(48, 2, 1, 'Harga Emas Antam Hari Ini Naik Tipis di Tengah Ketidakpastian Global', 'harga-emas-antam-hari-ini-naik-tipis', 'Logam mulia produksi PT Aneka Tambang Tbk (Antam) mengalami kenaikan harga seiring meningkatnya permintaan aset safe haven oleh para investor global.', 'https://images.unsplash.com/photo-1610375461246-83df859d849d?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Emas Batangan (Unsplash)', '7 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(49, 3, 1, 'Klub Raksasa Eropa Gelar Tur Pramusim di Asia Tenggara', 'klub-raksasa-eropa-gelar-tur-pramusim-di-asia-tenggara', 'Antusiasme tinggi ditunjukkan oleh para penggemar sepak bola di kawasan Asia Tenggara menyusul kedatangan skuad utama klub elit Liga Inggris untuk melakoni laga persahabatan.', 'https://images.unsplash.com/photo-1518091043644-c1d4457512c6?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Stadion Sepak Bola (Unsplash)', '8 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(50, 1, 1, 'Festival Kuliner Nusantara Tarik Puluhan Ribu Wisatawan Mancanegara', 'festival-kuliner-nusantara-tarik-puluhan-ribu-wisatawan', 'Berbagai hidangan tradisional khas dari Sabang sampai Merauke disajikan dalam pameran budaya tahunan yang sukses mendongkrak sektor pariwisata lokal.', 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Kuliner Nusantara (Unsplash)', '9 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(51, 2, 1, 'Kementerian ESDM Dorong Transisi Energi Hijau Melalui PLTS Atap', 'kementerian-esdm-dorong-transisi-energi-hijau', 'Pemerintah memberikan berbagai insentif menarik bagi masyarakat dan pelaku industri yang mulai beralih menggunakan Pembangkit Listrik Tenaga Surya (PLTS) atap.', 'https://images.unsplash.com/photo-1509391365360-8e953cbef1a2?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Panel Surya (Unsplash)', '10 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(52, 3, 1, 'Atlet Angkat Besi Kebanggaan Indonesia Sabet Medali Emas Kejuaraan Dunia', 'atlet-angkat-besi-indonesia-sabet-medali-emas', 'Prestasi membanggakan kembali ditorehkan oleh lifter muda Indonesia yang berhasil memecahkan rekor angkatan nasional sekaligus mengamankan podium tertinggi.', 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Gym / Angkat Besi (Unsplash)', '11 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(53, 1, 1, 'Inovasi Teknologi AI Lokal Bantu Petani Optimalkan Hasil Panen', 'inovasi-teknologi-ai-lokal-bantu-petani', 'Startup agritech dalam negeri meluncurkan aplikasi berbasis kecerdasan buatan untuk mendeteksi dini penyakit tanaman dan meramalkan waktu pemupukan yang paling ideal.', 'https://images.unsplash.com/photo-1574943320219-553eb213f72d?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Pertanian Modern (Unsplash)', '12 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(54, 2, 1, 'Laju Inflasi Tahunan Terkendali Berkat Stabilitas Harga Pangan Pokok', 'laju-inflasi-tahunan-terkendali-berkat-stabilitas-pangan', 'Badan Pusat Statistik (BPS) melaporkan angka inflasi berada dalam batas target sasaran pemerintah berkat sinergi pengendalian harga pangan melalui operasi pasar murah.', 'https://images.unsplash.com/photo-1578575437130-527eed3abbec?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Pasar Modern (Unsplash)', '13 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(55, 3, 1, 'Liga Basket Profesional Indonesia Masuki Babak Playoff Ketat', 'liga-basket-professional-indonesia-masuki-playoff', 'Persaingan antar tim papan atas semakin memanas memperebutkan tiket menuju babak semifinal Indonesia Basketball League musim ini.', 'https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Lapangan Basket (Unsplash)', '14 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(56, 1, 1, 'Pameran Seni Rupa Kontemporer Internasional Resmi Dibuka di Jakarta', 'pameran-seni-rupa-kontemporer-internasional', 'Seniman dari berbagai belahan dunia memamerkan karya instalasi interaktif bertema kelestarian lingkungan dan masa depan teknologi di galeri nasional.', 'https://images.unsplash.com/photo-1536924940846-227afb31e2a5?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Pameran Seni (Unsplash)', '15 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(57, 2, 1, 'Kementerian Perindustrian Pacu Transformasi Industri Menuju 4.0', 'kementerian-perindustrian-pacu-transformasi-industri', 'Penerapan teknologi otomasi, internet of things (IoT), dan kecerdasan buatan di lini manufaktur nasional terus digenjot guna menekan biaya operasional.', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Pabrik Teknologi (Unsplash)', '16 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(58, 3, 1, 'Tim Esports Indonesia Juara Umum Kejuaraan Tingkat Asia Tenggara', 'tim-esports-indonesia-juara-umum-tingkat-asia-tenggara', 'Dominasi atlet e-sports tanah air kembali diakui setelah sukses menaklukkan tim-tim kuat penantang dari negara tetangga di nomor pertandingan multiplayer arena.', 'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Gaming / Esports (Unsplash)', '17 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(59, 1, 1, 'Program Penanaman Sejuta Pohon Digalakkan di Kawasan Penyangga Ibu Kota', 'program-penanaman-sejuta-pohon-dikawasan-penyangga', 'Aksi nyata pelestarian lingkungan melibatkan ribuan relawan muda dan komunitas lokal untuk mengembalikan fungsi resapan air serta menekan polusi udara.', 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Penghijauan (Unsplash)', '18 jam lalu', 0, 0, '2026-10-18 01:56:30'),
(60, 2, 1, 'Penerbangan Langsung Internasional Baru Dibuka ke Destinasi Wisata Unggulan', 'penerbangan-langsung-internasional-baru-dibuka', 'Maskapai penerbangan global mulai membuka rute langsung baru yang menghubungkan kota-kota besar dunia langsung ke pusat pariwisata eksotis di Indonesia.', 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?q=80&w=800&auto=format&fit=crop', 'Foto: Ilustrasi Pesawat Terbang (Unsplash)', '19 jam lalu', 0, 0, '2026-10-18 01:56:30');

-- --------------------------------------------------------

--
-- Struktur dari tabel `stories`
--

CREATE TABLE `stories` (
  `story_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `video_path` text NOT NULL,
  `time_ago` varchar(100) NOT NULL,
  `views_count` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `stories`
--

INSERT INTO `stories` (`story_id`, `title`, `video_path`, `time_ago`, `views_count`, `created_at`) VALUES
(1, 'Bukan Cuma Modal Sabar, Mancing Juga Butuh Strategi!', 'videos/video1.mp4', '12 menit lalu', 0, '2026-10-18 01:15:12'),
(2, 'Alasan MSCI Buka Peluang Turunkan Kasta Pasar Saham RI', 'videos/video2.mp4', '25 menit lalu', 0, '2026-10-18 01:15:12'),
(3, 'Sehari Habis 250 Porsi! Sop Buntut Cut Meutia Viral', 'videos/video3.mp4', '1 jam lalu', 0, '2026-10-18 01:15:12'),
(4, 'Tips & Trik Mengatur Keuangan untuk Anak Muda', 'videos/video4.mp4', '2 jam lalu', 0, '2026-10-18 01:15:12');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','journalist','reader') DEFAULT 'reader',
  `profile_picture` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `advertisements`
--
ALTER TABLE `advertisements`
  ADD PRIMARY KEY (`ad_id`);

--
-- Indeks untuk tabel `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`author_id`);

--
-- Indeks untuk tabel `bookmarks`
--
ALTER TABLE `bookmarks`
  ADD PRIMARY KEY (`bookmark_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `news_id` (`news_id`);

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indeks untuk tabel `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `news_id` (`news_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`news_id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `author_id` (`author_id`);

--
-- Indeks untuk tabel `stories`
--
ALTER TABLE `stories`
  ADD PRIMARY KEY (`story_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `advertisements`
--
ALTER TABLE `advertisements`
  MODIFY `ad_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `authors`
--
ALTER TABLE `authors`
  MODIFY `author_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `bookmarks`
--
ALTER TABLE `bookmarks`
  MODIFY `bookmark_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT untuk tabel `comments`
--
ALTER TABLE `comments`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `news`
--
ALTER TABLE `news`
  MODIFY `news_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT untuk tabel `stories`
--
ALTER TABLE `stories`
  MODIFY `story_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `bookmarks`
--
ALTER TABLE `bookmarks`
  ADD CONSTRAINT `bookmarks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookmarks_ibfk_2` FOREIGN KEY (`news_id`) REFERENCES `news` (`news_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`news_id`) REFERENCES `news` (`news_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `news`
--
ALTER TABLE `news`
  ADD CONSTRAINT `news_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `news_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

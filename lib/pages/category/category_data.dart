import 'package:flutter/material.dart';

/// ====== WARNA & KONSTANTA ======
const Color kBrandBlue = Color(0xFF22409A);
const Color kBrandOrange = Color(0xFFF15922);
const Color kDividerColor = Color(0xFF2C313A);
const Color kBgColor = Color(0xFF1B1E23);
const Color kCardColor = Color(0xFF262A30);

const bool kUseLogoAssets = false;

/// Model 1 item kategori.

class CategoryItemModel {
  final String id;
  final String label;
  final IconData? icon;

  /// Alternatif ikon berupa huruf/teks (logo "d", "f", "20D", "CNN", dst).
  final String? glyph;

  /// Warna lingkaran (atau warna ikon kalau [bare] = true).
  final Color color;

  /// true = tanpa lingkaran, ikon/teks langsung berwarna [color]
  /// (dipakai di "Bayar Tagihan dan Voucher" & detikX).
  final bool bare;

  /// Tampilkan tag "New" oranye di pojok kiri atas ikon.
  final bool isNew;

  const CategoryItemModel({
    required this.id,
    required this.label,
    required this.color,
    this.icon,
    this.glyph,
    this.bare = false,
    this.isNew = false,
  }) : assert(icon != null || glyph != null);

  String get assetPath => 'assets/category/$id.png';
}

/// Model 1 section (judul + list item)
class CategorySectionModel {
  final String title;
  final List<CategoryItemModel> items;

  const CategorySectionModel({required this.title, required this.items});
}

/// ====== DATA LENGKAP (urutan & isi mengikuti aplikasi detikcom) ======
const List<CategorySectionModel> kCategorySections = [
  // ---------- CHANNEL ----------
  CategorySectionModel(
    title: 'Channel',
    items: [
      CategoryItemModel(
        id: 'news',
        label: 'News',
        glyph: 'n',
        color: Color(0xFF2B4EA2),
      ),
      CategoryItemModel(
        id: 'finance',
        label: 'Finance',
        glyph: 'f',
        color: Color(0xFF1E88E5),
      ),
      CategoryItemModel(
        id: 'hot',
        label: 'Hot',
        icon: Icons.star,
        color: Color(0xFFE53935),
      ),
      CategoryItemModel(
        id: 'inet',
        label: 'Inet',
        glyph: 'i',
        color: Color(0xFF6A1B9A),
      ),
      CategoryItemModel(
        id: 'sport',
        label: 'Sport',
        icon: Icons.directions_run,
        color: Color(0xFFD32F2F),
      ),
      CategoryItemModel(
        id: 'sepakbola',
        label: 'Sepakbola',
        icon: Icons.sports_soccer,
        color: Color(0xFF2E7D32),
      ),
      CategoryItemModel(
        id: 'oto',
        label: 'Oto',
        icon: Icons.speed,
        color: Color(0xFFC62828),
      ),
      CategoryItemModel(
        id: 'food',
        label: 'Food',
        icon: Icons.restaurant,
        color: Color(0xFF43A047),
      ),
      CategoryItemModel(
        id: 'foto',
        label: 'Foto',
        icon: Icons.photo_camera,
        color: Color(0xFF7B1FA2),
      ),
      CategoryItemModel(
        id: 'travel',
        label: 'Travel',
        icon: Icons.beach_access,
        color: Color(0xFFFB8C00),
      ),
      CategoryItemModel(
        id: 'health',
        label: 'Health',
        icon: Icons.favorite,
        color: Color(0xFF00897B),
      ),
      CategoryItemModel(
        id: 'wolipop',
        label: 'Wolipop',
        glyph: 'w',
        color: Color(0xFFD81B60),
      ),
      CategoryItemModel(
        id: 'menitx',
        label: 'menitX',
        glyph: 'X',
        color: Color(0xFFF9A825),
        bare: true,
      ),
      CategoryItemModel(
        id: 'edu',
        label: 'Edu',
        icon: Icons.school,
        color: Color(0xFFEF6C00),
      ),
      CategoryItemModel(
        id: 'hikmah',
        label: 'Hikmah',
        icon: Icons.mosque,
        color: Color(0xFF1B5E20),
      ),
      CategoryItemModel(
        id: 'properti',
        label: 'Properti',
        icon: Icons.home,
        color: Color(0xFFEF6C00),
      ),
      CategoryItemModel(
        id: 'pop',
        label: 'Pop',
        icon: Icons.music_note,
        color: Color(0xFFAB47BC),
        isNew: true,
      ),
      CategoryItemModel(
        id: '20menit',
        label: '20menit',
        glyph: '20M',
        color: Color(0xFFC62828),
      ),
    ],
  ),

  // ---------- REGIONAL CHANNEL ----------
  CategorySectionModel(
    title: 'Regional Channel',
    items: [
      CategoryItemModel(
        id: 'jatim',
        label: 'Jatim',
        icon: Icons.account_balance,
        color: Color(0xFF8D6E63),
      ),
      CategoryItemModel(
        id: 'jateng',
        label: 'Jateng',
        icon: Icons.temple_buddhist,
        color: Color(0xFFE57354),
      ),
      CategoryItemModel(
        id: 'jabar',
        label: 'Jabar',
        icon: Icons.account_balance,
        color: Color(0xFF689F38),
      ),
      CategoryItemModel(
        id: 'jogja',
        label: 'Jogja',
        icon: Icons.location_city,
        color: Color(0xFF00ACC1),
      ),
      CategoryItemModel(
        id: 'sulsel',
        label: 'Sulsel',
        icon: Icons.directions_boat,
        color: Color(0xFF1A237E),
      ),
      CategoryItemModel(
        id: 'sumut',
        label: 'Sumut',
        icon: Icons.landscape,
        color: Color(0xFF2E7D32),
      ),
      CategoryItemModel(
        id: 'bali',
        label: 'Bali',
        icon: Icons.temple_hindu,
        color: Color(0xFFE53935),
      ),
      CategoryItemModel(
        id: 'sumbagsel',
        label: 'Sumbagsel',
        icon: Icons.park,
        color: Color(0xFF00897B),
      ),
      CategoryItemModel(
        id: 'kalimantan',
        label: 'Kalimantan',
        icon: Icons.nature,
        color: Color(0xFF455A64),
      ),
    ],
  ),

  // ---------- BAYAR TAGIHAN DAN VOUCHER ----------
  CategorySectionModel(
    title: 'Bayar Tagihan dan Voucher',
    items: [
      CategoryItemModel(
        id: 'data',
        label: 'Data',
        icon: Icons.sim_card,
        color: Color(0xFF1F3A8A),
        bare: true,
      ),
      CategoryItemModel(
        id: 'pulsa',
        label: 'Pulsa',
        icon: Icons.phone_android,
        color: Color(0xFF1F3A8A),
        bare: true,
      ),
      CategoryItemModel(
        id: 'pln',
        label: 'PLN',
        icon: Icons.bolt,
        color: Color(0xFF1F3A8A),
        bare: true,
      ),
      CategoryItemModel(
        id: 'game',
        label: 'Game',
        icon: Icons.videogame_asset,
        color: Color(0xFF3F51B5),
        bare: true,
      ),
      CategoryItemModel(
        id: 'e-wallet',
        label: 'E-wallet',
        icon: Icons.account_balance_wallet,
        color: Color(0xFF1F3A8A),
        bare: true,
      ),
      CategoryItemModel(
        id: 'bpjs',
        label: 'BPJS Kesehatan',
        icon: Icons.health_and_safety,
        color: Color(0xFF1F3A8A),
        bare: true,
      ),
      CategoryItemModel(
        id: 'pln-pascabayar',
        label: 'PLN Pascabayar',
        icon: Icons.receipt_long,
        color: Color(0xFF1F3A8A),
        bare: true,
      ),
      CategoryItemModel(
        id: 'pdam',
        label: 'PDAM',
        icon: Icons.water_drop,
        color: Color(0xFF1F3A8A),
        bare: true,
      ),
      CategoryItemModel(
        id: 'tv-internet',
        label: 'TV & Internet',
        icon: Icons.tv,
        color: Color(0xFF1F3A8A),
        bare: true,
      ),
      CategoryItemModel(
        id: 'streaming',
        label: 'Streaming',
        icon: Icons.play_circle,
        color: Color(0xFF1F3A8A),
        bare: true,
      ),
    ],
  ),

  // ---------- SEPAKBOLA ----------
  CategorySectionModel(
    title: 'Sepakbola',
    items: [
      CategoryItemModel(
        id: 'klasemen',
        label: 'Klasemen',
        icon: Icons.leaderboard,
        color: Color(0xFF2E9E4F),
      ),
      CategoryItemModel(
        id: 'jadwal-live-score',
        label: 'Jadwal & Live Score',
        icon: Icons.event_note,
        color: Color(0xFF2E9E4F),
      ),
    ],
  ),

  // ---------- SOSIAL DAN AGAMA ----------
  CategorySectionModel(
    title: 'Sosial dan Agama',
    items: [
      CategoryItemModel(
        id: 'jadwal-sholat',
        label: 'Jadwal Sholat',
        icon: Icons.schedule,
        color: Color(0xFF1E9E86),
      ),
      CategoryItemModel(
        id: 'quran-online',
        label: 'Quran Online',
        icon: Icons.menu_book,
        color: Color(0xFF1E9E86),
      ),
      CategoryItemModel(
        id: 'kalkulator-zakat',
        label: 'Kalkulator Zakat',
        icon: Icons.calculate,
        color: Color(0xFF1E9E86),
      ),
      CategoryItemModel(
        id: 'puasa',
        label: 'Puasa',
        icon: Icons.nightlight_round,
        color: Color(0xFF1E9E86),
      ),
      CategoryItemModel(
        id: 'audiobook',
        label: 'Audiobook',
        icon: Icons.headphones,
        color: Color(0xFF1E9E86),
      ),
      CategoryItemModel(
        id: 'zikir',
        label: 'Zikir',
        icon: Icons.blur_circular,
        color: Color(0xFF1E9E86),
      ),
      CategoryItemModel(
        id: 'kuis',
        label: 'Kuis',
        icon: Icons.quiz,
        color: Color(0xFF1E9E86),
      ),
      CategoryItemModel(
        id: 'ziswaf',
        label: 'Ziswaf',
        icon: Icons.volunteer_activism,
        color: Color(0xFF1E9E86),
      ),
      CategoryItemModel(
        id: 'berbuat-baik',
        label: 'BerbuatBaik',
        icon: Icons.favorite,
        color: Color(0xFFE91E63),
      ),
    ],
  ),

  // ---------- HEALTH & BEAUTY ----------
  CategorySectionModel(
    title: 'Health & Beauty',
    items: [
      CategoryItemModel(
        id: 'tanya-dokter',
        label: 'Tanya Dokter',
        icon: Icons.medical_services,
        color: Color(0xFF2FA67A),
      ),
      CategoryItemModel(
        id: 'tes-psikologi',
        label: 'Tes Psikologi',
        icon: Icons.psychology,
        color: Color(0xFF5C9DFF),
      ),
    ],
  ),

  // ---------- TRAVEL & ENTERTAINMENT ----------
  CategorySectionModel(
    title: 'Travel & Entertainment',
    items: [
      CategoryItemModel(
        id: 'trans-studio',
        label: 'Trans Studio',
        icon: Icons.local_activity,
        color: Color(0xFF1E88E5),
      ),
      CategoryItemModel(
        id: 'trans-snow-world',
        label: 'Trans Snow World',
        icon: Icons.ac_unit,
        color: Color(0xFF29B6F6),
      ),
      CategoryItemModel(
        id: 'menit-event',
        label: 'Menit Event',
        icon: Icons.event,
        color: Color(0xFFD81B60),
      ),
      CategoryItemModel(
        id: 'live-tv',
        label: 'Live TV',
        icon: Icons.live_tv,
        color: Color(0xFF1E40AF),
      ),
      CategoryItemModel(
        id: 'fairyland',
        label: 'Fairyland Indonesia',
        icon: Icons.stars,
        color: Color(0xFFFB8C00),
      ),
      CategoryItemModel(
        id: 'hipout',
        label: 'HipOut',
        icon: Icons.explore,
        color: Color(0xFFEC407A),
      ),
    ],
  ),

  // ---------- KIRIM KONTEN ----------
  CategorySectionModel(
    title: 'Kirim Konten',
    items: [
      CategoryItemModel(
        id: 'kolom',
        label: 'Kolom',
        icon: Icons.edit_note,
        color: Color(0xFF1E88E5),
      ),
      CategoryItemModel(
        id: 'pov',
        label: 'POV',
        icon: Icons.remove_red_eye,
        color: Color(0xFFC62828),
      ),
      CategoryItemModel(
        id: 'suara-pembaca',
        label: 'Suara Pembaca',
        icon: Icons.campaign,
        color: Color(0xFF3949AB),
      ),
      CategoryItemModel(
        id: 'resep-pembaca',
        label: 'Resep Pembaca',
        icon: Icons.restaurant_menu,
        color: Color(0xFF43A047),
      ),
      CategoryItemModel(
        id: 'kirim-tempat-bukber',
        label: 'Kirim Tempat Bukber',
        icon: Icons.place,
        color: Color(0xFFEF6C00),
      ),
      CategoryItemModel(
        id: 'cerita-pengalaman',
        label: 'Cerita Pengalaman',
        icon: Icons.auto_stories,
        color: Color(0xFF8E24AA),
      ),
      CategoryItemModel(
        id: 'tanya-hotelier',
        label: 'Tanya Hotelier',
        icon: Icons.hotel,
        color: Color(0xFF00897B),
      ),
      CategoryItemModel(
        id: 'tanya-properti',
        label: 'Tanya Properti',
        icon: Icons.home_work,
        color: Color(0xFFEF6C00),
      ),
    ],
  ),

  // ---------- LAYANAN ----------
  CategorySectionModel(
    title: 'Layanan',
    items: [
      CategoryItemModel(
        id: 'adrenalin',
        label: 'Adrenalin',
        glyph: 'a',
        color: Color(0xFF1E88E5),
      ),
      CategoryItemModel(
        id: 'kirim-tulisan',
        label: 'Kirim Tulisan',
        icon: Icons.mail,
        color: Color(0xFF455A64),
      ),
      CategoryItemModel(
        id: 'bingkai-id',
        label: 'Bingkai.id',
        icon: Icons.photo_library,
        color: Color(0xFFE64A19),
      ),
      CategoryItemModel(
        id: 'signature-awards',
        label: 'Signature Awards',
        icon: Icons.emoji_events,
        color: Color(0xFFB08D57),
      ),
      CategoryItemModel(
        id: 'for-your-business',
        label: 'For Your Business',
        icon: Icons.business_center,
        color: Color(0xFF6A1B9A),
      ),
      CategoryItemModel(
        id: 'trans-hotel-group',
        label: 'Trans Hotel Group',
        icon: Icons.hotel,
        color: Color(0xFF1565C0),
      ),
      CategoryItemModel(
        id: 'menitcourse',
        label: 'Menitcourse',
        icon: Icons.school,
        color: Color(0xFF8E24AA),
      ),
      CategoryItemModel(
        id: 'cari-kerja',
        label: 'Cari Kerja',
        icon: Icons.work,
        color: Color(0xFF1E88E5),
      ),
    ],
  ),

  // ---------- KEUANGAN ----------
  CategorySectionModel(
    title: 'Keuangan',
    items: [
      CategoryItemModel(
        id: 'kalkulator-usaha',
        label: 'Kalkulator Usaha',
        icon: Icons.calculate,
        color: Color(0xFF2F80ED),
      ),
      CategoryItemModel(
        id: 'kalkulator-kredit-kendaraan',
        label: 'Kalkulator Kredit Kend.',
        icon: Icons.calculate,
        color: Color(0xFF2F80ED),
      ),
      CategoryItemModel(
        id: 'kalkulator-kpr',
        label: 'Kalkulator KPR',
        icon: Icons.calculate,
        color: Color(0xFF2F80ED),
      ),
      CategoryItemModel(
        id: 'kalkulator-wedding',
        label: 'Kalkulator Wedding',
        icon: Icons.calculate,
        color: Color(0xFFF5A623),
      ),
    ],
  ),

  // ---------- DETIK NETWORK ----------
  CategorySectionModel(
    title: 'Menit Network',
    items: [
      CategoryItemModel(
        id: 'cnn-indonesia',
        label: 'CNN Indonesia',
        glyph: 'CNN',
        color: Color(0xFFD32F2F),
      ),
      CategoryItemModel(
        id: 'cnbc-indonesia',
        label: 'CNBC Indonesia',
        glyph: 'CNBC',
        color: Color(0xFF1A3A6B),
      ),
      CategoryItemModel(
        id: 'hai-bunda',
        label: 'Hai Bunda',
        icon: Icons.child_friendly,
        color: Color(0xFFEC407A),
      ),
      CategoryItemModel(
        id: 'female-daily',
        label: 'Female Daily',
        icon: Icons.face_retouching_natural,
        color: Color(0xFFE91E63),
      ),
      CategoryItemModel(
        id: 'beautynesia',
        label: 'Beautynesia',
        glyph: 'B',
        color: Color(0xFFAD1457),
      ),
      CategoryItemModel(
        id: 'cxo-media',
        label: 'CXO Media',
        glyph: 'CXO',
        color: Color(0xFF1A237E),
      ),
    ],
  ),
];

/// Index id -> item (dibangun sekali, lookup O(1)).
final Map<String, CategoryItemModel> _itemsById = {
  for (final section in kCategorySections)
    for (final item in section.items) item.id: item,
};

/// Helper: cari item berdasarkan ID
CategoryItemModel? findCategoryById(String id) => _itemsById[id];

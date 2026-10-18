import 'package:flutter/material.dart';

import 'profile_sebelum_login.dart'
    show
        kPrimary,
        showSnack,
        SectionTitle,
        SectionDivider,
        SettingTile,
        ModeSelector,
        ProfilSebelumLogin;

const Color kDanger = Color(0xFFE53935);
const Color kOrange = Color(0xFFF5A623);
const Color kAvatar = Color(0xFF22409A);

const List<String> kBulan = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

final ValueNotifier<Map<String, String>?> currentUser =
    ValueNotifier<Map<String, String>?>({
      ..._dataKosong(),
      'nama': 'Pengguna Menit',
      'email': 'pengguna@menit.com',
    });

Map<String, String> _dataKosong() {
  return {
    'nama': '',
    'email': '',
    'ponsel': '',
    'gender': '',
    'lahir': '',
    'alamat': '',
    'provinsi': '',
    'kota': '',
    'kodepos': '',
    'pendidikan': '',
    'pekerjaan': '',
    'hobi': '',
    'minat': '',
    'kanal': '',
    'pengeluaran': '',
  };
}

void masukKeProfil(BuildContext context, Map<String, String> data) {
  currentUser.value = {..._dataKosong(), ...data};
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const ProfilSetelahLogin()),
    (route) => false,
  );
}

void _keluarKeProfil(BuildContext context, String pesan) {
  // Kosongkan data akun dan kembali ke halaman profil sebelum login.
  currentUser.value = null;

  // Simpan ScaffoldMessenger sebelum navigasi agar notifikasi dapat ditampilkan
  // pada halaman tujuan setelah perpindahan halaman selesai.
  final messenger = ScaffoldMessenger.of(context);
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const ProfilSebelumLogin()),
    (route) => false,
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    messenger.showSnackBar(SnackBar(content: Text(pesan)));
  });
}

String inisial(String nama) {
  final parts = nama.trim().split(' ').where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  return parts.take(2).map((p) => p[0].toUpperCase()).join();
}

class Activity {
  final IconData icon;
  final Color color;
  final String title;
  final String? detail;
  final DateTime time;

  const Activity({
    required this.icon,
    required this.color,
    required this.title,
    this.detail,
    required this.time,
  });
}

final List<Activity> riwayatAktivitas = [
  Activity(
    icon: Icons.emoji_events,
    color: const Color(0xFFF2B418),
    title: 'Kamu berhasil membuat akun menit.com',
    time: DateTime(2026, 10, 15, 18, 3),
  ),
  Activity(
    icon: Icons.phone_android,
    color: kPrimary,
    title: 'Perangkat baru tertaut',
    detail: 'iPhone • Aplikasi menit.com',
    time: DateTime(2026, 10, 15, 18, 5),
  ),
  Activity(
    icon: Icons.laptop_windows,
    color: kPrimary,
    title: 'Perangkat baru tertaut',
    detail: 'Windows • Google Chrome',
    time: DateTime(2026, 10, 17, 16, 30),
  ),
];

Future<void> confirmLogout(BuildContext context) async {
  final yes = await showModalBottomSheet<bool>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Log Out?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Anda akan keluar dari akun ini. Anda bisa masuk lagi kapan saja.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDanger,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  if (yes == true && context.mounted) {
    _keluarKeProfil(context, 'Anda sudah log out');
  }
}

class ProfilSetelahLogin extends StatefulWidget {
  const ProfilSetelahLogin({super.key});

  @override
  State<ProfilSetelahLogin> createState() => _ProfilSetelahLoginState();
}

class _ProfilSetelahLoginState extends State<ProfilSetelahLogin> {
  bool _pushNotif = true;

  void _openDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, String>?>(
      valueListenable: currentUser,
      builder: (context, user, _) {
        final nama = user?['nama'] ?? '';
        final email = user?['email'] ?? '';
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          body: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Profil',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: kAvatar,
                    child: Text(
                      inisial(nama),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: _openDashboard,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimary,
                      side: const BorderSide(color: kPrimary, width: 1.5),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Lihat Profil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionDivider(),
              const SectionTitle('Settings'),
              const SettingTile(
                icon: Icons.brightness_6_outlined,
                title: 'Mode',
                trailing: ModeSelector(),
              ),
              SettingTile(
                icon: Icons.account_circle_outlined,
                title: 'Personal Information',
                onTap: _openDashboard,
              ),
              SettingTile(
                icon: Icons.notifications_none,
                title: 'Notifications List',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                ),
              ),
              SettingTile(
                icon: Icons.notifications_active_outlined,
                title: 'Push Notifications',
                trailing: Switch(
                  value: _pushNotif,
                  activeThumbColor: Colors.white,
                  activeTrackColor: kPrimary,
                  onChanged: (v) => setState(() => _pushNotif = v),
                ),
              ),
              SettingTile(
                icon: Icons.bookmark_border,
                title: 'Bookmark',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookmarkPage()),
                ),
              ),
              const SectionDivider(),
              const SectionTitle('TV'),
              SettingTile(
                icon: Icons.qr_code_scanner,
                title: 'Connect to TV / Scan QR',
                onTap: () => showSnack(context, 'Buka: Connect to TV'),
              ),
              const SectionDivider(),
              const SectionTitle('Akun'),
              SettingTile(
                icon: Icons.logout,
                title: 'Log Out',
                color: kDanger,
                onTap: () => confirmLogout(context),
              ),
              const SectionDivider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Text(
                  'Version 7.12.0 (1)',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _showPoints = true;

  void _openMenu(String menu) {
    if (menu == 'Aktivitas') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ActivityPage()),
      );
    } else if (menu == 'Kelola Akun') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final line = isDark ? Colors.white12 : Colors.grey.shade200;

    return ValueListenableBuilder<Map<String, String>?>(
      valueListenable: currentUser,
      builder: (context, user, _) {
        final nama = user?['nama'] ?? '';
        return Scaffold(
          drawer: AppDrawer(
            onSelect: _openMenu,
            onLogout: () => confirmLogout(context),
          ),
          appBar: backAppBar(context),
          body: ListView(
            children: [
              TitleBar(
                title: 'Dashboard',
                trailing: IconButton(
                  tooltip: 'Log Out',
                  onPressed: () => confirmLogout(context),
                  icon: const Icon(Icons.logout, color: kPrimary, size: 28),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 34,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? const [Color(0xFF2A2F3A), Color(0xFF1E222A)]
                        : const [Color(0xFFD3D9E1), Color(0xFFE8EBF0)],
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: kAvatar,
                      child: Text(
                        inisial(nama),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : const Color(0xFFF0F1F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF5B324),
                          border: Border.all(color: Colors.black87, width: 2),
                        ),
                        child: const Icon(
                          Icons.stars_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Poin Saya',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _showPoints ? '0' : '•••',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () =>
                                    setState(() => _showPoints = !_showPoints),
                                child: Icon(
                                  _showPoints
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _menuItem(Icons.desktop_windows_outlined, 'Aktivitas', line),
              _menuItem(Icons.person_outline, 'Kelola Akun', line),
              const SizedBox(height: 60),
              Center(
                child: Text(
                  'menit.com',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white70 : kPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem(IconData icon, String title, Color line) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () => _openMenu(title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: line)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(icon, size: 24),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  String _dua(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final list = List<Activity>.from(riwayatAktivitas)
      ..sort((a, b) => b.time.compareTo(a.time));

    final Map<String, List<Activity>> groups = {};
    for (final a in list) {
      final key = '${kBulan[a.time.month - 1]} ${a.time.year}';
      groups.putIfAbsent(key, () => []).add(a);
    }

    final children = <Widget>[];
    groups.forEach((bulan, items) {
      children.add(
        Text(
          bulan,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
        ),
      );
      children.add(const SizedBox(height: 22));
      for (final a in items) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(a.icon, color: a.color, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (a.detail != null) ...[
                        const SizedBox(height: 2),
                        Text(a.detail!, style: const TextStyle(fontSize: 15)),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        '${a.time.day} ${kBulan[a.time.month - 1]} ${a.time.year}'
                        ' | ${_dua(a.time.hour)}:${_dua(a.time.minute)} WIB',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      children.add(const SizedBox(height: 12));
    });

    return Scaffold(
      drawer: AppDrawer(
        onSelect: (menu) {
          if (menu == 'Kelola Akun') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AccountPage()),
            );
          }
        },
        onLogout: () => confirmLogout(context),
      ),
      appBar: backAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TitleBar(title: 'Riwayat Aktivitas'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static const List<List<String>> _akun = [
    ['ponsel', 'Nomor Ponsel'],
    ['email', 'Email'],
  ];
  static const List<List<String>> _dasar = [
    ['gender', 'Jenis kelamin'],
    ['lahir', 'Tanggal Lahir'],
    ['alamat', 'Alamat'],
    ['provinsi', 'Provinsi'],
    ['kota', 'Kota'],
    ['kodepos', 'Kode Pos'],
  ];
  static const List<List<String>> _tambahan = [
    ['pendidikan', 'Pendidikan'],
    ['pekerjaan', 'Pekerjaan'],
    ['hobi', 'Hobi'],
    ['minat', 'Minat'],
    ['kanal', 'Kanal Favorit'],
    ['pengeluaran', 'Pengeluaran'],
  ];

  String? _editing;
  final Map<String, TextEditingController> _ctrl = {};
  List<String> _editKeys = [];

  @override
  void dispose() {
    for (final c in _ctrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _startEdit(String section, List<List<String>> fields) {
    final user = currentUser.value ?? {};
    final keys = <String>[
      if (section == 'akun') 'nama',
      ...fields.map((f) => f[0]),
    ];
    for (final k in keys) {
      _ctrl[k]?.dispose();
      _ctrl[k] = TextEditingController(text: user[k] ?? '');
    }
    _editKeys = keys;
    setState(() => _editing = section);
  }

  void _save() {
    final user = currentUser.value;
    if (user == null) return;
    if (_editKeys.contains('nama') && _ctrl['nama']!.text.trim().isEmpty) {
      showSnack(context, 'Nama tidak boleh kosong');
      return;
    }
    final updated = Map<String, String>.from(user);
    for (final k in _editKeys) {
      updated[k] = _ctrl[k]!.text.trim();
    }
    currentUser.value = updated;
    setState(() => _editing = null);
    showSnack(context, 'Perubahan disimpan');
  }

  void _cancel() {
    setState(() => _editing = null);
  }

  Future<void> _confirmDelete() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus akun?'),
        content: const Text(
          'Semua data akun, poin, dan bookmark akan dihapus permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus Akun', style: TextStyle(color: kDanger)),
          ),
        ],
      ),
    );
    if (yes == true && mounted) {
      _keluarKeProfil(context, 'Akun telah dihapus');
    }
  }

  Widget _orangeButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: kOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _field(
    String key,
    String label,
    Map<String, String> user,
    bool editing,
  ) {
    final value = user[key] ?? '';
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          editing
              ? TextField(
                  controller: _ctrl[key],
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              : Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _section(
    String id,
    String title,
    List<List<String>> fields,
    Map<String, String> user,
    Color line,
  ) {
    final editing = _editing == id;
    return Container(
      padding: const EdgeInsets.only(top: 22, bottom: 26),
      decoration: id == 'akun'
          ? null
          : BoxDecoration(
              border: Border(top: BorderSide(color: line)),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (!editing && _editing == null)
                _orangeButton('Ubah', () => _startEdit(id, fields)),
            ],
          ),
          if (id == 'akun') ...[
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDDF6EC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Color(0xFF1FA971), size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Perubahan data di halaman ini akan memperbarui akun menit.com kamu.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (editing) _field('nama', 'Nama Lengkap', user, true),
          ],
          for (final f in fields) _field(f[0], f[1], user, editing),
          if (editing) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _cancel,
                  style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 10),
                _orangeButton('Simpan', _save),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final line = isDark ? Colors.white12 : Colors.grey.shade300;

    return ValueListenableBuilder<Map<String, String>?>(
      valueListenable: currentUser,
      builder: (context, userOrNull, _) {
        final user = userOrNull ?? <String, String>{};
        final nama = user['nama'] ?? '';
        return Scaffold(
          drawer: AppDrawer(
            onSelect: (menu) {
              if (menu == 'Aktivitas') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ActivityPage()),
                );
              }
            },
            onLogout: () => confirmLogout(context),
          ),
          appBar: backAppBar(context),
          body: Column(
            children: [
              const TitleBar(title: 'Akun Saya'),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 110,
                            color: isDark
                                ? const Color(0xFF2A2F3A)
                                : const Color(0xFFDDE2E9),
                          ),
                          Positioned(
                            top: 30,
                            child: GestureDetector(
                              onTap: () =>
                                  showSnack(context, 'Pilih foto profil'),
                              child: ClipOval(
                                child: Container(
                                  width: 168,
                                  height: 168,
                                  color: kAvatar,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        bottom: 26,
                                        child: Center(
                                          child: Text(
                                            inisial(nama),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 70,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        height: 42,
                                        child: Container(
                                          color: kOrange,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Ubah Foto',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _section('akun', nama, _akun, user, line),
                          _section(
                            'dasar',
                            'Informasi Dasar',
                            _dasar,
                            user,
                            line,
                          ),
                          _section(
                            'tambahan',
                            'Informasi Tambahan',
                            _tambahan,
                            user,
                            line,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: line)),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                      child: TextButton(
                        onPressed: _confirmDelete,
                        child: const Text(
                          'Saya ingin menghapus akun',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: kPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<List<String>> _items = [
    [
      'BMKG Imbau Warga Waspada Hujan Lebat Malam Ini',
      'Berita',
      '1 menit lalu',
    ],
    [
      'Gempa M 4,1 Guncang Wilayah Selatan Jawa Barat',
      'Berita',
      '18 menit lalu',
    ],
    ['Harga Emas Hari Ini Naik Tipis', 'Finance', '42 menit lalu'],
    ['Timnas Umumkan Skuad untuk Laga Uji Coba', 'Sport', '1 jam lalu'],
  ];
  final Set<int> _read = {};

  @override
  Widget build(BuildContext context) {
    final unread = _items.length - _read.length;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Row(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 12),
              if (unread > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8131F),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < _items.length; i++)
            InkWell(
              onTap: () => setState(() => _read.add(i)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _items[i][0],
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: _read.contains(i)
                                  ? FontWeight.w400
                                  : FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_items[i][1]} · ${_items[i][2]}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: kPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.article_outlined,
                        color: kPrimary,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  int _tab = 0;

  Widget _tabButton(String label, int index) {
    final selected = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kPrimary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pesan = _tab == 0
        ? 'Belum ada artikel yang di-bookmark. Ketuk ikon bookmark di artikel untuk menyimpannya ke halaman ini.'
        : 'Belum ada Flash yang di-bookmark. Ketuk ikon bookmark di Flash untuk menyimpannya ke halaman ini.';
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bookmark',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: Row(
              children: [
                _tabButton('Artikel', 0),
                const SizedBox(width: 12),
                _tabButton('Flash', 1),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bookmarks_outlined,
                      size: 96,
                      color: Color(0xFF3E5574),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      pesan,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget backAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    scrolledUnderElevation: 0,
    automaticallyImplyLeading: false,
    leadingWidth: 110,
    leading: TextButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back, size: 26),
      label: const Text('Back', style: TextStyle(fontSize: 18)),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}

class TitleBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const TitleBar({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),
            customBorder: const CircleBorder(),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: kPrimary,
              child: Icon(Icons.menu, color: Colors.white, size: 18),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: kPrimary,
              ),
            ),
          ),
          SizedBox(width: 48, child: trailing),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final ValueChanged<String> onSelect;
  final VoidCallback onLogout;
  const AppDrawer({super.key, required this.onSelect, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String title) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 36),
        leading: Icon(icon, size: 26),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        onTap: () {
          Navigator.pop(context);
          onSelect(title);
        },
      );
    }

    return Drawer(
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tutup',
                        style: TextStyle(
                          color: kPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: kPrimary,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(36, 14, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Akun Saya',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            item(Icons.desktop_windows_outlined, 'Aktivitas'),
            item(Icons.person_outline, 'Kelola Akun'),
            const Spacer(),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 18, 20, 22),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onLogout();
                  },
                  child: const Text(
                    'Keluar Akun',
                    style: TextStyle(
                      color: kPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LayarKeluar extends StatelessWidget {
  const LayarKeluar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 72, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Anda sudah keluar dari akun',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => masukKeProfil(context, {
                  'nama': 'Pengguna Menit',
                  'email': 'pengguna@menit.com',
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Masuk lagi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

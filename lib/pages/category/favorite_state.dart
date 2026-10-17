import 'package:flutter/foundation.dart';

import 'category_data.dart';

/// State global untuk favorit yang SUDAH DISIMPAN.
///
/// Perubahan di halaman "Atur Favorite" tidak langsung masuk ke sini,
/// melainkan ditampung sebagai draft dan baru di-commit lewat [save]
/// ketika tombol "Simpan" ditekan (tombol back = batal).
class FavoriteState extends ChangeNotifier {
  List<String> _ids = const [];

  /// Urutan ID favorit (urutan = urutan saat di-tap), read-only.
  List<String> get favoriteIds => List.unmodifiable(_ids);

  /// Item favorit yang sudah di-resolve dari ID.
  List<CategoryItemModel> get favoriteItems => _ids
      .map(findCategoryById)
      .whereType<CategoryItemModel>()
      .toList(growable: false);

  bool isFavorite(CategoryItemModel item) => _ids.contains(item.id);

  /// Commit daftar favorit baru. Hanya memberi notifikasi jika memang berubah.
  void save(List<String> ids) {
    final cleaned = <String>[];
    for (final id in ids) {
      if (findCategoryById(id) != null && !cleaned.contains(id)) {
        cleaned.add(id);
      }
    }
    if (listEquals(cleaned, _ids)) return;
    _ids = cleaned;
    notifyListeners();
  }
}

/// Instance global (singleton sederhana, tanpa package tambahan).
final favoriteState = FavoriteState();

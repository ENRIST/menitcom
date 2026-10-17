import 'package:flutter/material.dart';

import 'category_data.dart';
import 'category_item.dart';
import 'category_section.dart';
import 'favorite_state.dart';

class AturFavoritePage extends StatefulWidget {
  const AturFavoritePage({super.key});

  @override
  State<AturFavoritePage> createState() => _AturFavoritePageState();
}

class _AturFavoritePageState extends State<AturFavoritePage> {
  /// Draft: urutan ID sesuai urutan tap. Baru masuk ke [favoriteState]
  /// saat "Simpan" ditekan; tombol back = batal.
  late final List<String> _draft = List<String>.of(favoriteState.favoriteIds);

  List<CategoryItemModel> get _draftItems => _draft
      .map(findCategoryById)
      .whereType<CategoryItemModel>()
      .toList(growable: false);

  bool _isFav(CategoryItemModel item) => _draft.contains(item.id);

  void _toggle(CategoryItemModel item) {
    setState(() {
      if (!_draft.remove(item.id)) _draft.add(item.id);
    });
  }

  void _remove(CategoryItemModel item) {
    setState(() => _draft.remove(item.id));
  }

  void _save() {
    favoriteState.save(_draft);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final favs = _draftItems;

    return Scaffold(
      backgroundColor: kBgColor,
      body: CustomScrollView(
        slivers: [
          // ===== HEADER (SliverAppBar) =====
          SliverAppBar(
            backgroundColor: kBgColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            pinned: false,
            floating: true,
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Atur Favorite',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: _save,
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          // ===== SUBTITLE =====
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                'Atur kategori sesuai keinginan Anda dengan tap icon '
                'sesuai urutan lalu simpan.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ),
          ),

          // ===== SECTION FAVORITE (Draft) =====
          SliverToBoxAdapter(
            child: Material(
              color: kCardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Text(
                      'Favorite',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (favs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: Text(
                        'Belum ada kategori favorit. Tap icon di bawah untuk menambahkan.',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CategoryGrid(
                        items: favs,
                        badgeMode: CategoryBadgeMode.removeOnly,
                        isFavorite: (_) => true,
                        onItemTap: _remove,
                      ),
                    ),
                  const Divider(height: 1, thickness: 1, color: kDividerColor),
                ],
              ),
            ),
          ),

          // ===== SEMUA SECTION =====
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return CategorySection(
                section: kCategorySections[index],
                badgeMode: CategoryBadgeMode.toggle,
                isFavorite: _isFav,
                onItemTap: _toggle,
              );
            }, childCount: kCategorySections.length),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

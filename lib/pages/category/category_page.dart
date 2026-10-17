import 'package:flutter/material.dart';

import 'atur_favorite_page.dart';
import 'category_data.dart';
import 'category_section.dart';
import 'favorite_state.dart';
import 'category_news_page.dart';

class CategoryPage extends StatelessWidget {
  /// Dipanggil saat item (channel/layanan) di-tap. Sambungkan ke halaman
  /// tujuan masing-masing. Kalau null, tampil SnackBar sederhana.
  final void Function(CategoryItemModel item)? onItemTap;

  const CategoryPage({super.key, this.onItemTap});

  void _handleItemTap(BuildContext context, CategoryItemModel item) {
    if (onItemTap != null) {
      onItemTap!(item);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryNewsPage(category: item)),
    );
  }

  void _openAturFavorite(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AturFavoritePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ===== HEADER (ikut scroll, seperti di detikcom) =====
            const SliverToBoxAdapter(child: _Header()),

            // ===== FAVORITE (reaktif) =====
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: favoriteState,
                builder: (context, _) {
                  final favs = favoriteState.favoriteItems;
                  return Material(
                    color: kCardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 8, 4),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Favorite',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => _openAturFavorite(context),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.settings,
                                    size: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (favs.isEmpty)
                          const _EmptyFavorite()
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CategoryGrid(
                              items: favs,
                              onItemTap: (item) =>
                                  _handleItemTap(context, item),
                            ),
                          ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: kDividerColor,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ===== SEMUA SECTION =====
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return CategorySection(
                  section: kCategorySections[index],
                  onItemTap: (item) => _handleItemTap(context, item),
                );
              }, childCount: kCategorySections.length),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Jelajahi beragam Channel, Service, dan juga atur pilihan Anda di Favorite.',
            style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}

/// Tampilan saat belum ada favorit (ilustrasi + teks ajakan).
class _EmptyFavorite extends StatelessWidget {
  const _EmptyFavorite();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 4, 24, 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FavoriteIllustration(),
            SizedBox(height: 8),
            Text(
              'Personalisasi Favorite',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Tambahkan channel berita & tools yang Anda sukai di Favorite. '
              'Ketuk tombol pengaturan untuk memulai.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white70,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ilustrasi sederhana: ponsel miring + bubble jempol + hati.
class _FavoriteIllustration extends StatelessWidget {
  const _FavoriteIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Transform.rotate(
            angle: 0.12,
            child: Container(
              width: 40,
              height: 62,
              padding: const EdgeInsets.fromLTRB(6, 18, 6, 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF5B6B8C), width: 2.5),
              ),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(
                  9,
                  (_) => Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9FB0D0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 2,
            child: Container(
              width: 30,
              height: 26,
              decoration: BoxDecoration(
                color: kBrandBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.thumb_up, size: 15, color: Colors.white),
            ),
          ),
          Positioned(
            right: 10,
            top: 14,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, size: 11, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

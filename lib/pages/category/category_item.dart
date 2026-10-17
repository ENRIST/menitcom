import 'package:flutter/material.dart';

import 'category_data.dart';

/// Mode tampilan badge
enum CategoryBadgeMode {
  none, // tanpa badge (halaman Category)
  toggle, // ✓ hijau kalau favorit, + abu-abu kalau belum (Atur Favorite)
  removeOnly, // − merah (section Favorite di Atur Favorite)
}

/// Ukuran ikon (diukur dari screenshot detikcom: ± 30dp pada layar 360dp).
const double kCategoryIconSize = 30;

class CategoryItem extends StatelessWidget {
  final CategoryItemModel item;
  final VoidCallback? onTap;
  final bool isFavorite;
  final CategoryBadgeMode badgeMode;

  const CategoryItem({
    super.key,
    required this.item,
    this.onTap,
    this.isFavorite = false,
    this.badgeMode = CategoryBadgeMode.none,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 4, 2, 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== IKON + TAG NEW + BADGE =====
            SizedBox(
              width: kCategoryIconSize,
              height: kCategoryIconSize,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(child: CategoryIcon(item: item)),
                  if (item.isNew)
                    const Positioned(left: -12, top: -3, child: _NewTag()),
                  if (badgeMode != CategoryBadgeMode.none)
                    Positioned(
                      left: 28,
                      top: 0,
                      child: _Badge(mode: badgeMode, isFavorite: isFavorite),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // ===== LABEL =====
            Text(
              item.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ikon item. Memakai logo asli kalau [kUseLogoAssets] aktif,
/// selain itu (atau kalau file tidak ada) memakai ikon bawaan.
class CategoryIcon extends StatelessWidget {
  final CategoryItemModel item;
  final double size;

  const CategoryIcon({
    super.key,
    required this.item,
    this.size = kCategoryIconSize,
  });

  @override
  Widget build(BuildContext context) {
    if (kUseLogoAssets) {
      return Image.asset(
        item.assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }
    return _buildFallback();
  }

  Widget _buildFallback() {
    final Widget content;
    if (item.glyph != null) {
      content = FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          item.glyph!,
          style: TextStyle(
            color: item.bare ? item.color : Colors.white,
            fontSize: item.bare ? 30 : 18,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      );
    } else {
      content = Icon(
        item.icon,
        size: item.bare ? size - 2 : size * 0.58,
        color: item.bare ? item.color : Colors.white,
      );
    }

    if (item.bare) return Center(child: content);

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(item.glyph != null ? 5 : 0),
      decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
      child: content,
    );
  }
}

/// Tag "New" kecil di kiri atas ikon (contoh: Pop).
class _NewTag extends StatelessWidget {
  const _NewTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        color: kBrandOrange,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white, width: 0.8),
      ),
      child: const Text(
        'New',
        style: TextStyle(
          fontSize: 6.5,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.1,
        ),
      ),
    );
  }
}

/// Badge bulat kecil di kanan atas ikon.
class _Badge extends StatelessWidget {
  final CategoryBadgeMode mode;
  final bool isFavorite;

  const _Badge({required this.mode, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    final IconData iconData;
    final Color bgColor;

    switch (mode) {
      case CategoryBadgeMode.toggle:
        iconData = isFavorite ? Icons.check : Icons.add;
        bgColor = isFavorite
            ? const Color(0xFF4CAF50) // hijau
            : const Color(0xFF607D8B); // abu kebiruan
        break;
      case CategoryBadgeMode.removeOnly:
        iconData = Icons.remove;
        bgColor = const Color(0xFFE53935); // merah
        break;
      case CategoryBadgeMode.none:
        return const SizedBox.shrink();
    }

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 0.8),
      ),
      child: Icon(iconData, size: 10, color: Colors.white),
    );
  }
}

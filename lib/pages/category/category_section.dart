import 'package:flutter/material.dart';

import 'category_data.dart';
import 'category_item.dart';

/// Grid 4 kolom yang tinggi barisnya mengikuti isi (anti overflow saat label
/// 2 baris / font sistem diperbesar, tidak seperti childAspectRatio tetap).
class CategoryGrid extends StatelessWidget {
  final List<CategoryItemModel> items;
  final bool Function(CategoryItemModel item)? isFavorite;
  final void Function(CategoryItemModel item)? onItemTap;
  final CategoryBadgeMode badgeMode;
  final int columns;

  const CategoryGrid({
    super.key,
    required this.items,
    this.isFavorite,
    this.onItemTap,
    this.badgeMode = CategoryBadgeMode.none,
    this.columns = 4,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var start = 0; start < items.length; start += columns) {
      final cells = <Widget>[];
      for (var c = 0; c < columns; c++) {
        final index = start + c;
        if (index < items.length) {
          final item = items[index];
          cells.add(
            Expanded(
              child: CategoryItem(
                key: ValueKey(item.id),
                item: item,
                isFavorite: isFavorite?.call(item) ?? false,
                badgeMode: badgeMode,
                onTap: onItemTap == null ? null : () => onItemTap!(item),
              ),
            ),
          );
        } else {
          cells.add(const Expanded(child: SizedBox.shrink()));
        }
      }
      rows.add(
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(children: rows),
    );
  }
}

/// Satu section (judul + chevron + grid) yang bisa dilipat.
class CategorySection extends StatefulWidget {
  final CategorySectionModel section;
  final bool Function(CategoryItemModel item)? isFavorite;
  final void Function(CategoryItemModel item)? onItemTap;
  final CategoryBadgeMode badgeMode;

  const CategorySection({
    super.key,
    required this.section,
    this.isFavorite,
    this.onItemTap,
    this.badgeMode = CategoryBadgeMode.none,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection>
    with AutomaticKeepAliveClientMixin {
  bool _isExpanded = true;

  /// Supaya status lipat/buka tidak ter-reset saat section keluar layar
  /// (SliverList membuang widget yang tidak terlihat).
  @override
  bool get wantKeepAlive => true;

  void _toggle() => setState(() => _isExpanded = !_isExpanded);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Material(
      color: kCardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.section.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      size: 24,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== GRID =====
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CategoryGrid(
                      items: widget.section.items,
                      isFavorite: widget.isFavorite,
                      onItemTap: widget.onItemTap,
                      badgeMode: widget.badgeMode,
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),

          const Divider(height: 1, thickness: 1, color: kDividerColor),
        ],
      ),
    );
  }
}

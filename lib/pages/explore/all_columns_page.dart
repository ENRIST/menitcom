// lib/pages/explore/all_columns_page.dart
import 'package:flutter/material.dart';

import 'explore_models.dart';
import 'explore_service.dart';
import 'explore_widgets.dart';

class AllColumnsPage extends StatefulWidget {
  const AllColumnsPage({super.key});

  @override
  State<AllColumnsPage> createState() => _AllColumnsPageState();
}

class _AllColumnsPageState extends State<AllColumnsPage> {
  final _service = ExploreService();
  late Future<List<ColumnItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchColumns();
  }

  Future<void> _refresh() async {
    setState(() => _future = _service.fetchColumns());
    try {
      await _future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kTextDark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        color: kPrimary,
        onRefresh: _refresh,
        child: FutureBuilder<List<ColumnItem>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return ListView(children: const [LoadingBox(height: 300)]);
            }
            if (snap.hasError) {
              return ListView(children: [ErrorBox(onRetry: _refresh)]);
            }
            final items = snap.data ?? [];
            if (items.isEmpty) {
              return ListView(children: const [EmptyText('Belum ada kolom')]);
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: items.length,
              itemBuilder: (_, i) => ColumnTile(
                column: items[i],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ColumnDetailPage(column: items[i])),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Halaman baca sederhana untuk satu artikel kolom.
class ColumnDetailPage extends StatelessWidget {
  const ColumnDetailPage({super.key, required this.column});
  final ColumnItem column;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kTextDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Kolom', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(
            column.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.25,
              color: kTextDark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              AuthorAvatar(name: column.authorName, url: column.authorAvatar),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Oleh: ${column.authorName}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF555555),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: NetImage(column.imageUrl, radius: 12),
          ),
          const SizedBox(height: 16),
          Text(
            column.content,
            style: const TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }
}

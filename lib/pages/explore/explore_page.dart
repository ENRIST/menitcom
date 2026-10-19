// lib/pages/explore/explore_page.dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'explore_models.dart';
import 'explore_service.dart';
import 'explore_widgets.dart';
import 'all_columns_page.dart';
import 'all_events_page.dart';

class _ExploreData {
  final List<NewsItem> popular;
  final List<EventItem> events;
  final List<ColumnItem> columns;
  const _ExploreData(this.popular, this.events, this.columns);
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key, this.onNewsTap});

  /// Hubungkan ke halaman detail berita milikmu, mis.
  /// onNewsTap: (n) => Navigator.push(context, MaterialPageRoute(
  ///     builder: (_) => NewsDetailPage(newsId: n.id)))
  final void Function(NewsItem news)? onNewsTap;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  static const int _popularFetch = 10; // diambil dari server
  static const int _popularInitial = 4; // tampil awal

  final _service = ExploreService();
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  late Future<_ExploreData> _future;
  Future<List<NewsItem>>? _searchFuture;
  String _query = '';
  bool _showAllPopular = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<_ExploreData> _load() async {
    final r = await Future.wait<Object>([
      _service.fetchPopular(limit: _popularFetch),
      _service.fetchEvents(limit: 5),
      _service.fetchColumns(limit: 3),
    ]);
    return _ExploreData(
      r[0] as List<NewsItem>,
      r[1] as List<EventItem>,
      r[2] as List<ColumnItem>,
    );
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    try {
      await _future;
    } catch (_) {
      /* error ditampilkan oleh FutureBuilder */
    }
  }

  // ----------------------------------------------------------- pencarian
  void _runSearch(String value) {
    final q = value.trim();
    setState(() {
      _query = q;
      _searchFuture = q.isEmpty ? null : _service.searchNews(q);
    });
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      _runSearch('');
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 450),
      () => _runSearch(value),
    );
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchCtrl.clear();
    FocusScope.of(context).unfocus();
    _runSearch('');
  }

  // ----------------------------------------------------------- navigasi
  void _openAllEvents() =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const AllEventsPage()));

  void _openAllColumns() =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const AllColumnsPage()));

  // ----------------------------------------------------------- UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: kPrimary,
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: kTextDark,
                  ),
                ),
              ),
              _buildSearchBar(),
              const SizedBox(height: 24),
              if (_query.isEmpty) _buildSections() else _buildSearchResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchCtrl,
        onChanged: _onChanged,
        onSubmitted: (v) {
          _debounce?.cancel();
          _runSearch(v);
        },
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: const TextStyle(color: Color(0xFF7A7A7A), fontSize: 17),
          prefixIcon: const Icon(
            Icons.search,
            size: 28,
            color: Color(0xFF555555),
          ),
          suffixIcon: _searchCtrl.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearSearch,
                ),
          filled: true,
          fillColor: const Color(0xFFEBEBEB),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<NewsItem>>(
      key: ValueKey(_query),
      future: _searchFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const LoadingBox(height: 160);
        }
        if (snap.hasError) {
          return ErrorBox(onRetry: () => _runSearch(_query));
        }
        final items = snap.data ?? [];
        if (items.isEmpty) return EmptyText('Tidak ada hasil untuk "$_query"');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                '${items.length} hasil untuk "$_query"',
                style: const TextStyle(color: kTextGrey),
              ),
            ),
            for (final n in items)
              NewsTile(news: n, onTap: () => widget.onNewsTap?.call(n)),
          ],
        );
      },
    );
  }

  Widget _buildSections() {
    return FutureBuilder<_ExploreData>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const LoadingBox(height: 300);
        }
        if (snap.hasError || snap.data == null) {
          return ErrorBox(onRetry: _refresh);
        }
        final d = snap.data!;
        final visiblePopular = _showAllPopular
            ? d.popular
            : d.popular.take(_popularInitial).toList();
        final canExpand =
            !_showAllPopular && d.popular.length > _popularInitial;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------- Berita Terpopuler
            const SectionTitle('Berita Terpopuler'),
            if (d.popular.isEmpty) const EmptyText('Belum ada berita'),
            for (int i = 0; i < visiblePopular.length; i++)
              NewsTile(
                news: visiblePopular[i],
                rank: i + 1,
                onTap: () => widget.onNewsTap?.call(visiblePopular[i]),
              ),
            if (canExpand)
              MoreButton(onTap: () => setState(() => _showAllPopular = true)),

            const SectionGap(),

            // ------------------------------------------- Event & Entertainment
            SectionTitle('Event & Entertainment', onArrowTap: _openAllEvents),
            if (d.events.isEmpty)
              const EmptyText('Belum ada event aktif')
            else
              SizedBox(
                height: 356,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: d.events.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) => SizedBox(
                    width: 300,
                    // Tombol "Pesan Tiket" membuka booking_url.
                    // Ganti ke _openAllEvents jika ingin menuju AllEventsPage.
                    child: EventCard(
                      event: d.events[i],
                      onBook: () => openBooking(context, d.events[i]),
                    ),
                  ),
                ),
              ),

            const SectionGap(),

            // ------------------------------------------- Kolom (Opini)
            const SectionTitle('Kolom'),
            if (d.columns.isEmpty) const EmptyText('Belum ada kolom'),
            for (final c in d.columns)
              ColumnTile(
                column: c,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ColumnDetailPage(column: c),
                  ),
                ),
              ),
            MoreButton(onTap: _openAllColumns),
          ],
        );
      },
    );
  }
}

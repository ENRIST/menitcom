// lib/pages/explore/all_events_page.dart
import 'package:flutter/material.dart';

import 'explore_models.dart';
import 'explore_service.dart';
import 'explore_widgets.dart';

class AllEventsPage extends StatefulWidget {
  const AllEventsPage({super.key});

  @override
  State<AllEventsPage> createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  final _service = ExploreService();
  late Future<List<EventItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchEvents();
  }

  Future<void> _refresh() async {
    setState(() => _future = _service.fetchEvents());
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
        child: FutureBuilder<List<EventItem>>(
          future: _future,
          builder: (context, snap) {
            final header = const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 20),
              child: Text(
                'Event & Entertainment',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: kTextDark,
                ),
              ),
            );

            Widget body;
            if (snap.connectionState != ConnectionState.done) {
              body = const LoadingBox(height: 300);
            } else if (snap.hasError) {
              body = ErrorBox(onRetry: _refresh);
            } else if ((snap.data ?? []).isEmpty) {
              body = const EmptyText('Belum ada event aktif');
            } else {
              final events = snap.data!;
              body = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (final e in events) ...[
                      EventCard(event: e, onBook: () => openBooking(context, e)),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              );
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              children: [header, body],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menitcom/pages/video/video_feed_page.dart';
import 'package:menitcom/pages/video/video_shorts_page.dart';

void main() {
  testWidgets('VideoFeedPage renders correctly', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: VideoFeedPage(),
      ),
    );

    expect(find.byType(RichText), findsWidgets);
    expect(find.text('1MENIT Shorts'), findsOneWidget);
    expect(find.text('Daftar Video'), findsOneWidget);
    expect(find.text('00:46'), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('VideoShortsPage renders correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VideoShortsPage(),
      ),
    );

    expect(find.text('Shorts'), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
  });
}

import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/presentation/pages/tvshow_detail_page.dart';
import 'package:core/features/tvshow/presentation/provider/tvshow_detail_notifier.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tvshow_detail_page_test.mocks.dart';

@GenerateMocks([TvShowDetailNotifier])
void main() {
  late MockTvShowDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvShowDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvShowDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tvshow not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvshowState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvshow).thenReturn(testTvShowDetail);
    when(mockNotifier.tvshowRecommendationsState)
        .thenReturn(RequestState.Loaded);
    when(mockNotifier.tvshowRecommendations).thenReturn(<TvShow>[]);
    when(mockNotifier.addToWatchlistStatus).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvShowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when tvshow is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.tvshowState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvshow).thenReturn(testTvShowDetail);
    when(mockNotifier.tvshowRecommendationsState)
        .thenReturn(RequestState.Loaded);
    when(mockNotifier.tvshowRecommendations).thenReturn(<TvShow>[]);
    when(mockNotifier.addToWatchlistStatus).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvShowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvshowState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvshow).thenReturn(testTvShowDetail);
    when(mockNotifier.tvshowRecommendationsState)
        .thenReturn(RequestState.Loaded);
    when(mockNotifier.tvshowRecommendations).thenReturn(<TvShow>[]);
    when(mockNotifier.addToWatchlistStatus).thenReturn(false);
    when(mockNotifier.watchListmessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvShowDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.tvshowState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvshow).thenReturn(testTvShowDetail);
    when(mockNotifier.tvshowRecommendationsState)
        .thenReturn(RequestState.Loaded);
    when(mockNotifier.tvshowRecommendations).thenReturn(<TvShow>[]);
    when(mockNotifier.addToWatchlistStatus).thenReturn(false);
    when(mockNotifier.watchListmessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvShowDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}

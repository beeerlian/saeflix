import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:search/features/tvshow/domain/usecases/search_tvshow.dart';

class TvShowSearchNotifier extends ChangeNotifier {
  final SearchTvShow searchTvShows;

  TvShowSearchNotifier({required this.searchTvShows});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _searchResult = [];
  List<TvShow> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvShowSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTvShows.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}

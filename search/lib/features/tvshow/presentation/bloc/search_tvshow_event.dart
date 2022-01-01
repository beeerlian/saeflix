part of 'search_tvshow_bloc.dart';

@immutable
abstract class SearchTvshowEvent extends Equatable {
  const SearchTvshowEvent();

  @override
  List<Object?> get props => [];
}

class OnTvShowQueryChanged extends SearchTvshowEvent {
  String query;

  OnTvShowQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

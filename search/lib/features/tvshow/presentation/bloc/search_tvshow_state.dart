part of 'search_tvshow_bloc.dart';

@immutable
abstract class SearchTvshowState extends Equatable {
  const SearchTvshowState();

  @override
  List<Object?> get props => [];
}

class SearchTvShowEmpty extends SearchTvshowState {}

class SearchTvShowLoading extends SearchTvshowState {}

class SearchTvShowError extends SearchTvshowState {
  String message;

  SearchTvShowError(this.message);
  @override
  List<Object?> get props => [message];
}

class SearchTvShowHasData extends SearchTvshowState {
  List<TvShow> results;

  SearchTvShowHasData(this.results);

  @override
  List<Object?> get props => [results];
}

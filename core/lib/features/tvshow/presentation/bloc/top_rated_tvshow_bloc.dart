import 'package:bloc/bloc.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_top_rated_tvshow.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tvshow_event.dart';
part 'top_rated_tvshow_state.dart';

class AllTopRatedTvShowsBloc
    extends Bloc<TopRatedTvShowsEvent, TopRatedTvShowsState> {
  final GetTopRatedTvShow _getTopRatedTvShows;

  AllTopRatedTvShowsBloc(this._getTopRatedTvShows)
      : super(TopRatedTvShowsLoading());

  @override
  Stream<TopRatedTvShowsState> mapEventToState(
      TopRatedTvShowsEvent event) async* {
    if (event is FetchAllTopRatedTvShows) {
      yield TopRatedTvShowsLoading();

      final result = await _getTopRatedTvShows.execute();

      yield* result.fold((failure) async* {
        yield TopRatedTvShowsFailed(failure.message);
      }, (moviesData) async* {
        yield TopRatedTvShowsLoaded(moviesData);
      });
    }
  }
}

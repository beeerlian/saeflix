import 'package:bloc/bloc.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_popular_tvshow.dart';
import 'package:equatable/equatable.dart';

part 'popular_tvshow_event.dart';
part 'popular_tvshow_state.dart';

class AllPopularTvShowsBloc
    extends Bloc<PopularTvShowsEvent, PopularTvShowsState> {
  final GetPopularTvShow _getPopularTvShows;

  AllPopularTvShowsBloc(this._getPopularTvShows)
      : super(PopularTvShowsLoading());

  @override
  Stream<PopularTvShowsState> mapEventToState(
      PopularTvShowsEvent event) async* {
    if (event is FetchAllPopularTvShows) {
      yield PopularTvShowsLoading();

      final result = await _getPopularTvShows.execute();

      yield* result.fold((failure) async* {
        yield PopularTvShowsFailed(failure.message);
      }, (moviesData) async* {
        yield PopularTvShowsLoaded(moviesData);
      });
    }
  }
}

import 'package:core/features/tvshow/domain/repositories/tvshow_repository.dart';

class GetTvShowWatchListStatus {
  final TvShowRepository repository;

  GetTvShowWatchListStatus(this.repository);
  
  Future<bool> execute(int id) {
    return repository.getTvShowWatchListStatus(id);
  }
}

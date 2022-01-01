import 'package:core/features/movies/domain/entities/movie_detail.dart';
import 'package:core/features/movies/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class RemoveWatchlist {
  final MovieRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}

import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}

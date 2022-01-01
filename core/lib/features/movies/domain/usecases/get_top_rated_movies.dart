import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTopRatedMovies {
  final MovieRepository repository;

  GetTopRatedMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getTopRatedMovies();
  }
}

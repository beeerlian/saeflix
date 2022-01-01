import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}

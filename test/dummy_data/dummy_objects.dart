import 'package:core/features/movies/data/models/movie_table.dart';
import 'package:core/features/movies/domain/entities/genre.dart';
import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/entities/movie_detail.dart';
import 'package:core/features/tvshow/data/models/tvshow_table.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_detail.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_genre.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testMovieCache = MovieTable(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testMovieCacheMap = {
  'id': 557,
  'overview':
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  'title': 'Spider-Man',
};

final testMovieFromCache = Movie.watchlist(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

// TvShow Dummy Object--------------------------------------------------------------------

final testTvShow = TvShow(
  id: 1,
  posterPath: "posterPath",
  backdropPath: "backdropPath",
  voteAverage: 2.0,
  overview: "overview",
  firstAirDate: "firstAirDate",
  originCountry: ["originCountry"],
  genreIds: [1, 2],
  originalLanguage: "originalLanguage",
  voteCount: 24,
  name: "name",
  originalName: "originalName",
);

final testTvShowList = [testTvShow];

final testTvShowDetail = TvShowDetail(
  posterPath: "posterpath.jpg",
  id: 1,
  backdropPath: "backdropPath",
  voteAverage: 2.0,
  overview: "overview",
  firstAirDate: "firstAirDate",
  originCountry: ["originCountry"],
  genres: [TvShowGenre(id: 1, name: "genre name")],
  originalLanguage: "originalLanguage",
  voteCount: 24,
  name: "name",
  originalName: "originalName",
);

final testTvShowTable = TvShowTable(
  id: 1,
  name: "name",
  posterPath: "posterPath",
  overview: "overview",
);

final testTvShowMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

final testTvShowCache = TvShowTable(
  id: 1,
  name: "name",
  posterPath: "posterPath",
  overview: "overview",
);

final testWatchlistTvShow = TvShow.watchlist(
  id: 1,
  posterPath: "posterPath",
  overview: "overview",
  name: "name",
);

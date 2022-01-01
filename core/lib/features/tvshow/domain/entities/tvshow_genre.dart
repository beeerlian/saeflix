import 'package:equatable/equatable.dart';

class TvShowGenre extends Equatable {
  TvShowGenre({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
import 'package:core/features/tvshow/domain/entities/tvshow_genre.dart';
import 'package:equatable/equatable.dart';

class TvShowGenreModel extends Equatable {
  final int id;
  final String name;

  TvShowGenreModel({required this.id, required this.name});

  factory TvShowGenreModel.fromJson(Map<String, dynamic> json) =>
      TvShowGenreModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  TvShowGenre toEntity() {
    return TvShowGenre(id: this.id, name: this.name);
  }

  @override
  List<Object?> get props => [id, name];
}

import 'package:core/features/tvshow/data/models/tvshow_model.dart';
import 'package:equatable/equatable.dart';

class TvShowResponse extends Equatable {
  final List<TvShowModel> tvShowList;

  TvShowResponse({required this.tvShowList});

  factory TvShowResponse.fromJson(Map<String, dynamic> json) {
    return TvShowResponse(
        tvShowList: List<TvShowModel>.from((json["results"] as List<dynamic>)
            .map((e) => TvShowModel.fromJson(e))
            .where((element) => element.posterPath != null)));
  }

  Map<String, dynamic> toJson() {
    return {
      "results": List<dynamic>.from(tvShowList.map((e) => e.toJson())),
    };
  }

  @override
  List<Object?> get props => [tvShowList];
}

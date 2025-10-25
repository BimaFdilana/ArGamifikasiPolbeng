// Hapus 'ignore' di atas jika ada

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'badge_model.dart';

part 'mission_model.freezed.dart';
part 'mission_model.g.dart';

@freezed
class Mission with _$Mission {
  const factory Mission({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String description,
    @JsonKey(name: 'points_reward')
    @Default(0)
    int pointsReward,

    Badge? badge,
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);
}

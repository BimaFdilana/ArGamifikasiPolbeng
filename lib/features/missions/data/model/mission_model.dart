import 'package:freezed_annotation/freezed_annotation.dart';
import 'badge_model.dart';

part 'mission_model.freezed.dart';
part 'mission_model.g.dart';

@freezed
class Mission with _$Mission {
  const factory Mission({
    required int id,
    required String title,
    required String description,
    required int pointsReward,
    Badge? badge,
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);
}

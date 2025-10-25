// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_model.freezed.dart';
part 'badge_model.g.dart';

@freezed
class Badge with _$Badge {
  const factory Badge({
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'icon_url') @Default('') String iconUrl,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) =>
      _$BadgeFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';

part 'word_model.g.dart';

enum Level {
  beginner,
  intermediate,
  advanced,
}

@JsonSerializable()
class WordModel {
  @JsonKey(name: '_id')
  String id;
  String word;
  String meaning;
  String pronunciation;
  String example;
  Level level;

  WordModel({
    required this.id,
    required this.word,
    required this.meaning,
    required this.pronunciation,
    required this.example,
    required this.level,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) => _$WordModelFromJson(json);
  Map<String, dynamic> toJson() => _$WordModelToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordModel _$WordModelFromJson(Map<String, dynamic> json) => WordModel(
      id: json['_id'] as String,
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      pronunciation: json['pronunciation'] as String,
      example: json['example'] as String,
      level: $enumDecode(_$LevelEnumMap, json['level']),
    );

Map<String, dynamic> _$WordModelToJson(WordModel instance) => <String, dynamic>{
      '_id': instance.id,
      'word': instance.word,
      'meaning': instance.meaning,
      'pronunciation': instance.pronunciation,
      'example': instance.example,
      'level': _$LevelEnumMap[instance.level],
    };

const _$LevelEnumMap = {
  Level.beginner: 'beginner',
  Level.intermediate: 'intermediate',
  Level.advanced: 'advanced',
};

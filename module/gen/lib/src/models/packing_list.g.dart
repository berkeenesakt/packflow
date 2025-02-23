// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackingList _$PackingListFromJson(Map<String, dynamic> json) => PackingList(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      departureDate: json['departureDate'] == null
          ? null
          : DateTime.parse(json['departureDate'] as String),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => PackingCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PackingListToJson(PackingList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'departureDate': instance.departureDate?.toIso8601String(),
      'categories': instance.categories,
    };

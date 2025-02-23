// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackingCategory _$PackingCategoryFromJson(Map<String, dynamic> json) =>
    PackingCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => PackingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$PackingCategoryToJson(PackingCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': instance.items,
      'icon': instance.icon,
    };

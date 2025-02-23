// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackingItem _$PackingItemFromJson(Map<String, dynamic> json) => PackingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PackingItemToJson(PackingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isChecked': instance.isChecked,
      'quantity': instance.quantity,
      'notes': instance.notes,
    };

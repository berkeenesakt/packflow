// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PackingListAdapter extends TypeAdapter<PackingList> {
  @override
  final int typeId = 2;

  @override
  PackingList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PackingList(
      id: fields[0] as String,
      name: fields[1] as String,
      createdAt: fields[3] as DateTime,
      description: fields[2] as String?,
      departureDate: fields[4] as DateTime?,
      returnDate: fields[5] as DateTime?,
      items: (fields[6] as List?)?.cast<PackingItem>(),
      checkedItems: (fields[7] as List?)?.cast<PackingItem>(),
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PackingList obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.departureDate)
      ..writeByte(5)
      ..write(obj.returnDate)
      ..writeByte(6)
      ..write(obj.items)
      ..writeByte(7)
      ..write(obj.checkedItems)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackingListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackingList _$PackingListFromJson(Map<String, dynamic> json) => PackingList(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
      departureDate: json['departureDate'] == null
          ? null
          : DateTime.parse(json['departureDate'] as String),
      returnDate: json['returnDate'] == null
          ? null
          : DateTime.parse(json['returnDate'] as String),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => PackingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      checkedItems: (json['checkedItems'] as List<dynamic>?)
          ?.map((e) => PackingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PackingListToJson(PackingList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'departureDate': instance.departureDate?.toIso8601String(),
      'returnDate': instance.returnDate?.toIso8601String(),
      'items': instance.items,
      'checkedItems': instance.checkedItems,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

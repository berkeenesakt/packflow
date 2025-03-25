import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'packing_item.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class PackingItem extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int quantity;
  @HiveField(3)
  final String? notes;
  @HiveField(4)
  final String categoryId;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;
  const PackingItem({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.quantity = 1,
    this.notes,
  });

  factory PackingItem.fromJson(Map<String, dynamic> json) => _$PackingItemFromJson(json);
  Map<String, dynamic> toJson() => _$PackingItemToJson(this);

  PackingItem copyWith({
    String? id,
    String? name,
    int? quantity,
    String? notes,
    String? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PackingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, quantity, notes, categoryId];
}

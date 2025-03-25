import 'package:equatable/equatable.dart';
import 'package:gen/src/models/packing_item.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'packing_list.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class PackingList extends Equatable {
  PackingList({
    required this.id,
    required this.name,
    required this.createdAt,
    this.description,
    this.departureDate,
    this.returnDate,
    List<PackingItem>? items,
    List<PackingItem>? checkedItems,
    DateTime? updatedAt,
  })  : items = items ?? const [],
        checkedItems = checkedItems ?? const [],
        updatedAt = updatedAt ?? DateTime.now();

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime? departureDate;
  @HiveField(5)
  final DateTime? returnDate;
  @HiveField(6)
  final List<PackingItem> items;
  @HiveField(7)
  final List<PackingItem> checkedItems;
  @HiveField(8)
  final DateTime updatedAt;
  int get totalItems => items.length;

  int get checkedItemsCount => checkedItems.length;

  double get progress => totalItems == 0 ? 0 : checkedItemsCount / totalItems;

  factory PackingList.fromJson(Map<String, dynamic> json) => _$PackingListFromJson(json);
  Map<String, dynamic> toJson() => _$PackingListToJson(this);

  PackingList copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? departureDate,
    DateTime? returnDate,
    List<PackingItem>? items,
    List<PackingItem>? checkedItems,
    DateTime? updatedAt,
  }) {
    return PackingList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      items: items ?? this.items,
      checkedItems: checkedItems ?? this.checkedItems,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, createdAt, departureDate, returnDate, items];
}

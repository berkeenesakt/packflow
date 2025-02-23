import 'package:equatable/equatable.dart';
import 'package:gen/src/models/packing_category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'packing_list.g.dart';

@JsonSerializable()
class PackingList extends Equatable {
  const PackingList({
    required this.id,
    required this.name,
    required this.createdAt,
    this.description,
    this.departureDate,
    List<PackingCategory>? categories,
  }) : categories = categories ?? const [];

  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime? departureDate;
  final List<PackingCategory> categories;

  int get totalItems => categories.fold<int>(0, (sum, category) => sum + category.items.length);

  int get checkedItems => categories.fold<int>(
        0,
        (sum, category) => sum + category.items.where((item) => item.isChecked).length,
      );

  double get progress => totalItems == 0 ? 0 : checkedItems / totalItems;

  factory PackingList.fromJson(Map<String, dynamic> json) => _$PackingListFromJson(json);
  Map<String, dynamic> toJson() => _$PackingListToJson(this);

  PackingList copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? departureDate,
    List<PackingCategory>? categories,
  }) {
    return PackingList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      departureDate: departureDate ?? this.departureDate,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [id, name, description, createdAt, departureDate, categories];
}

import 'package:equatable/equatable.dart';
import 'package:gen/src/models/packing_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'packing_category.g.dart';

@JsonSerializable()
class PackingCategory extends Equatable {
  const PackingCategory({
    required this.id,
    required this.name,
    List<PackingItem>? items,
    this.icon,
  }) : items = items ?? const [];

  final String id;
  final String name;
  final List<PackingItem> items;
  final String? icon;

  factory PackingCategory.fromJson(Map<String, dynamic> json) => _$PackingCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$PackingCategoryToJson(this);

  PackingCategory copyWith({
    String? id,
    String? name,
    List<PackingItem>? items,
    String? icon,
  }) {
    return PackingCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [id, name, items, icon];
}

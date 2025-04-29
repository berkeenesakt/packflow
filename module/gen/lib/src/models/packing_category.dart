import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'packing_category.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class PackingCategory extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final DateTime? createdAt;

  const PackingCategory({
    required this.id,
    required this.name,
    this.createdAt,
  });

  factory PackingCategory.fromJson(Map<String, dynamic> json) => _$PackingCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$PackingCategoryToJson(this);

  PackingCategory copyWith({String? id, String? name}) {
    return PackingCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}

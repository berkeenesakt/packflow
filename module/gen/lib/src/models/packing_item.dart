import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'packing_item.g.dart';

@JsonSerializable()
class PackingItem extends Equatable {
  const PackingItem({
    required this.id,
    required this.name,
    this.isChecked = false,
    this.quantity = 1,
    this.notes,
  });

  final String id;
  final String name;
  final bool isChecked;
  final int quantity;
  final String? notes;

  factory PackingItem.fromJson(Map<String, dynamic> json) => _$PackingItemFromJson(json);
  Map<String, dynamic> toJson() => _$PackingItemToJson(this);

  PackingItem copyWith({
    String? id,
    String? name,
    bool? isChecked,
    int? quantity,
    String? notes,
  }) {
    return PackingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isChecked: isChecked ?? this.isChecked,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, name, isChecked, quantity, notes];
}

import 'package:sortirin/features/rewards/domain/entities/reward_entity.dart';

class RewardModel {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final String category;
  final int pointsCost;
  final int stock;
  final bool isActive;

  const RewardModel({
    required this.id, required this.name, required this.description,
    this.imageUrl, required this.category, required this.pointsCost,
    this.stock = 0, this.isActive = true,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    imageUrl: json['image_url'] as String?,
    category: json['category'] as String? ?? 'general',
    pointsCost: json['points_cost'] as int? ?? 0,
    stock: json['stock'] as int? ?? 0,
    isActive: json['is_active'] as bool? ?? true,
  );

  RewardEntity toEntity() => RewardEntity(
    id: id, name: name, description: description, imageUrl: imageUrl,
    category: category, pointsCost: pointsCost, stock: stock, isActive: isActive,
  );
}

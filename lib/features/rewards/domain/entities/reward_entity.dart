/// A redeemable reward item.
class RewardEntity {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final String category;
  final int pointsCost;
  final int stock;
  final bool isActive;

  const RewardEntity({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.pointsCost,
    this.stock = 0,
    this.isActive = true,
  });

  bool get isOutOfStock => stock <= 0;
}

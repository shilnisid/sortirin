import 'package:sortirin/features/submission/domain/entities/submission_item_entity.dart';

/// JSON-serializable model for a submission item.
class SubmissionItemModel {
  final int? id;
  final int? submissionId;
  final int wasteTypeId;
  final int quantity;
  final int basePoints;

  const SubmissionItemModel({
    this.id,
    this.submissionId,
    required this.wasteTypeId,
    required this.quantity,
    this.basePoints = 0,
  });

  factory SubmissionItemModel.fromJson(Map<String, dynamic> json) {
    return SubmissionItemModel(
      id: json['id'] as int?,
      submissionId: json['submission_id'] as int?,
      wasteTypeId: json['waste_type_id'] as int,
      quantity: json['quantity'] as int,
      basePoints: json['base_points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (submissionId != null) 'submission_id': submissionId,
        'waste_type_id': wasteTypeId,
        'quantity': quantity,
        'base_points': basePoints,
      };

  SubmissionItemEntity toEntity() => SubmissionItemEntity(
        wasteTypeId: wasteTypeId,
        quantity: quantity,
        basePoints: basePoints,
      );

  factory SubmissionItemModel.fromEntity(SubmissionItemEntity entity) {
    return SubmissionItemModel(
      wasteTypeId: entity.wasteTypeId ?? 0,
      quantity: entity.quantity,
      basePoints: entity.basePoints,
    );
  }
}

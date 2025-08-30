import 'package:pillie/utils/helper_functions.dart';

class PillModel {
  String? id;
  String? name;
  String? brand;
  int? count;
  int? resetDays;
  bool? day;
  bool? noon;
  bool? night;
  double? dosage;
  String? userId;
  bool? isArchived;
  String? createdAt;
  String? modifiedAt;

  PillModel({
    this.id,
    this.name,
    this.brand,
    this.count,
    this.resetDays,
    this.day,
    this.noon,
    this.night,
    this.dosage,
    this.isArchived,
    this.userId,
    this.createdAt,
    this.modifiedAt,
  });

  factory PillModel.fromMap(Map<String, dynamic> map) {
    return PillModel(
      id: map["id"] as String,
      name: map["name"] as String,
      brand: sanitizeValue<String>(map["brand"]),
      userId: map["user_id"] as String,
      count: sanitizeValue<dynamic>(map["count"]),
      day: map["day"] as bool,
      noon: map["noon"] as bool,
      night: map["night"] as bool,
      dosage: sanitizeValue<double>(map["dosage"]),
      resetDays: sanitizeValue<dynamic>(map["reset_in_days"]),
      isArchived: map["is_archived"] as bool,
      createdAt: map["created_at"],
      modifiedAt: map["modified_at"],
    );
  }

  Map<String, dynamic> toMap(String? userId) {
    return {
      "name": name,
      "brand": brand,
      "count": count,
      "user_id": userId,
      "day": day,
      "noon": noon,
      "night": night,
      "dosage": dosage,
      "reset_in_days": resetDays,
    };
  }
}

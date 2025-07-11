import 'package:pillie/utils/helper_functions.dart';

class UserModel {
  String? id;
  String? name;
  String? img;
  int? height;
  int? weight;
  String? dob;
  String? bloodGroup;
  String? medications;
  String? medicalNotes;
  String? organDonor;
  String? createdAt;
  String? modifiedAt;

  UserModel({
    this.id,
    this.name,
    this.img,
    this.height,
    this.weight,
    this.dob,
    this.bloodGroup,
    this.medications,
    this.medicalNotes,
    this.organDonor,
    this.createdAt,
    this.modifiedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"] as String,
      name: map["name"] as String,
      img: sanitizeValue<String>(map["img"]),
      height: sanitizeValue<dynamic>(map["height"]),
      weight: sanitizeValue<dynamic>(map["weight"]),
      dob: sanitizeValue<String>(map["dob"]),
      bloodGroup: sanitizeValue<String>(map["blood_group"]),
      medications: sanitizeValue<String>(map["medications"]),
      medicalNotes: sanitizeValue<String>(map["medical_notes"]),
      organDonor: sanitizeValue<String>(map["organ_donor"]),
      createdAt: map["created_at"],
      modifiedAt: map["modified_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "img": img,
      "height": height,
      "weight": weight,
      "dob": dob != null ? convertDateFormat(dob!) : null,
      "blood_group": bloodGroup,
      "medications": medications,
      "medical_notes": medicalNotes,
      "organ_donor": organDonor,
    };
  }
}

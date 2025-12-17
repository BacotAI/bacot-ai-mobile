import '../../domain/entities/sample_user.dart';

class SampleUserModel extends SampleUser {
  const SampleUserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory SampleUserModel.fromJson(Map<String, dynamic> json) {
    return SampleUserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? token;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'token': token,
    };
  }

  // Dummy factory for testing
  factory UserModel.dummy() {
    return const UserModel(
      id: 'dummy_id_123',
      email: 'user@example.com',
      displayName: 'Test User',
      photoUrl: 'https://via.placeholder.com/150',
      token: 'dummy_token_abc',
    );
  }

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, token];
}

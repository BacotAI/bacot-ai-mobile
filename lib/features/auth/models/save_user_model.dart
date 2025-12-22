class SaveUserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  SaveUserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  factory SaveUserModel.fromJson(Map<String, dynamic> json) {
    return SaveUserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}

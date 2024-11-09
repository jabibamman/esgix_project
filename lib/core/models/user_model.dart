class UserModel {
  final String apiKey;
  final String avatar;
  final String collectionId;
  final String collectionName;
  final String created;
  final String description;
  final String email;
  final bool emailVisibility;
  final String id;
  final String updated;
  final String username;
  final bool verified;

  UserModel({
    required this.apiKey,
    required this.avatar,
    required this.collectionId,
    required this.collectionName,
    required this.created,
    required this.description,
    required this.email,
    required this.emailVisibility,
    required this.id,
    required this.updated,
    required this.username,
    required this.verified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      apiKey: json['api_key'],
      avatar: json['avatar'],
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      created: json['created'],
      description: json['description'] ?? '',
      email: json['email'],
      emailVisibility: json['emailVisibility'] ?? false,
      id: json['id'],
      updated: json['updated'],
      username: json['username'],
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'api_key': apiKey,
      'avatar': avatar,
      'collectionId': collectionId,
      'collectionName': collectionName,
      'created': created,
      'description': description,
      'email': email,
      'emailVisibility': emailVisibility,
      'id': id,
      'updated': updated,
      'username': username,
      'verified': verified,
    };
  }
}
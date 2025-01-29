class UserModel {
  final String? apiKey;
  final String? avatar;
  final String? collectionId;
  final String? collectionName;
  final String? created;
  final String description;
  final String email;
  final bool? emailVisibility;
  final String? id;
  final String? updated;
  final String username;
  final String? password;
  final bool? verified;

  UserModel({
    this.apiKey,
    this.avatar = '',
    this.collectionId,
    this.collectionName,
    this.created,
    this.description = '',
    this.email = '',
    this.emailVisibility,
    this.id,
    this.updated,
    required this.username,
    this.password,
    this.verified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      apiKey: json['api_key'],
      avatar: json['avatar'],
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      created: json['created'],
      description: json['description'] ?? '',
      email: json['email'] = '',
      emailVisibility: json['emailVisibility'] ?? false,
      id: json['id'],
      updated: json['updated'],
      username: json['username'],
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      if (password != null) 'password': password,
      if (avatar != null) 'avatar': avatar,
      if (apiKey != null) 'api_key': apiKey,
      if (collectionId != null) 'collectionId': collectionId,
      if (collectionName != null) 'collectionName': collectionName,
      if (created != null) 'created': created,
      if (description.isNotEmpty) 'description': description,
      if (emailVisibility != null) 'emailVisibility': emailVisibility,
      if (id != null) 'id': id,
      if (updated != null) 'updated': updated,
      if (verified != null) 'verified': verified,
    };
  }
}
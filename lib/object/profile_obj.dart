class ProfileInfo {
  final String name;
  final List<String> addresses;
  final String imagePath;

  ProfileInfo({
    required this.name,
    required this.addresses,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'addresses': addresses,
      'imagePath': imagePath,
    };
  }

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      name: json['name'],
      addresses: List<String>.from(json['addresses']),
      imagePath: json['imagePath'],
    );
  }
}
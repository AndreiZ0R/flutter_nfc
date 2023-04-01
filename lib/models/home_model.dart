class HomeModel {
  final String name;
  final DateTime lastChecked;
  final String location;
  final String owner;
  bool isLocked;

  HomeModel({
    required this.name,
    required this.lastChecked,
    required this.isLocked,
    required this.location,
    required this.owner,
  });

  factory HomeModel.empty() {
    return HomeModel(
      name: '?',
      lastChecked: DateTime.now(),
      isLocked: false,
      location: '?',
      owner: '?',
    );
  }

  Map<String, String> toJson() {
    return {
      'name': name,
      'location': location,
      'owner': owner,
      'isLocked': isLocked ? 'true' : 'false',
      'lastChecked': lastChecked.toString()
    };
  }

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      name: json['name']!,
      lastChecked: DateTime.parse(json['lastChecked']!),
      isLocked: json['isLocked'] == 'true' ? true : false,
      location: json['location']!,
      owner: json['owner']!,
    );
  }

  bool equals(HomeModel home) {
    if (name != home.name) return false;
    if (owner != home.owner) return false;
    if (location != home.location) return false;
    if (isLocked != home.isLocked) return false;
    if (lastChecked != home.lastChecked) return false;

    return true;
  }
}

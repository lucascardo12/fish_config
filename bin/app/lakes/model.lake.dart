class ModelLake {
  static String get collectionId => 'lakes';
  String? id;
  String name;
  ModelLake({this.id, required this.name});

  ModelLake.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['_id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['name'] = name;
    return data;
  }
}

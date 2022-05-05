class OceanModel {
  static String get collectionId => 'oceans';
  String? id;
  String name;
  OceanModel({this.id, required this.name});

  OceanModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['_id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['name'] = name;
    return data;
  }
}

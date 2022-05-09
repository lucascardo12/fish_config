class ModelFish {
  static String get collectionId => 'fishes';
  String? id;
  String name;
  dynamic valor;
  String idLake;

  ModelFish({
    this.id,
    required this.idLake,
    required this.name,
    required this.valor,
  });

  ModelFish.fromJson(dynamic json)
      : name = json['name'],
        valor = json['valor'],
        idLake = json['idLake'],
        id = json['_id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['name'] = name;
    data['valor'] = valor;
    data['idLake'] = idLake;
    return data;
  }
}

class FishModel {
  static String get collectionId => 'fishes';
  String? id;
  String name;
  dynamic valor;
  String idOcean;

  FishModel({
    this.id,
    required this.idOcean,
    required this.name,
    required this.valor,
  });

  FishModel.fromJson(dynamic json)
      : name = json['name'],
        valor = json['valor'],
        idOcean = json['idOcean'],
        id = json['_id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['name'] = name;
    data['valor'] = valor;
    data['idOcean'] = idOcean;
    return data;
  }
}

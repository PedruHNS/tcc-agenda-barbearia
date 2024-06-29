// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final String type;
  ProductModel({
    required this.id,
    required this.type,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': name,
      'preco': price,
      'tipo': type,
    };
  }

  factory ProductModel.fromMap(
      {required Map<dynamic, dynamic> map, required String id}) {
    return ProductModel(
      id: id,
      name: map['nome'] ?? '',
      price: double.parse(map['preco'].toString()),
      type: map['tipo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return '''ProductModel(
      id: $id, 
      name: $name, 
      price: $price, 
      type: $type)''';
  }
}

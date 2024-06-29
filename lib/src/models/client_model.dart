// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClientModel {
  final String id;
  final String dateOfBirth;
  final String phone;
  final String email;
  final String name;
  ClientModel({
    required this.id,
    required this.dateOfBirth,
    required this.phone,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'data_nascimento': dateOfBirth,
      'celular': phone,
      'email': email,
      'nome': name,
    };
  }

  factory ClientModel.fromMap(
      {required Map<dynamic, dynamic> map, required String id}) {
    return ClientModel(
      id: id,
      dateOfBirth: map['data_nascimento'] ?? '',
      phone: map['celular'] ?? '',
      email: map['email'] ?? '',
      name: map['nome'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return '''ClientModel(
      id: $id, 
      dateOfBirth: $dateOfBirth, 
      phone: $phone, 
      email: $email, 
      name: $name)''';
  }
}

import 'dart:convert';

class EmployeeModel {
  final String? id;
  final String? image;
  final String name;
  final String phone;
  final String email;

  EmployeeModel({
    this.image,
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'foto': image,
      'nome': name,
      'celular': phone,
      'email': email,
    };

    if (id != null) {
      map['id'] = id;
    }

    if (image != null) {
      map['foto'] = image;
    }

    return map;
  }

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromMap({
    required Map<dynamic, dynamic> map,
    required String id,
  }) {
    return EmployeeModel(
      id: id,
      image: map['foto'] as String?,
      name: map['nome'] ?? '',
      phone: map['celular'] ?? '',
      email: map['email'] ?? '',
    );
  }

  factory EmployeeModel.fromJson(String source) {
    return EmployeeModel.fromMap(
      map: json.decode(source),
      id: json.decode(source)['id'],
    );
  }

  @override
  String toString() {
    return '''EmployeeModel(
      id: $id,
      image: $image, 
      name: $name, 
      phone: $phone, 
      email: $email)''';
  }
}

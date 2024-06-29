import 'dart:convert';

class BarbershopModel {
  final bool isOpen;
  final List<String> openDays;
  final List<String> openHours;
  final String name;

  BarbershopModel({
    required this.name,
    required this.isOpen,
    required this.openDays,
    required this.openHours,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'aberto': isOpen,
      'diasFuncionamento': openDays,
      'horasFuncionamento': openHours,
    };
  }

  factory BarbershopModel.fromMap(Map<String, dynamic> map) {
    return BarbershopModel(
      name: map['nome'] ?? '',
      isOpen: map['aberto'] ?? false,
      openDays:
          List<String>.from((map['diasFuncionamento'] ?? const <String>[])),
      openHours:
          List<String>.from((map['horasFuncionamento'] ?? const <String>[])),
    );
  }

  String toJson() => json.encode(toMap());

  factory BarbershopModel.fromJson(String source) =>
      BarbershopModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      '''BarbershopModel(
          isOpen: $isOpen, 
          openDays: $openDays, 
          openHours: $openHours
          )''';
}

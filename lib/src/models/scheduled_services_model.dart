// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:barbershop_schedule/src/models/client_model.dart';
import 'package:barbershop_schedule/src/models/employee_model.dart';
import 'package:barbershop_schedule/src/models/product.dart';

class ScheduledServicesModel {
  final String? id;
  final EmployeeModel employee;
  final ClientModel client;
  final List<ProductModel> products;
  final String date;
  final String hour;
  final String status;

  ScheduledServicesModel({
    this.id,
    required this.employee,
    required this.client,
    required this.products,
    required this.date,
    required this.hour,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'barbeiro': employee.toMap(),
      'cliente': client.toMap(),
      'servicos': products.map((product) => product.toMap()).toList(),
      'data': date,
      'hora': hour,
      'status': status,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory ScheduledServicesModel.fromMap({
    required Map<dynamic, dynamic> map,
    required String id,
  }) {
    return ScheduledServicesModel(
      id: id,
      date: map['data'] ?? '',
      hour: map['hora'] ?? '',
      status: map['status'] ?? '',
      employee: EmployeeModel.fromMap(
          map: map['barbeiro'], id: map['barbeiro']['id']),
      client:
          ClientModel.fromMap(map: map['cliente'], id: map['cliente']['id']),
      products: List<ProductModel>.from(
        map['servicos']
                .map(
                  (dynamic product) => ProductModel.fromMap(
                    map: product,
                    id: product['id'],
                  ),
                )
                .toList() ??
            const <ProductModel>[],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => '''
  ScheduledServicesModel(
  id: $id
  employee: $employee)
  client: $client
  products: $products,
  date: $date,
  hour: $hour,
  status: $status
  )
  ''';
}

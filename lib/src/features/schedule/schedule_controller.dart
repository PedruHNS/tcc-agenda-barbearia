import 'package:barbershop_schedule/src/models/barbershop_model.dart';
import 'package:barbershop_schedule/src/models/client_model.dart';
import 'package:barbershop_schedule/src/models/employee_model.dart';
import 'package:barbershop_schedule/src/models/scheduled_services_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:barbershop_schedule/src/models/product.dart';
import 'package:barbershop_schedule/src/services/auth/i_auth_service.dart';

class ScheduleController extends ChangeNotifier {
  final IAuthService authService;
  final database = FirebaseDatabase.instance;
  String? errorMessage;
  List<ProductModel> products = [];
  List<int> unavailableHours = [];
  BarbershopModel? barbershop;

  ScheduleController({required this.authService});

  void getproducts() {
    database.ref('servicos').onValue.listen((event) {
      final snapshot = event.snapshot;

      final productMap = snapshot.value as Map;

      products.clear();

      productMap.forEach((key, value) {
        final product =
            ProductModel.fromMap(map: value as Map<dynamic, dynamic>, id: key);

        if (product.type == 'Barbearia') {
          products.add(product);
          notifyListeners();
        }
      });
    });
  }

  Future<void> getBarberInfos() async {
    const path = 'barbearia/-NyuqtGr_WyCGrmZk_oz';
    final snapshot = await database.ref(path).get();

    if (snapshot.value != null) {
      final barbershopMap = snapshot.value as Map;
      barbershop = BarbershopModel.fromMap(
        barbershopMap.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      );
      notifyListeners();
      database.ref(path).onValue.listen((event) {
        final snapshot = event.snapshot;

        final barbershopMap = snapshot.value as Map;

        barbershop = BarbershopModel.fromMap(
          barbershopMap.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
        if (hasListeners) {
          notifyListeners();
        }
      });
    }
  }

  void getUnavailableHours({required String employeeId, required String date}) {
    database.ref('agenda').onValue.listen((event) {
      final snapshot = event.snapshot;

      final scheduledServicesMap = snapshot.value as Map;

      unavailableHours.clear();
      scheduledServicesMap.forEach((key, value) {
        final scheduledService =
            ScheduledServicesModel.fromMap(map: value, id: key);

        if (scheduledService.employee.id == employeeId &&
            scheduledService.date == date &&
            scheduledService.status == 'agendado') {
          unavailableHours.add(int.parse(scheduledService.hour.split(':')[0]));
        }
      });
      if (hasListeners) {
        notifyListeners();
      }
    });
  }

  Future<void> markOnTheCalendar({
    required String date,
    required String hour,
    required String employeeId,
    required ProductModel product,
  }) async {
    final user = await authService.getUser();
    List<ScheduledServicesModel> schedulesService = [];

    final client = await database.ref('clientes/${user.uid}').get();
    final employee = await database.ref('equipe/$employeeId').get();
    final schedule = await database.ref('agenda').get();

    final scheduleMap = schedule.value as Map;
    schedulesService.clear();
    scheduleMap.forEach((key, value) {
      final schedule = ScheduledServicesModel.fromMap(map: value, id: key);

      if (schedule.client.id == user.uid && schedule.status == 'agendado') {
        schedulesService.add(schedule);
      }
    });

    if (schedulesService.isEmpty) {
      final scheduledService = ScheduledServicesModel(
        employee: EmployeeModel.fromMap(
          map: employee.value as Map<dynamic, dynamic>,
          id: employeeId,
        ),
        client: ClientModel.fromMap(
          map: client.value as Map<dynamic, dynamic>,
          id: user.uid,
        ),
        products: [product],
        date: date,
        hour: hour,
        status: 'agendado',
      );
      await database.ref('agenda').push().set(scheduledService.toMap());
    } else {
      errorMessage = 'Você já possui um agendamaneto';
    }
  }
}

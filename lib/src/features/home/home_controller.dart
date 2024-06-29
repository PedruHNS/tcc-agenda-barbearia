import 'package:barbershop_schedule/src/models/barbershop_model.dart';
import 'package:barbershop_schedule/src/models/employee_model.dart';
import 'package:barbershop_schedule/src/models/scheduled_services_model.dart';
import 'package:barbershop_schedule/src/services/auth/i_auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final IAuthService authService;
  final database = FirebaseDatabase.instance;
  var loading = false;
  bool _barbershopStatus = false;
  var barbershopName = '';
  List<EmployeeModel> employees = [];
  List<ScheduledServicesModel> services = [];

  set barbershopStatus(bool value) {
    _barbershopStatus = value;
    if (hasListeners) {
      notifyListeners();
    }
  }

  bool get barbershopStatus => _barbershopStatus;

  HomeController({required this.authService});

  Future<void> logout() async {
    loading = true;
    notifyListeners();
    await authService.logout();
    loading = false;
    notifyListeners();
  }

  void statusBarbershop() {
    database.ref('barbearia/-NyuqtGr_WyCGrmZk_oz').onValue.listen((event) {
      final snapshot = event.snapshot;

      final barbershopMap = snapshot.value as Map;

      final barbershop = BarbershopModel.fromMap(
          barbershopMap.map((key, value) => MapEntry(key.toString(), value)));

      barbershopStatus = barbershop.isOpen;
      barbershopName = barbershop.name;
    });
  }

  void getEmployee() async {
    loading = true;
    notifyListeners();

    database.ref('equipe').onValue.listen((event) {
      final snapshot = event.snapshot;

      final employeeMap = snapshot.value as Map;

      employees.clear();
      employeeMap.forEach((key, value) {
        final employee = EmployeeModel.fromMap(map: value, id: key);
        employees.add(employee);
        notifyListeners();
      });
    });
    loading = false;
    notifyListeners();
  }

  Future<void> getServiceHistory() async {
    final user = await authService.getUser();
    database.ref('agenda').onValue.listen((event) {
      final snapshot = event.snapshot;

      final serviceMap = snapshot.value as Map;

      services.clear();

      serviceMap.forEach((key, value) {
        final service = ScheduledServicesModel.fromMap(
            map: value as Map<dynamic, dynamic>, id: key);

        if (service.client.id == user.uid) {
          services.add(service);

          services.sort((a, b) => a.date.compareTo(b.date));
          services = services.reversed.toList();
          notifyListeners();
          return;
        }
      });
    });
  }
}

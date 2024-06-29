import 'package:barbershop_schedule/src/features/auth/forgot_password/forgot_password_controller.dart';
import 'package:barbershop_schedule/src/features/auth/forgot_password/forgot_password_page.dart';
import 'package:barbershop_schedule/src/features/auth/login/login_controller.dart';
import 'package:barbershop_schedule/src/features/auth/login/login_page.dart';
import 'package:barbershop_schedule/src/features/auth/register/register_controller.dart';
import 'package:barbershop_schedule/src/features/auth/register/register_user_page.dart';
import 'package:barbershop_schedule/src/features/cut_info/cut_info_page.dart';
import 'package:barbershop_schedule/src/features/cut_info/cut_info_controller.dart';
import 'package:barbershop_schedule/src/features/home/home_controller.dart';
import 'package:barbershop_schedule/src/features/home/home_page.dart';
import 'package:barbershop_schedule/src/features/schedule/schedule_controller.dart';
import 'package:barbershop_schedule/src/features/schedule/schedule_page.dart';
import 'package:barbershop_schedule/src/features/splash/splash_controller.dart';
import 'package:barbershop_schedule/src/features/splash/splash_page.dart';
import 'package:barbershop_schedule/src/models/employee_model.dart';
import 'package:barbershop_schedule/src/models/scheduled_services_model.dart';
import 'package:barbershop_schedule/src/services/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteApp {
  static Route<dynamic> defaultRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => SplashController(
              authService: context.read<FirebaseAuthService>(),
            ),
            child: const SplashPage(),
          ),
        );

      case '/auth/login':
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => LoginController(
              authService: context.read<FirebaseAuthService>(),
            ),
            child: const LoginPage(),
          ),
        );
      case '/auth/register/user':
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => RegisterController(
              context.read<FirebaseAuthService>(),
            ),
            child: const RegisterUserPage(),
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => HomeController(
              authService: context.read<FirebaseAuthService>(),
            )
              ..statusBarbershop()
              ..getEmployee(),
            child: const HomePage(),
          ),
        );
      case '/auth/forgot_password':
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ForgotPasswordController(
              authService: context.read<FirebaseAuthService>(),
            ),
            child: const ForgotPasswordPage(),
          ),
        );
      case '/schedule':
        return MaterialPageRoute(builder: (context) {
          final employee = settings.arguments as EmployeeModel;
          return ChangeNotifierProvider(
              create: (context) => ScheduleController(
                  authService: context.read<FirebaseAuthService>()),
              child: SchedulePage(employee: employee));
        });
      case '/info':
        return MaterialPageRoute(builder: (context) {
          final service = settings.arguments as ScheduledServicesModel;
          return ChangeNotifierProvider(
            create: (context) => CutInfoController(),
            child: CutInfoPage(scheduledServices: service),
          );
        });

      default:
        return MaterialPageRoute(builder: (context) => const SplashPage());
    }
  }
}

import 'package:barbershop_schedule/src/core/routes/route_app.dart';
import 'package:barbershop_schedule/src/core/ui/theme/theme_schedule_app.dart';
import 'package:barbershop_schedule/src/services/auth/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => FirebaseAuthService(
            auth: FirebaseAuth.instance,
            database: FirebaseDatabase.instance,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Flutter Demo',
        theme: ThemeScheduleApp.themeDefault,
        onGenerateRoute: RouteApp.defaultRoute,
      ),
    );
  }
}

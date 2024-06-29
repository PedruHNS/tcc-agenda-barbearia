import 'dart:async';
import 'dart:developer';

import 'package:barbershop_schedule/src/core/constants/constants.dart';

import 'package:barbershop_schedule/src/features/splash/splash_controller.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? timer;
  var endAnimation = false;
  var imageOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _animationLogo();
      final splashController = context.read<SplashController>();
      await splashController.checkUserStatus();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _animationLogo() {
    setState(() {
      imageOpacity = 1.0;
    });
  }

  void _redirect(String nameRouter) {
    if (!endAnimation) {
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 100), () {
        _redirect(nameRouter);
      });
    } else {
      timer?.cancel();
      switch (nameRouter) {
        case '/home':
          Navigator.of(context).pushReplacementNamed('/home');
          break;
        case '/auth/login':
          Navigator.of(context).pushReplacementNamed('/auth/login');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final splashController = context.watch<SplashController>();
    splashController.addListener(() {
      switch (splashController.islogged) {
        case true:
          _redirect('/home');
          log('User is logged: =======> ');
          break;
        case false:
          _redirect('/auth/login');
          log('User is not logged -------->');
          break;
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetsImage.background2),
              fit: BoxFit.cover,
              opacity: 0.3),
        ),
        child: Center(
          child: AnimatedOpacity(
            onEnd: () {
              setState(() {
                endAnimation = true;
              });
            },
            opacity: imageOpacity,
            duration: const Duration(milliseconds: 2000),
            child: Image.asset(
              AssetsImage.logoBarbearia,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

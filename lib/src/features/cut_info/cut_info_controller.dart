import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CutInfoController extends ChangeNotifier {
  final database = FirebaseDatabase.instance;

  void cancelService(String id) {
    database.ref('agenda/$id').update({'status': 'cancelado'});
  }
}

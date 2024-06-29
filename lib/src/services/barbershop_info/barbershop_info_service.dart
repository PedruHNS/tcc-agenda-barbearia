// import 'package:barbershop_schedule/src/models/barbershop_model.dart';
// import 'package:firebase_database/firebase_database.dart';

// class BarbershopInfoService {
//   final database = FirebaseDatabase.instance;
//   Stream<BarbershopModel> getBarbershopInfoStream() {
//     return database.ref('barbearia/-NyuqtGr_WyCGrmZk_oz').onValue.map((event) {
//       final map = event.snapshot.value as Map<String, dynamic>;
//       return BarbershopModel.fromMap(map);
//     });
//   }
// }

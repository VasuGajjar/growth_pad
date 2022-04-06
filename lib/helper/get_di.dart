import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:growthpad/controller/request_controller.dart';
import 'package:growthpad/data/repository/request_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../data/repository/auth_repo.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() async {
    //Core
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Get.put(preferences, permanent: true);
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    Get.put(firebaseAuth, permanent: true);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Get.put(firestore, permanent: true);
    FirebaseDatabase database = FirebaseDatabase.instance;
    Get.put(database, permanent: true);

    //Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(
        preferences: Get.find(),
        firebaseAuth: Get.find(),
        firestore: Get.find(),
        database: Get.find(),
      ),
    );
    Get.lazyPut<RequestRepository>(() => RequestRepository(firestore: Get.find()));

    //Controller
    Get.lazyPut<AuthController>(() => AuthController(authRepository: Get.find()));
    Get.lazyPut<RequestController>(() => RequestController(requestRepository: Get.find()));
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:growthpad/view/growthpad.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const GrowthPadApp());
}

import 'package:flutter/material.dart';

class SecretaryDashboard extends StatefulWidget {
  const SecretaryDashboard({Key? key}) : super(key: key);

  @override
  State<SecretaryDashboard> createState() => _SecretaryDashboardState();
}

class _SecretaryDashboardState extends State<SecretaryDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Dashboard'));
  }
}

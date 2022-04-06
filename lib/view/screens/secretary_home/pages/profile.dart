import 'package:flutter/material.dart';

class SecretaryProfile extends StatefulWidget {
  const SecretaryProfile({Key? key}) : super(key: key);

  @override
  State<SecretaryProfile> createState() => _SecretaryProfileState();
}

class _SecretaryProfileState extends State<SecretaryProfile> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile'));
  }
}

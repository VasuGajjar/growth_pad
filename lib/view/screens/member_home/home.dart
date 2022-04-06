import 'package:flutter/material.dart';

class MemberHome extends StatefulWidget {
  const MemberHome({Key? key}) : super(key: key);

  @override
  State<MemberHome> createState() => _MemberHomeState();
}

class _MemberHomeState extends State<MemberHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Member Home Page')),
    );
  }
}

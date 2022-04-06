import 'package:flutter/material.dart';

class SecretaryEvent extends StatefulWidget {
  const SecretaryEvent({Key? key}) : super(key: key);

  @override
  State<SecretaryEvent> createState() => SecretaryEventState();
}

class SecretaryEventState extends State<SecretaryEvent> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Messages'));
  }
}

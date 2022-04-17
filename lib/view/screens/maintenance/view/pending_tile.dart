import 'package:flutter/material.dart';

import '../../../../core/model/member.dart';
import '../../../../theme/colors.dart';

class PendingTile extends StatelessWidget {
  final Member member;

  const PendingTile({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      elevation: 4,
      color: AppColors.cardColor,
      child: ListTile(
        title: Text(member.name),
        subtitle: Text('${member.block} ${member.houseNo}'),
      ),
    );
  }
}

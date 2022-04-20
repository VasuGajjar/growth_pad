import 'package:flutter/material.dart';
import 'package:growthpad/core/model/notice.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';

class NoticeTile extends StatelessWidget {
  final Notice notice;
  final void Function() onTap;

  const NoticeTile({
    Key? key,
    required this.notice,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'notice_${notice.id}',
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
        elevation: 4,
        color: AppColors.cardColor,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: onTap,
          contentPadding: const EdgeInsets.all(12),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notice.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.p2Bold,
                ),
              ),
              const Spacer(),
              Text(
                DateConverter.timeToString(notice.createdAt, output: 'd MMM yyyy, hh:mm a'),
                style: TextStyles.p3Normal,
                textScaleFactor: 0.9,
              ),
            ],
          ),
          subtitle: Text(
            notice.description,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: TextStyles.p2Normal,
          ),
        ),
      ),
    );
  }
}

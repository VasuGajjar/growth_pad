import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/event_controller.dart';
import 'package:growthpad/core/model/event.dart';
import 'package:growthpad/core/model/event_payment.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:growthpad/view/base/progressbar.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final bool isSecretary;
  final void Function() onSecretaryTap;
  final void Function() onMemberTap;

  const EventTile({
    Key? key,
    required this.isSecretary,
    required this.event,
    required this.onSecretaryTap,
    required this.onMemberTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
      elevation: 4,
      color: AppColors.cardColor,
      child: InkWell(
        onTap: isSecretary ? onSecretaryTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(event.title, style: TextStyles.p1Normal),
              subtitle: Text(
                DateConverter.timeToString(event.eventTime, output: 'd MMM yyyy, hh:mm a'),
                style: TextStyles.p3Normal,
              ),
              trailing: isSecretary
                  ? const SizedBox.shrink()
                  : FutureBuilder<EventPayment?>(
                      future: Get.find<EventController>().getPayment(event.id, Get.find<Member>().id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Progressbar();
                        }

                        if (snapshot.data == null) {
                          return FilledButton(
                            text: event.isPaid ? 'Pay & Join' : 'Join',
                            onClick: onMemberTap,
                            backgroundColor: AppColors.infoColor.withOpacity(0.3),
                            textColor: AppColors.infoColor,
                            shadowColor: Colors.transparent,
                            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          );
                        }

                        return FilledButton(
                          text: 'Joined',
                          onClick: null,
                          backgroundColor: AppColors.infoColor.withOpacity(0.3),
                          textColor: AppColors.infoColor,
                          shadowColor: Colors.transparent,
                          margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        );
                      },
                    ),
            ),
            if (event.description != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Text(
                  event.description!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.p2Normal,
                  maxLines: 5,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                'Amount: ${event.isPaid ? ('Rs.' + event.amount.toString()) : 'Free'}',
                style: TextStyles.p2Bold.copyWith(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

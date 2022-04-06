import 'package:flutter/material.dart';
import 'package:growthpad/util/assets.dart';
import 'package:growthpad/view/base/lottie_with_text.dart';
import 'package:growthpad/view/base/progressbar.dart';

class ScrollableList<T> extends StatelessWidget {
  final List<T>? data;
  final bool error;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext context, int index, T item) builder;
  final Widget Function(BuildContext context)? emptyBuilder;

  const ScrollableList({
    Key? key,
    this.data,
    this.padding,
    this.error = false,
    required this.builder,
    this.emptyBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (error) {
      return const Center(
        child: LottieWithText(
          animation: Assets.error404,
          text: 'Something went Wrong',
        ),
      );
    }

    if (data == null) return const Center(child: Progressbar());

    if (data!.isEmpty) {
      if (emptyBuilder != null) return emptyBuilder!(context);

      return const Center(child: LottieWithText());
    }

    return ListView.builder(
      padding: padding,
      itemCount: data!.length,
      itemBuilder: (context, index) => builder(context, index, data![index]),
    );
  }
}

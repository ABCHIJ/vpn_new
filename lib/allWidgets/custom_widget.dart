import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final Widget roundWidgetWithIcon;

  CustomWidget({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.roundWidgetWithIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Declare sizeScreen locally within the widget
    final sizeScreen = MediaQuery.of(context).size;

    return SizedBox(
      width: sizeScreen.width * 0.46,
      child: Column(
        children: [
          roundWidgetWithIcon,
          const SizedBox(
            height: 7,
          ),
          Text(
            titleText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis, // Handle long text
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            subtitleText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis, // Handle long text
          ),
        ],
      ),
    );
  }
}

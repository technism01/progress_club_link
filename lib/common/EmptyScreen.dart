import 'package:flutter/material.dart';
import 'package:progress_club_link/common/text_styles.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  final String image;
  const EmptyScreen({required this.title, required this.image, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image),
        Text(title, style: MyTextStyles.semiBold.copyWith(color: Colors.grey))
      ],
    );
  }
}

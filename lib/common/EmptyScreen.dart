import 'package:flutter/material.dart';
import 'package:progress_club_link/common/text_styles.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  final String image;

  const EmptyScreen({required this.title, required this.image, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
              opacity: 0.3,
              child: Image.asset(
                image,
                width: 300,
              )),
          Text(title, style: MyTextStyles.semiBold.copyWith(color: Colors.grey))
        ],
      ),
    );
  }
}

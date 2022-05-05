import 'package:flutter/material.dart';
import 'package:progress_club_link/common/constants.dart';

class RoundedElevatedButton extends StatelessWidget {
  final Widget label;
  final Color? textColor;
  final Color? color;

  final FontWeight? fontWeight;
  final VoidCallback? onPressed;

  const RoundedElevatedButton(
      {Key? key,
      required this.label,
      this.color,
      this.fontWeight,
      required this.onPressed,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 47,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                  side: BorderSide(
                    width: 0.8,
                    color: color ?? appPrimaryColor,
                  )),
            ),
            backgroundColor:
                MaterialStateProperty.all(color ?? appPrimaryColor),
          ),
          child: label,
        ));
  }
}

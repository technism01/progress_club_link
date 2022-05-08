import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const LoadingComponent({Key? key, this.size = 30, this.strokeWidth = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

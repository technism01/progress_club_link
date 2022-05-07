import 'package:flutter/material.dart';
import 'package:progress_club_link/common/constants.dart';

class CustomTabIndicator extends Decoration {
  final BoxPainter _painter;

  CustomTabIndicator({required Color color, required double height})
      : _painter = _IndicatorPainter(height, color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _IndicatorPainter extends BoxPainter {
  final Paint _paint;
  final double height;
  final Color color;

  _IndicatorPainter(this.height, this.color) : _paint = Paint()..shader;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    Path path = Path();

    double x = offset.dx;
    double y = offset.dy;

    path.moveTo(x, y + cfg.size!.height);
    path.lineTo(2 + x, y + cfg.size!.height - height);
    path.lineTo(cfg.size!.width - 2 + x, y + cfg.size!.height - height);
    path.lineTo(cfg.size!.width + x, y + cfg.size!.height);
    path.lineTo(x, y + cfg.size!.height);

    canvas.drawPath(
      path,
      _paint..color = appPrimaryColor,
    );
  }
}

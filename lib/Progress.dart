
import 'package:flutter/material.dart';

class BlobBadge extends StatelessWidget {
  const BlobBadge({super.key});


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _blobPainter(),
      size:const Size(120,120),
    );
  }
}
class _blobPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size){
    final w =size.width;
    final h =size.height;
    const lightGreen = Color(0xFFBDD070);
    const darkGreen  = Color(0xFF5B740E);
    final leaf = Path();
    final fillLeaf = Paint()
      ..color = darkGreen
      ..style = PaintingStyle.fill;
    leaf.moveTo(w * 0.59, h * 0.75);
    leaf.cubicTo(w * 0.53, h * 0.55, w * 0.64, h * 0.43, w * 0.59, h * 0.28);
    leaf.cubicTo(w * 0.49, h * 0.39, w * 0.47, h * 0.51, w * 0.46, h * 0.74);
    leaf.close();
    canvas.drawPath(leaf,fillLeaf);
    canvas.save();
    canvas.translate(10,5);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=> false;

}



import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {

  static const Size worldSize = Size(360, 1000);
  static const int segmentsCount = 4;
  static const double segmentHeight = 200;

  late final List<CubicSegment> segments =
  generateSnakePath(screenWidth: worldSize.width, segmentHeight: segmentHeight, segments: segmentsCount);
  final List<double>milestoneTs =[0,0.23,0.48,0.64,0.85];
  final currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    const Size wSize = worldSize;
    return Scaffold(
      backgroundColor:Colors.lime[100],
      appBar: AppBar(
        title: Text('Progress',style: TextStyle(
          color: Colors.orangeAccent
        ),),
        centerTitle: true,
      ),
      body: LayoutBuilder(
          builder: (context,viewport){
            final scale = viewport.maxWidth / wSize.width;
            final canvasSize = Size(viewport.maxWidth,wSize.height*scale);
            return SingleChildScrollView(
              physics:const BouncingScrollPhysics(),
              child: SizedBox(
                height: canvasSize.height,
                width: canvasSize.width,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: canvasSize,
                      painter: RoutePainter(
                          segments: segments,
                          scale: scale,
                          bandwidth: 36,
                          activeColor: Color(0xFF4CAF50),
                          restColor:Color(0xFFFFE0B2),
                          progressT: milestoneTs[(currentIndex).clamp(0, milestoneTs.length -1)],
                    ))
                  ],

                ),
              ),
            );
          }),
    );
  }
}
class CubicSegment{
  const CubicSegment(this.p0,this.p1,this.p2,this.p3);
  final p0,p1,p2,p3;
}
List<CubicSegment> generateSnakePath({
  required double screenWidth,required double segmentHeight,int segments =4,
}) {
  final List<CubicSegment> path = [];
  double y = 0;
  bool goRight = true;
  for (int i = 0; i < segments; i++) {
    if (goRight) {
      path.add(CubicSegment(Offset(0, y),
          Offset(screenWidth * .33, y),
          Offset(screenWidth * .66, y + segmentHeight),
          Offset(screenWidth, y + segmentHeight)
      ),);
    } else {
      path.add(
        CubicSegment(
          Offset(screenWidth, y),
          Offset(screenWidth * 0.66, y),
          Offset(screenWidth * 0.33, y + segmentHeight),
          Offset(0, y + segmentHeight),
        ),
      );
    }
    y += segmentHeight;
    goRight = !goRight;
  }
  return path;
}


class RoutePainter extends CustomPainter{
  RoutePainter({required this.segments,required this.scale,required this.bandwidth,
  required this.activeColor,required this.restColor,required this.progressT});
  final List<CubicSegment> segments;
  final double scale;
  final double bandwidth;
  final Color activeColor;
  final Color restColor;
  final double progressT;
  @override
  void paint( Canvas canvas, Size size){
    final worldPath = Path();
    var started = false;
    for(final s in segments){
      if (!started){
        worldPath.moveTo(s.p0.dx, s.p0.dy);
        started = true;
      }
      worldPath.cubicTo(s.p1.dx,s.p1.dy,s.p2.dx,s.p2.dy,s.p3.dx,s.p3.dy);
    }
    final path = worldPath.transform((Matrix4.diagonal3Values(scale,scale,1)).storage);
    final basePaint = Paint()
      ..color = restColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = bandwidth;
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = bandwidth;
    canvas.drawPath(path, basePaint);
    if (progressT> 0){
      final metric = path.computeMetrics().isEmpty ? null:path.computeMetrics().first;
      if (metric != null){
        final len =(metric.length * progressT.clamp(0,1));
        final activePath = metric.extractPath(0, len);
        canvas.drawPath(activePath, activePaint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant RoutePainter old){
    return old.segments!= segments||
    old.scale != scale||
    old.bandwidth != bandwidth||
    old.activeColor !=activeColor||
    old.restColor != restColor||
    old.progressT != progressT;
  }
}
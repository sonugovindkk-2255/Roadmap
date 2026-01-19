

import 'package:flutter/material.dart';

class Roadmap extends StatefulWidget {
  const Roadmap({super.key});

  @override
  State<Roadmap> createState() => _RoadmapState();
}

class _RoadmapState extends State<Roadmap> {
  @override
  Widget build(BuildContext context) {
    final int steps = 20;
    return Scaffold(

      backgroundColor: Colors.amber[100],
      body:LayoutBuilder(
            builder:(context,constraints){
              double w =constraints.maxWidth;
              double h = constraints.maxHeight;
              double stepHeight = 200.0;
              double totalHeight = steps * stepHeight;

              List<Offset> nodes =List.generate(steps,(i){
                double xPercent = (i%2==0)? .25 : .75;
                return Offset(w*xPercent,stepHeight*(i+0.5));
              });
              return SingleChildScrollView(
                child: Container(
                  height: totalHeight,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(w,totalHeight),
                        painter: RoadPainter(nodes: nodes),
                      ),
                      ...nodes.asMap().entries.map((entry){
                        return Positioned(
                          left: entry.value.dx-30,
                          top:entry.value.dy-30 ,
                            child: _buildNode(entry.key),);
                      }).toList(),
                    ],
                  ),
                ),
              );
            }),

    );
  }

  Widget _buildNode(int index){
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          color:Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green,width: 3),
          boxShadow:[BoxShadow(blurRadius: 4,color: Colors.black26)]
      ),
      child: Image.asset(index%2 == 0? "Asset/images/Screenshot_19-1-2026_10403_www.bing.com.jpeg":"Asset/images/cartoon-cute-school-boy-photo.jpg")
    );
  }

  Widget _buildLake(double screenWidth){
    return Container(
      width: screenWidth*0.4,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50),
        bottomLeft: Radius.circular(50))
      ),
    );
  }
}
class RoadPainter extends CustomPainter{
  RoadPainter({required this.nodes});
  final List<Offset> nodes;
  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) return;
    final backgroundPaint = Paint()
      ..color = Color(0xFFFFCC80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round;
    // final activePaint = Paint()
    //   ..color = Color(0xFF4CAF50)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 40
    //   ..strokeCap = StrokeCap.round;
    final path = Path();
    double w = size.width;
    double h = size.height;
    path.moveTo(nodes[0].dx, nodes[0].dy);
    for (int i = 0; i < nodes.length - 1; i++) {
      Offset start = nodes[i];
      Offset end = nodes[i + 1];
      double controlY = (start.dy + end.dy)/2;
      path.cubicTo(start.dx, controlY, end.dx, controlY, end.dx, end.dy);
    }
    canvas.drawPath(path, backgroundPaint);
  }
  @override
  bool shouldRepaint( CustomPainter oldDelegate)=>true;
}

import 'package:flutter/material.dart';

class SerpentineRoad extends StatefulWidget {
  const SerpentineRoad({super.key});

  @override
  State<SerpentineRoad> createState() => _SerpentineRoadState();
}

class _SerpentineRoadState extends State<SerpentineRoad> {
  final int loops = 50;
  final double rowHeight = 200;
  final double padding = 60;
  double progress = 0;
  @override
  Widget build(BuildContext context) {
    final Map<int,String> leftAssets= {
      0: 'Asset/images/Vector.png',
      1: 'Asset/images/image1.png',
      2:'Asset/images/Frame 2085664030.png'
    };
    final Map<int,String> rightAssets= {
      0: 'Asset/images/Frame 2085664032.png',
      1: 'Asset/images/Group.png',
      2:'Asset/images/Frame 2085664032.png'
    };
    String _getLeftAsset(int i) => leftAssets[i] ??((i%2==0) ?'Asset/images/Group.png':'Asset/images/image1.png');
    String _getRightAsset(int i) => rightAssets[i] ?? ((i%2==0)?'Asset/images/Frame 2085664032.png':'Asset/images/Group.png');
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: LayoutBuilder(builder: (context, constraints) {
        final double totalHeight = (loops * 2) * rowHeight;
        final double width = constraints.maxWidth;
        List<Offset> nodes = List.generate(loops * 2, (i) {
          double xPercent = (i % 2 == 0) ? .30 : .70;
          return Offset(width * xPercent, rowHeight * (i + 0.5));
        });

        return SingleChildScrollView(
          child: SizedBox(
            height: totalHeight,
            width: width,
            child: Stack(
              children: [
                ...nodes.asMap().entries.map((entry){
                  int i = entry.key;
                  if(i>=nodes.length-1) return const SizedBox();
                  double midY =(nodes[i].dy+nodes[i+1].dy)/2;
                  double screenWidth =MediaQuery.of(context).size.width;
                  return Stack(
                    children: [
                      Positioned(left:0,
                          top: midY-60,
                          child: Image.asset(_getLeftAsset(i))),
                      Positioned(right:5,
                          top: midY-40,
                          child: Image.asset(_getRightAsset(i)))
                      ,
                    ],
                  );

                }),
                Padding(padding:EdgeInsetsGeometry.symmetric(horizontal: 32,vertical: 164),
                  child: Image.asset('Asset/images/image2.png'),),
                Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 144,vertical: 172),
                  child: Image.asset('Asset/images/Vector.png'),),
                Padding(padding:EdgeInsetsGeometry.symmetric(horizontal: 180,vertical: 220),
                  child: Image.asset('Asset/images/image3.png'),),
                Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 180,vertical: 480),
                  child: Image.asset('Asset/images/image2.png'),),
                CustomPaint(
                  size: Size(width, totalHeight),
                  painter: FlatRoadPainter(
                    loops: loops,
                    rowHeight: rowHeight,
                    padding: padding,
                    progress: progress,
                  ),
                ),
                ...nodes.asMap().entries.map((entry) {
                  int index = entry.key;
                  final pos = entry.value;
                  return Positioned(
                    left: pos.dx - 30,
                    top: pos.dy - 30,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => progress = index.toDouble());
                      },
                      child: _buildNode(index),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}

Widget _buildNode(int index) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.green),
    ),
    child: Image.asset(
      index % 2 == 0
          ? "Asset/images/Group (1).png"
          : "Asset/images/Frame 2085664036.png",
      fit: BoxFit.contain,
    ),
  );
}

class FlatRoadPainter extends CustomPainter {
  final int loops;
  final double rowHeight;
  final double padding;
  final double progress;

  FlatRoadPainter({
    required this.loops,
    required this.rowHeight,
    required this.padding,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = const Color(0xFFFFE0B2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round;

    final path = Path();

    final double leftX = padding;
    final double rightX = size.width - padding;
    final double r = rowHeight / 2;

    double yTop = r;
    double yBottom = yTop + rowHeight;
    path.moveTo(leftX + r / 2, yTop);

    for (int i = 0; i < loops; i++) {
      path.lineTo(rightX - r, yTop);
      path.arcTo(
        Rect.fromLTWH(rightX - rowHeight, yTop, rowHeight, rowHeight),
        -1.57,
        3.14,
        false,
      );
      path.lineTo(leftX + r, yBottom);

      if (i < loops - 1) {
        path.arcTo(
          Rect.fromLTWH(leftX, yBottom, rowHeight, rowHeight),
          -1.57,
          -3.14,
          false,
        );
        yTop = yBottom + rowHeight;
        yBottom = yTop + rowHeight;
        path.moveTo(leftX + r, yTop);
      } else {
      }
    }
    canvas.drawPath(path, backgroundPaint);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final int totalNodes = loops * 2;
    final double percent = (totalNodes <= 1) ? 0 : (progress / (totalNodes - 1)).clamp(0, 1);
    double totalLength = 0;
    for (var m in metrics) {
      totalLength += m.length;
    }
    final double drawLength = totalLength * percent;
    double currLength = 0;
    for (var m in metrics) {
      if (currLength >= drawLength) break;

      final double extractEnd = (drawLength - currLength).clamp(0, m.length);
      if (extractEnd > 0) {
        final Path sub = m.extractPath(0, extractEnd);
        canvas.drawPath(sub, activePaint);
      }
      currLength += m.length;
    }
  }

  @override
  bool shouldRepaint(covariant FlatRoadPainter oldDelegate) =>
      oldDelegate.progress != progress ||
          oldDelegate.loops != loops ||
          oldDelegate.rowHeight != rowHeight ||
          oldDelegate.padding != padding;
}



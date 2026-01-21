

import 'package:flutter/material.dart';
import 'package:project_2/Progress.dart';

class Roadmap extends StatefulWidget {
  const Roadmap({super.key});

  @override
  State<Roadmap> createState() => _RoadmapState();
}

class _RoadmapState extends State<Roadmap> {
  int currentProgress = 1;
  @override
  Widget build(BuildContext context) {
    final int steps = 100;
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
    String _getLeftAsset(int i) => leftAssets[i] ??((i%2==0) ?'Asset/images/Group.png':'Asset/images/Frame 2085664032.png');
    String _getRightAsset(int i) => rightAssets[i] ?? ((i%2==0)?'Asset/images/image1.png':'Asset/images/Group.png');

    return Scaffold(

      backgroundColor: Colors.green[50],
      body:LayoutBuilder(
            builder:(context,constraints){
              double w =constraints.maxWidth;
              double h = constraints.maxHeight;
              double stepHeight = 250.0;
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
                      Padding(padding:EdgeInsetsGeometry.symmetric(horizontal: 32,vertical: 192),
                      child: Image.asset('Asset/images/image2.png'),),
                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 144,vertical: 240),
                      child: Image.asset('Asset/images/Vector.png'),),
                      Padding(padding:EdgeInsetsGeometry.symmetric(horizontal: 180,vertical: 272),
                      child: Image.asset('Asset/images/image3.png'),),
                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 180,vertical: 480),
                      child: Image.asset('Asset/images/image2.png'),),
                      CustomPaint(
                        size: Size(w,totalHeight),
                        painter: RoadPainter(nodes: nodes, progress: currentProgress),
                      ),
                      ...nodes.asMap().entries.map((entry){
                        int index = entry.key;
                        bool isVisited = index<currentProgress;
                        return Positioned(
                          left: entry.value.dx-30,
                          top:entry.value.dy-30 ,
                            child:GestureDetector(
                              onTap: (){
                                setState(()=> currentProgress = index+1);
                              },
                              child: _buildNode(index, isVisited),
                            ));
                      }).toList(),
                    ],
                  ),
                ),
              );
            }),

    );
  }

  Widget _buildNode(int index,bool isVisited){
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          color:isVisited ? Colors.orange:Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green,width: 3),
          boxShadow:[BoxShadow(blurRadius: 4,color: Colors.black26)]
      ),
      child: Image.asset(index%2 == 0? "Asset/images/Group (1).png":"Asset/images/Frame 2085664036.png")
    );
  }
  Widget _buildBlob(double w,double h){
    return Positioned(
      top: h*.45,
      right: 10,
        child:Image.asset('Asset/images/Group.png'));
  }
}
class RoadPainter extends CustomPainter{
  RoadPainter({required this.nodes,required this.progress});
  final List<Offset> nodes;
  final int progress;
  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) return;
    final backgroundPaint = Paint()
      ..color = Color(0xFFFFE0B2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round;
     final activePaint = Paint()
      ..color = Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
     ..strokeCap = StrokeCap.round;
    Path fullpath = Path();
    fullpath.moveTo(nodes[0].dx,nodes[0].dy);
    for(int i =0;i<nodes.length-1;i++){
      _addSBeizer(fullpath, nodes[i],nodes[i+1],size.width);
    }
    canvas.drawPath(fullpath, backgroundPaint);
    Path activepath = Path();
    activepath.moveTo(nodes[0].dx,nodes[0].dy);
    for(int i =0;i<progress-1;i++){
      _addSBeizer(activepath, nodes[i], nodes[i+1],size.width);
    }
    canvas.drawPath(activepath,activePaint);


    }
    void _addSBeizer(Path path,Offset p1,Offset p2,double screenWidth){


    double bendIntensity = (p1.dx<p2.dx) ? screenWidth *0.88:screenWidth*0.12;
      double controlY =(p1.dy+p2.dy)/2;
      path.cubicTo(bendIntensity,p1.dy,
                   bendIntensity,controlY,
                   bendIntensity,controlY);
      path.cubicTo(bendIntensity,controlY,
                   bendIntensity,p2.dy,
                    p2.dx,p2.dy);

  }





  @override
  bool shouldRepaint(RoadPainter oldDelegate)=>oldDelegate.progress != progress;


}







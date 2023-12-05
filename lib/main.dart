import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Draggable Circle Example'),
        ),
        body: Center(
          child: DraggableCircle(),
        ),
      ),
    );
  }
}

class DraggableCircle extends StatefulWidget {
  @override
  _DraggableCircleState createState() => _DraggableCircleState();
}

class _DraggableCircleState extends State<DraggableCircle> with SingleTickerProviderStateMixin {    
     late AnimationController _controller;
  double startX = 50.0; // Initial x-coordinate of the locked end
  double startY = 50.0; // Initial y-coordinate of the locked end
  double endX = 150.0; // Initial x-coordinate of the draggable end
  double endY = 150.0; // Initial y-coordinate of the draggable end
  late double screenWidth;
  late double screenHeight;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _controller =            
                                  AnimationController(vsync: this, duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
        endX = screenWidth! / 2;
          endY = screenHeight! * 0.5;
          setState(() {
            
          });
    });
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            // Only update the end coordinates when the gesture is within the circle
            if ((details.localPosition.dx - endX).abs() < 30 &&
                (details.localPosition.dy - endY).abs() < 30) {
              endX += details.delta.dx;
              endY += details.delta.dy;
            }
          });
        },
        onPanEnd: (details) {
          
          endX = screenWidth! / 2;
          endY = screenHeight! * 0.5;

          setState(() {});
        },
        child: CustomPaint(
          painter: DraggableCirclePainter(startX, startY, endX, endY),
        ),
      ),
    );
  }
}

class DraggableCirclePainter extends CustomPainter {
  final double startX;
  final double startY;
  final double endX;
  final double endY;

  DraggableCirclePainter(this.startX, this.startY, this.endX, this.endY);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    // Draw a line from the locked end to the draggable end
    canvas.drawLine(
        Offset(size.width / 2, size.height / 3), Offset(endX, endY), paint);

    // Draw a circle at the draggable end
    canvas.drawCircle(Offset(endX, endY), 30, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

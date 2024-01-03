import 'dart:developer' as d;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DraggableCircle(),
    );
  }
}

class DraggableCircle extends StatefulWidget {
  @override
  _DraggableCircleState createState() => _DraggableCircleState();
}

class _DraggableCircleState extends State<DraggableCircle>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bgController;
  late Animation<Offset> _animation;

  bool isOn = false;
  double startX = 50.0; // Initial x-coordinate of the locked end
  double startY = 50.0; // Initial y-coordinate of the locked end
  double endX = -10.0; // Initial x-coordinate of the draggable end
  double endY = -10.0; // Initial y-coordinate of the draggable end
  late double screenWidth;
  late double screenHeight;
  Color bgColor = Colors.white;
  Alignment _dragAlignment = Alignment.center;
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _bgController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);

    _controller.addListener(() {
      endX = _animation.value.dx;
      endY = _animation.value.dy;
      setState(() {});
    });
    _bgController.addListener(() {
      d.log('hyo ${_bgController.value} ');
      bgColor = Colors.black.withOpacity(_bgController.value);
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
      Future.delayed(const Duration(seconds: 2), () {
        startAnim();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void startAnim() {
    Tween<Offset> offsetTween = Tween<Offset>(
      begin: Offset(screenWidth! * 0.75, 0), // Starting offset
      end: Offset(screenWidth! * 0.75, screenHeight! * 0.5), // Ending offset
    );

    _animation = offsetTween.animate(_controller);
    _bgController.reset();
    _bgController.forward();
    _controller.reset();
    _controller.forward();
  }

  void _runAnimation(Offset pixelsPerSecond) {
    Tween<Offset> offsetTween = Tween<Offset>(
      begin: Offset(endX, endY), // Starting offset
      end: Offset(screenWidth! * 0.75, screenHeight! * 0.5), // Ending offset
    );

    final unitsPerSecondX = pixelsPerSecond.dx / screenWidth;
    final unitsPerSecondY = pixelsPerSecond.dy / screenHeight;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;
    final spring = SpringDescription(
      mass: 1,
      stiffness: 500.0,
      damping: 15,
    );

    final simulation = SpringSimulation(spring, 0, 1, 0);
    _animation = offsetTween.animate(_controller);

    _controller.reset();
    _controller.animateWith(simulation);
  }

  void onLight() {
    isOn = !isOn;
    _playClick();
    setState(() {});
  }

  _playClick() async {
   await  _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('click.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: GestureDetector(
          onTap: () {
            onLight();
          },
          child: Text(
            "Bulb",
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(
                color: isOn ? Colors.yellow : Colors.grey,
                height: 2,
                fontSize: 40),
          ).animate().shake(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: bgColor,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color:
                // isOn ? Colors.yellowAccent :
                Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: DraggableShadowPainter(startX, startY, isOn, endX, endY),
            ),
          ),
          Column(
            children: [
              Text(
                'Pruithvi sandiri',
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                    color: Colors.black, height: 2, fontSize: 40),
              ).animate().scale().slide().fadeIn(),
              Center(
                  child: Text(
                '𓎼𓂋𓅂𓅂𓏏𓇋𓈖𓎼𓋴𓄎 𓇋𓂕𓅓 𓊪𓂋𓅲𓏏𓉔𓆯𓇋𓄼 𓄿𓈖 𓄿𓂧𓅂𓊪𓏏 𓅓𓅱𓃀𓇋𓃭𓅂 𓄿𓊪𓊪 𓂧𓅂𓆯𓅂𓃭𓅱𓊪𓅂𓂋 𓆑𓂋𓅱𓅓 𓇋𓈖𓂧𓇋𓄿. 𓃀𓅂𓇌𓅱𓈖𓂧 𓎢𓅱𓂧𓇋𓈖𓎼𓄼 𓇋 𓏏𓉔𓂋𓇋𓆯𓅂 𓅱𓈖 𓂧𓇋𓋴𓎢𓅱𓆯𓅂𓂋𓇋𓈖𓎼 𓈖𓅂𓅃 𓂧𓅂𓋴𓏏𓇋𓈖𓄿𓏏𓇋𓅱𓈖𓋴 𓄿𓈖𓂧 𓇋𓅓𓅓𓅂𓂋𓋴𓇋𓈖𓎼 𓅓𓇌𓋴𓅂𓃭𓆑 𓇋𓈖 𓂧𓇋𓆯𓅂𓂋𓋴𓅂 𓎢𓅲𓃭𓏏𓅲𓂋𓅂𓋴𓄼 𓄿𓂧𓂧𓇋𓈖𓎼 𓄿 𓂧𓇌𓈖𓄿𓅓𓇋𓎢 𓏏𓅱𓅲𓎢𓉔 𓏏𓅱 𓅓𓇌 𓊪𓂋𓅱𓆑𓅂𓋴𓋴𓇋𓅱𓈖𓄿𓃭 𓊪𓅲𓂋𓋴𓅲𓇋𓏏𓋴. ',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansEgyptianHieroglyphs(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 2),
              )
                      .animate()
                      .slide()
                      .fadeIn() // inherits the delay & duration from move
                  ),
            ],
          ),
          Container(
            color:
                // isOn ? Colors.yellowAccent :
                Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            child: GestureDetector(
              onPanDown: (details) {
                _controller.stop();
              },
              onPanUpdate: (details) {
                setState(() {
                  // Only update the end coordinates when the gesture is within the circle
                  if ((details.localPosition.dx - endX).abs() < 100 &&
                      (details.localPosition.dy - endY).abs() < 100) {
                    endX += details.delta.dx;
                    endY += details.delta.dy;
                  }
                });
              },
              onPanEnd: (details) {
                if (endY > screenHeight * 0.6) {
                  onLight();
                }
                _runAnimation(details.velocity.pixelsPerSecond);
              },
              child: CustomPaint(
                painter:
                    DraggableCirclePainter(startX, startY, isOn, endX, endY),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DraggableCirclePainter extends CustomPainter {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  bool isOn = false;
  DraggableCirclePainter(
      this.startX, this.startY, this.isOn, this.endX, this.endY);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    // Draw a line from the locked end to the draggable end
    canvas.drawLine(Offset(size.width * 0.75, 0), Offset(endX, endY), paint);
    // Define gradient
    final RadialGradient gradient = RadialGradient(
      colors: [isOn ? Colors.white : Colors.black, Colors.grey],
      stops: [0.5, 1.0],
    );
    final Paint gradientPaint = Paint()
      ..shader = gradient.createShader(
          Rect.fromCircle(center: Offset(endX, endY), radius: 10));

    // Draw a circle at the draggable end
    paint.color = isOn ? Colors.white : Colors.grey;

    canvas.drawCircle(Offset(endX, endY), 10, gradientPaint);
  }

  void drawRays(
      Canvas canvas, Paint paint, Offset center, double radius, int count) {
    for (int i = 0; i < count; i++) {
      double angle = (i * 2 * 3.14159) / count; // Calculate angle for each ray
      if (angle > 0.2 && angle < 3) {
        print("angle $angle nd c $i ${cos(angle).toString()}");
        double x2 = center.dx + radius * cos(angle);
        double y2 = center.dy + radius * sin(angle);
        double x1 = center.dx + (radius - 5) * cos(angle);
        double y1 = center.dy + (radius - 5) * sin(angle);

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DraggableShadowPainter extends CustomPainter {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  bool isOn = false;
  DraggableShadowPainter(
      this.startX, this.startY, this.isOn, this.endX, this.endY);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round;

    if (isOn) {
      Paint shadowPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0);
      canvas.drawCircle(Offset(endX, endY), 30, shadowPaint);
      shadowPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 60.0);
      canvas.drawCircle(Offset(endX, endY), 60, shadowPaint);
      paint = Paint()
        ..color = Colors.grey
        ..blendMode = BlendMode.srcOver
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.0;
      drawRays(canvas, paint, Offset(endX, endY), 20, 12);
    }
  }

  void drawRays(
      Canvas canvas, Paint paint, Offset center, double radius, int count) {
    for (int i = 0; i < count; i++) {
      double angle = (i * 2 * 3.14159) / count; // Calculate angle for each ray
      if (angle > 0.2 && angle < 3) {
        print("angle $angle nd c $i ${cos(angle).toString()}");
        double x2 = center.dx + radius * cos(angle);
        double y2 = center.dy + radius * sin(angle);
        double x1 = center.dx + (radius - 5) * cos(angle);
        double y1 = center.dy + (radius - 5) * sin(angle);

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

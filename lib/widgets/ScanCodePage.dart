// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// class ScanCodePage extends StatefulWidget {
//   const ScanCodePage({super.key});
//
//   @override
//   _ScanCodePageState createState() => _ScanCodePageState();
// }
//
// class _ScanCodePageState extends State<ScanCodePage>
//     with TickerProviderStateMixin {
//   late AnimationController ?_animationController;
//   late bool openFlashlight;
//   late Timer _timer;
//
//   late QRViewController controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   late StreamSubscription subscription;
//
//   @override
//   void initState() {
//     super.initState();
//     openFlashlight = false;
//     _initAnimation();
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     _clearAnimation();
//     super.dispose();
//   }
//
//   void _upState() {
//     setState(() {});
//   }
//
//   void _clearAnimation() {
//     _timer?.cancel();
//     if (_animationController != null) {
//       _animationController?.dispose();
//       _animationController = null;
//     }
//   }
//
//   void _initAnimation() {
//     setState(() {
//       _animationController = AnimationController(
//           vsync: this, duration: const Duration(milliseconds: 1000));
//     });
//     _animationController
//       ?..addListener(_upState)
//       ..addStatusListener((state) {
//         if (state == AnimationStatus.completed) {
//           _timer = Timer(const Duration(seconds: 1), () {
//             _animationController?.reverse(from: 1.0);
//           });
//         } else if (state == AnimationStatus.dismissed) {
//           _timer = Timer(const Duration(seconds: 1), () {
//             _animationController?.forward(from: 0.0);
//           });
//         }
//       });
//     _animationController?.forward(from: 0.0);
//   }
//
//   Future setFlashlight() async {
//     await controller.toggleFlash();
//     openFlashlight = (await controller.getFlashStatus())!;
//     _upState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Material(
//         color: Colors.black,
//         child: LayoutBuilder(builder: (context, constraints) {
//           final qrScanSize = constraints.maxWidth * 0.75;
//           return Stack(
//             children: <Widget>[
//               QRView(
//                 key: qrKey,
//                 onQRViewCreated: _onQRViewCreated,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   AppBar(
//                     leading: const BackButton(),
//                     elevation: 0,
//                     backgroundColor: Colors.transparent,
//                   ),
//                   const SizedBox(
//                     height: 100,
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(20),
//                     child: SizedBox(
//                       width: qrScanSize,
//                       height: qrScanSize,
//                       child: Stack(
//                         children: [
//                           CustomPaint(
//                             painter: QrScanBoxPainter(
//                               boxLineColor: Colors.lightGreenAccent,
//                               animationValue: _animationController?.value ?? 0,
//                               isForward: _animationController?.status ==
//                                   AnimationStatus.forward,
//                             ),
//                             child: Container(),
//                           ),
//                           Positioned(
//                             bottom: 10,
//                             width: qrScanSize,
//                             child: Align(
//                               alignment: Alignment.bottomCenter,
//                               child: GestureDetector(
//                                 behavior: HitTestBehavior.translucent,
//                                 onTap: setFlashlight,
//                                 child: Image(
//                                   image: AssetImage(openFlashlight
//                                       ? 'assets/images/common/ic_light.png'
//                                       : 'assets/images/common/ic_light.png'),
//                                   width: 35,
//                                   height: 35,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const Text(
//                     "请将二维码/条形码置于方框中",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               )
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     subscription ??= controller.scannedDataStream.listen((scanData) {
//         //保证只接收一次数据
//         subscription.cancel();
//         Navigator.of(context).pop(scanData.code);
//       });
//   }
// }
//
// class QrScanBoxPainter extends CustomPainter {
//   final double animationValue;
//   final bool isForward;
//   final Color boxLineColor;
//
//   QrScanBoxPainter(
//       {required this.animationValue,
//       required this.isForward,
//       required this.boxLineColor})
//       : assert(animationValue != null),
//         assert(isForward != null);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final borderRadius = const BorderRadius.all(Radius.circular(12)).toRRect(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//     );
//     canvas.drawRRect(
//       borderRadius,
//       Paint()
//         ..color = Colors.white54
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 1,
//     );
//     final borderPaint = Paint()
//       ..color = Colors.greenAccent
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//     final path = Path();
//     // leftTop
//     path.moveTo(0, 50);
//     path.lineTo(0, 12);
//     path.quadraticBezierTo(0, 0, 12, 0);
//     path.lineTo(50, 0);
//     // rightTop
//     path.moveTo(size.width - 50, 0);
//     path.lineTo(size.width - 12, 0);
//     path.quadraticBezierTo(size.width, 0, size.width, 12);
//     path.lineTo(size.width, 50);
//     // rightBottom
//     path.moveTo(size.width, size.height - 50);
//     path.lineTo(size.width, size.height - 12);
//     path.quadraticBezierTo(
//         size.width, size.height, size.width - 12, size.height);
//     path.lineTo(size.width - 50, size.height);
//     // leftBottom
//     path.moveTo(50, size.height);
//     path.lineTo(12, size.height);
//     path.quadraticBezierTo(0, size.height, 0, size.height - 12);
//     path.lineTo(0, size.height - 50);
//
//     canvas.drawPath(path, borderPaint);
//
//     canvas.clipRRect(
//         const BorderRadius.all(Radius.circular(12)).toRRect(Offset.zero & size));
//
//     // 绘制横向网格
//     final linePaint = Paint();
//     final lineSize = size.height * 0.45;
//     final leftPress = (size.height + lineSize) * animationValue - lineSize;
//     linePaint.style = PaintingStyle.stroke;
//     linePaint.shader = LinearGradient(
//       colors: [Colors.transparent, boxLineColor],
//       begin: isForward ? Alignment.topCenter : const Alignment(0.0, 2.0),
//       end: isForward ? const Alignment(0.0, 0.5) : Alignment.topCenter,
//     ).createShader(Rect.fromLTWH(0, leftPress, size.width, lineSize));
//     for (int i = 0; i < size.height / 5; i++) {
//       canvas.drawLine(
//         Offset(
//           i * 5.0,
//           leftPress,
//         ),
//         Offset(i * 5.0, leftPress + lineSize),
//         linePaint,
//       );
//     }
//     for (int i = 0; i < lineSize / 5; i++) {
//       canvas.drawLine(
//         Offset(0, leftPress + i * 5.0),
//         Offset(
//           size.width,
//           leftPress + i * 5.0,
//         ),
//         linePaint,
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(QrScanBoxPainter oldDelegate) =>
//       animationValue != oldDelegate.animationValue;
//
//   @override
//   bool shouldRebuildSemantics(QrScanBoxPainter oldDelegate) =>
//       animationValue != oldDelegate.animationValue;
// }
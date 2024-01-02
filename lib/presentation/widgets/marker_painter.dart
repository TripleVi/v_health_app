import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MarkerPainter extends CustomPainter {
  final Uint8List _imageBytes;

  const MarkerPainter._(this._imageBytes);
  
  static Future<Uint8List> getMarkerBytes(Uint8List imageBytes) async {
    const ui.Size size = ui.Size(160.0, 160.0);
    ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas canvas = ui.Canvas(recorder);
    MarkerPainter painter = MarkerPainter._(imageBytes);
    await painter.paint(canvas, size);
    ui.Picture picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }

  Future<ui.Image> _loadUIImage() {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(_imageBytes, (image) {
      completer.complete(image);
    });
    return completer.future;
  }

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 20.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;
    Offset center = Offset(size.width / 2, size.height / 2);
    final image = await _loadUIImage();
    canvas.clipRRect(
      RRect.fromLTRBR(0.0, 0.0, size.width, size.height, Radius.circular(size.width/2))
    );
    final srcRect = const Offset(0.0, 0.0) 
        & Size(image.width * 1.0, image.height * 1.0);
    final dstRect = const Offset(0.0, 0.0) & size;
    canvas.drawImageRect(image, srcRect, dstRect, paint);
    canvas.drawCircle(center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
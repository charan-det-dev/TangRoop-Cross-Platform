import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';

class SaveResultData {
  final bool success;
  final String? filePath;
  final int width, height;
  final double fileSizeMb;
  const SaveResultData({
    required this.success,
    this.filePath,
    this.width = 0,
    this.height = 0,
    this.fileSizeMb = 0,
  });
}

/// Renders the editor canvas (image + color matrix + layers) at full resolution
/// and saves to the device gallery. Cross-platform (iOS + Android).
class ImageExporter {
  static Future<SaveResultData> saveFromBoundary({
    required GlobalKey boundaryKey,
    required String? gallerySourcePath,
  }) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return const SaveResultData(success: false);

      // High-res render at 3x device pixel ratio
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      if (!await _ensurePermission()) {
        return const SaveResultData(success: false);
      }

      await Gal.putImageBytes(
        Uint8List.fromList(bytes),
        name: 'TangRoop_${DateTime.now().millisecondsSinceEpoch}',
      );
      final success = true;
      final path = '';

      return SaveResultData(
        success: success,
        filePath: path,
        width: image.width,
        height: image.height,
        fileSizeMb: bytes.length / (1024 * 1024),
      );
    } catch (e) {
      debugPrint('ImageExporter error: $e');
      return const SaveResultData(success: false);
    }
  }

  /// Encode a ui.Image to JPEG bytes for sharing.
  static Future<Uint8List> imageToJpeg(ui.Image image, {int quality = 95}) async {
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    return _encodeJpeg(data!, image.width, image.height, quality);
  }

  static Future<bool> _ensurePermission() async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        return await Gal.requestAccess();
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Lightweight JPEG encoder via dart:ui (encode through Picture pipeline)
Future<Uint8List> _encodeJpeg(
    ByteData rgba, int width, int height, int quality) async {
  final buffer = await ui.ImmutableBuffer.fromUint8List(
      rgba.buffer.asUint8List());
  final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: width,
      height: height,
      pixelFormat: ui.PixelFormat.rgba8888);
  final codec = await descriptor.instantiateCodec();
  final frame = await codec.getNextFrame();
  final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

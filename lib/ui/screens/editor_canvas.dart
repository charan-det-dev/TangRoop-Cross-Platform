import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../state/editor_state.dart';

/// Main photo canvas: image + ColorFilter + draggable text/sticker layers.
class EditorCanvas extends StatelessWidget {
  final File? imageFile;
  final List<double> colorMatrix;
  final EditorState state;
  final GlobalKey boundaryKey;
  final ValueChanged<String?> onSelectLayer;
  final void Function(String id, Offset delta) onDragText;
  final void Function(String id, Offset delta) onDragSticker;
  final VoidCallback onRemoveSelected;
  final void Function(String category, String subTool) onLayerPicked;
  final String vfxName;
  final double vfxIntensity;
  final String cutoutBgType;
  final Color cutoutSolidColor;

  const EditorCanvas({
    super.key,
    required this.imageFile,
    required this.colorMatrix,
    required this.state,
    required this.boundaryKey,
    required this.onSelectLayer,
    required this.onDragText,
    required this.onDragSticker,
    required this.onRemoveSelected,
    required this.onLayerPicked,
    required this.vfxName,
    required this.vfxIntensity,
    required this.cutoutBgType,
    required this.cutoutSolidColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate,
                  size: 80, color: primaryPink.withValues(alpha: 0.6)),
              const SizedBox(height: 16),
              const Text('เลือกรูปภาพเพื่อเริ่มแต่งรูป',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => onSelectLayer(null),
      child: RepaintBoundary(
        key: boundaryKey,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background for cutout modes
            if (cutoutBgType == 'Solid')
              Positioned.fill(child: Container(color: cutoutSolidColor)),
            if (cutoutBgType == 'Blur')
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Image.file(imageFile!, fit: BoxFit.cover),
                ),
              ),
            // Main image with color matrix
            ColorFiltered(
              colorFilter: ColorFilter.matrix(colorMatrix),
              child: Image.file(imageFile!, fit: BoxFit.contain),
            ),
            // VFX overlays
            if (vfxName == 'Vignette' && vfxIntensity > 0.01)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 1.0,
                      stops: [1 - vfxIntensity.clamp(0.1, 0.9), 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: vfxIntensity),
                      ],
                    ),
                  ),
                ),
              ),
            if (vfxName == 'Light Leak' && vfxIntensity > 0.01)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        const Color(0xFFFF9800).withValues(alpha: vfxIntensity * 0.5),
                        Colors.transparent,
                        const Color(0xFFE91E63).withValues(alpha: vfxIntensity * 0.3),
                      ],
                    ),
                  ),
                ),
              ),
            if (vfxName == 'Film Grain' && vfxIntensity > 0.01)
              Positioned.fill(
                child: Opacity(
                  opacity: vfxIntensity * 0.35,
                  child: CustomPaint(painter: _GrainPainter()),
                ),
              ),
            if (vfxName == 'Bokeh' && vfxIntensity > 0.01)
              Positioned.fill(
                child: Opacity(
                  opacity: vfxIntensity * 0.6,
                  child: CustomPaint(painter: _BokehPainter()),
                ),
              ),
            // Text layers
            for (final layer in state.textLayers)
              _DraggableLayer(
                offset: layer.offset,
                isSelected: layer.id == state.selectedLayerId,
                onDragStart: () {
                  onSelectLayer(layer.id);
                  onLayerPicked('แก้ไข', 'ข้อความ');
                },
                onDrag: (d) => onDragText(layer.id, d),
                onRemove: onRemoveSelected,
                padding: 8,
                child: Text(
                  layer.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: layer.color,
                    fontSize: layer.size,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(color: Colors.black54, blurRadius: 5),
                    ],
                  ),
                ),
              ),
            // Sticker layers
            for (final layer in state.stickerLayers)
              _DraggableLayer(
                offset: layer.offset,
                isSelected: layer.id == state.selectedLayerId,
                onDragStart: () {
                  onSelectLayer(layer.id);
                  onLayerPicked('แก้ไข', 'สติ๊กเกอร์');
                },
                onDrag: (d) => onDragSticker(layer.id, d),
                onRemove: onRemoveSelected,
                padding: 4,
                child: Text(layer.sticker,
                    style: const TextStyle(fontSize: 64)),
              ),
          ],
        ),
      ),
    );
  }
}

class _DraggableLayer extends StatelessWidget {
  final Offset offset;
  final bool isSelected;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDrag;
  final VoidCallback onRemove;
  final double padding;
  final Widget child;

  const _DraggableLayer({
    required this.offset,
    required this.isSelected,
    required this.onDragStart,
    required this.onDrag,
    required this.onRemove,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onPanStart: (_) => onDragStart(),
            onPanUpdate: (d) => onDrag(d.delta),
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(color: primaryPink, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: child,
            ),
          ),
          if (isSelected)
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    var seed = 12345;
    for (var i = 0; i < 4000; i++) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      final x = (seed % 10000) / 10000 * size.width;
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      final y = (seed % 10000) / 10000 * size.height;
      paint.color = (i % 2 == 0 ? Colors.white : Colors.black)
          .withValues(alpha: 0.6);
      canvas.drawRect(Rect.fromLTWH(x, y, 1.5, 1.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _BokehPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var seed = 777;
    for (var i = 0; i < 30; i++) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      final x = (seed % 10000) / 10000 * size.width;
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      final y = (seed % 10000) / 10000 * size.height;
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      final r = 8 + (seed % 100) / 100 * 30;
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

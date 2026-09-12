import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/editor_state.dart';

class EditorCanvas extends StatelessWidget {
  const EditorCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditorState>();

    if (state.originalImage == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFA566FF)),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => state.clearSelection(),
          child: Container(
            color: const Color(0xFF1E1E1E),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Base Image with Color Filter
                ColorFiltered(
                  colorFilter: ColorFilter.matrix(state.colorMatrix),
                  child: Image.file(
                    File(state.originalImage!.path),
                    fit: BoxFit.contain,
                  ),
                ),

                // Layers (Text/Stickers)
                ...state.layers.map((layer) {
                  final isSelected = layer.id == state.selectedLayerId;
                  return Positioned(
                    left: layer.x,
                    top: layer.y,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        state.updateLayerPosition(layer.id, details.delta.dx, details.delta.dy);
                      },
                      onTap: () => state.selectLayer(layer.id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: isSelected
                            ? BoxDecoration(
                                border: Border.all(color: Colors.blueAccent, width: 2),
                              )
                            : null,
                        child: _buildLayerContent(layer),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLayerContent(LayerData layer) {
    if (layer.type == LayerType.text) {
      return Text(
        layer.content,
        style: TextStyle(
          color: layer.color ?? Colors.white,
          fontSize: (layer.scale) * 24.0,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (layer.type == LayerType.sticker) {
      return Transform.scale(
        scale: layer.scale,
        child: Text(
          layer.content,
          style: const TextStyle(fontSize: 48),
        ),
      );
    }
    return const SizedBox();
  }
}

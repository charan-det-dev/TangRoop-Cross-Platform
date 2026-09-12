import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/editor_state.dart';
import 'editor_canvas.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditorState>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.undo, color: state.canUndo ? Colors.white : Colors.grey),
              onPressed: state.canUndo ? () => state.undo() : null,
            ),
            IconButton(
              icon: Icon(Icons.redo, color: state.canRedo ? Colors.white : Colors.grey),
              onPressed: state.canRedo ? () => state.redo() : null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/export');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)]
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Canvas Area
          const Expanded(
            child: EditorCanvas(),
          ),

          // Tool Panel Area
          Container(
            height: 140,
            color: const Color(0xFF1E1E1E),
            child: _buildDummyToolPanel(_currentTabIndex),
          ),

          // Bottom Navigation / Tabs
          BottomNavigationBar(
            currentIndex: _currentTabIndex,
            onTap: (index) => setState(() => _currentTabIndex = index),
            backgroundColor: Colors.black,
            selectedItemColor: const Color(0xFFA566FF),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Filter'),
              BottomNavigationBarItem(icon: Icon(Icons.face), label: 'Beauty'),
              BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Text'),
              BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions), label: 'Sticker'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDummyToolPanel(int index) {
    // We use simple placeholders to ensure it compiles without depending on specific tool panel widget names
    final titles = ['Filters', 'Beauty Adjustments', 'Text Layers', 'Stickers'];
    return Center(
      child: Text(
        '${titles[index]} Tool Panel',
        style: const TextStyle(color: Colors.white70, fontSize: 16)
      ),
    );
  }
}

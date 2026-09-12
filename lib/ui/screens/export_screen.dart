import 'package:flutter/material.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  bool _isSaving = true;


  @override
  void initState() {
    super.initState();
    _simulateExport();
  }

  Future<void> _simulateExport() async {
    // Simulating the save process that would call ImageSaver
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isSaving = false;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: _isSaving
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(color: Color(0xFFA566FF)),
                SizedBox(height: 16),
                Text('Saving your masterpiece...', style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
                const SizedBox(height: 16),
                const Text('Saved to Gallery!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    // Share feature implementation
                  },
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: const Text('Share', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA566FF),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Back to Home', style: TextStyle(color: Colors.white70)),
                )
              ],
            ),
      ),
    );
  }
}

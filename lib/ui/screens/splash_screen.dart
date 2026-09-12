import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onSplashFinished;
  const SplashScreen({super.key, required this.onSplashFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;
  late final AnimationController _pulse;
  double get progress => _progress.value;
  bool contentVisible = false;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _pulse = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
        lowerBound: 0.95,
        upperBound: 1.05);
    _pulse.repeat(reverse: true);
    setState(() => contentVisible = true);
    _progress.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) widget.onSplashFinished();
    });
  }

  String get statusText {
    final p = progress;
    if (p < 0.35) return 'Initializing Studio Engine...';
    if (p < 0.70) return 'Loading Filters & Presets...';
    if (p < 0.95) return 'Preparing Canvas...';
    return 'Ready to Create!';
  }

  @override
  void dispose() {
    _progress.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0C20), Color(0xFF181033), Color(0xFF0F0C20)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation:
                Listenable.merge([_progress, _pulse]),
            builder: (context, _) => AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: contentVisible ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glowing Ambient Logo
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 170 * _pulse.value,
                            height: 170 * _pulse.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [
                                primaryPink.withValues(alpha: 0.6),
                                primaryViolet.withValues(alpha: 0.3),
                                Colors.transparent,
                              ]),
                            ),
                          ),
                          // Placeholder logo mark (TangRoop monogram)
                          Container(
                            width: 150 * _pulse.value,
                            height: 150 * _pulse.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                  colors: primaryGradientColors),
                              boxShadow: [
                                BoxShadow(
                                    color: primaryPink.withValues(alpha: 0.5),
                                    blurRadius: 40),
                              ],
                            ),
                            child: const Center(
                              child: Text('ต',
                                  style: TextStyle(
                                      fontSize: 72,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text('TangRoop',
                        style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2)),
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('Photo Studio & Creative Tools',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70)),
                    ),
                    const SizedBox(height: 64),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Container(
                              height: 6,
                              color: Colors.white.withValues(alpha: 0.15),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress.clamp(0, 1),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      primaryPink,
                                      primaryViolet,
                                      accentGold,
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(statusText,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            bottom: 60 + MediaQuery.of(context).padding.bottom),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, color: accentGold, size: 16),
            SizedBox(width: 6),
            Text('POWERED BY TANGROOP',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                    letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}

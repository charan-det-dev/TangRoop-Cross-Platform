import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TrendingFilterCard {
  final String id, title, subtitle, imageUrl;
  const TrendingFilterCard(this.id, this.title, this.subtitle, this.imageUrl);
}

class LandingScreen extends StatefulWidget {
  final VoidCallback onStartClick;
  const LandingScreen({super.key, required this.onStartClick});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int selectedNavTab = 0;

  static const trendingFilters = [
    TrendingFilterCard('f1', 'Cinematic', 'Cinematic color tone',
        'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=600'),
    TrendingFilterCard('f2', 'Vintage Film', 'Retro film grain look',
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=600'),
    TrendingFilterCard('f3', 'G7X Flash', 'Y2K digicam flash',
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=600'),
    TrendingFilterCard('f4', 'Dreamy', 'Soft glow portrait',
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=600'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: softBackgroundGradientColors,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TangRoop',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: textPrimaryDark)),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 10),
                              ],
                            ),
                            child: const Icon(Icons.notifications_none,
                                color: textPrimaryDark),
                          ),
                        ],
                      ),
                    ),
                    // Greeting
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ยินดีต้อนรับ 👋',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: textSecondaryDark,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('เริ่มแต่งรูปของคุณ',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1E24))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Quick tools grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _QuickTool(
                              icon: Icons.photo_camera,
                              label: 'แต่งรูป',
                              onTap: widget.onStartClick),
                          const SizedBox(width: 12),
                          _QuickTool(
                              icon: Icons.grid_on,
                              label: 'คอลลาจ',
                              onTap: widget.onStartClick),
                          const SizedBox(width: 12),
                          _QuickTool(
                              icon: Icons.auto_fix_high,
                              label: 'เมจิกบรัช',
                              onTap: widget.onStartClick),
                          const SizedBox(width: 12),
                          _QuickTool(
                              icon: Icons.face_retouching_natural,
                              label: 'ความสวย',
                              onTap: widget.onStartClick),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Trending filters
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ฟิลเตอร์ยอดนิยม',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E24))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 210,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: trendingFilters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (_, i) {
                          final card = trendingFilters[i];
                          return GestureDetector(
                            onTap: widget.onStartClick,
                            child: Container(
                              width: 155,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(card.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Container(
                                                color: const Color(0xFFE5E7EB))),
                                    // Dark bottom gradient
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: const [0.4, 1.0],
                                            colors: [
                                              Colors.transparent,
                                              Colors.black
                                                  .withValues(alpha: 0.75),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Badge
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.4),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(card.title,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      right: 12,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(card.title,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          Text(card.subtitle,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white
                                                      .withValues(
                                                          alpha: 0.8))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
          // Bottom navigation bar with floating camera button
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 68 + MediaQuery.of(context).padding.bottom,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: bottomNavGradientColors),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16),
                    ],
                  ),
                  child: Row(
                    children: [
                      _NavTab(
                        icon: Icons.home,
                        label: 'หน้าแรก',
                        selected: selectedNavTab == 0,
                        onTap: () => setState(() => selectedNavTab = 0),
                      ),
                      const Spacer(),
                      _NavTab(
                        icon: Icons.auto_awesome_motion,
                        label: 'แม่แบบ',
                        selected: selectedNavTab == 1,
                        onTap: () => setState(() => selectedNavTab = 1),
                      ),
                    ],
                  ),
                ),
                // Floating camera button
                Positioned(
                  top: -18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: widget.onStartClick,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textPrimaryDark,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 8),
                          ],
                        ),
                        child:
                            const Icon(Icons.photo_camera, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickTool extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickTool(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06), blurRadius: 8),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: primaryPink, size: 26),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavTab(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? const Color(0xFF1E1E24) : const Color(0xFF1E1E24).withValues(alpha: 0.6);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                    color: color)),
          ],
        ),
      ),
    );
  }
}

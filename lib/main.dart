import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const DavnorShieldApp());
}

class DavnorShieldApp extends StatelessWidget {
  const DavnorShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DavnorShield',
      themeMode: ThemeMode.system,
      theme: _appTheme(Brightness.light),
      darkTheme: _appTheme(Brightness.dark),
      home: const OnboardingScreen(),
    );
  }

  ThemeData _appTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F172A),
      brightness: brightness,
      primary: const Color(0xFF16A34A),
      secondary: const Color(0xFF22D3EE),
      tertiary: const Color(0xFF10B981),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? const Color(0xFF08111F) : const Color(0xFFF4F8FC),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.8),
        bodyLarge: TextStyle(fontSize: 16, height: 1.45, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ).apply(
        fontFamily: 'Inter',
        bodyColor: isDark ? const Color(0xFFE8EEF9) : const Color(0xFF102033),
        displayColor: isDark ? const Color(0xFFE8EEF9) : const Color(0xFF102033),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? const Color(0xFFB7E6FF) : const Color(0xFF0F172A),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      title: 'Stop Online Scams Before They Reach You',
      description:
          'DavnorShield instantly detects phishing links, fake text messages, suspicious QR codes, and online scams before you click or share them.',
      ctaLabel: 'Continue',
    ),
    _OnboardingPageData(
      title: 'See Scams Happening Near You',
      description:
          'Stay informed with live scam alerts in your municipality and barangay. Know what’s happening around you before scammers reach your community.',
      ctaLabel: 'Continue',
    ),
    _OnboardingPageData(
      title: 'AI + Community Protection',
      description:
          'Powered by AI and the community, DavnorShield learns new scam patterns from local reports and protects everyone with smarter cyber alerts.',
      ctaLabel: 'Get Started',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_pageIndex < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const _HomePlaceholderScreen(),
        ),
      );
    }
  }

  void _skip() {
    _controller.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _OnboardingBackdrop(isDark: isDark)),
          SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final page = _controller.hasClients
                    ? (_controller.page ?? _pageIndex.toDouble())
                    : _pageIndex.toDouble();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: _skip,
                            child: const Text('Skip'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageChanged: (value) => setState(() => _pageIndex = value),
                        itemBuilder: (context, index) {
                          final delta = index - page;
                          return _OnboardingPageView(
                            data: _pages[index],
                            index: index,
                            delta: delta,
                            onContinue: _goNext,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.ctaLabel,
  });

  final String title;
  final String description;
  final String ctaLabel;
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({
    required this.data,
    required this.index,
    required this.delta,
    required this.onContinue,
  });

  final _OnboardingPageData data;
  final int index;
  final double delta;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = switch (index) {
      0 => const Color(0xFF22D3EE),
      1 => const Color(0xFFF59E0B),
      _ => const Color(0xFF16A34A),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: _IllustrationFrame(
                accent: accent,
                child: _heroForIndex(context, index, delta, isDark),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  height: 1.08,
                ),
          ),
          const SizedBox(height: 14),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFBCD0E6)
                      : const Color(0xFF365066),
                ),
          ),
          const SizedBox(height: 18),
          _GradientButton(
            label: data.ctaLabel,
            accent: accent,
            onPressed: onContinue,
          ),
          const SizedBox(height: 16),
          _PageDots(activeIndex: index),
        ],
      ),
    );
  }

  Widget _heroForIndex(BuildContext context, int pageIndex, double delta, bool isDark) {
    switch (pageIndex) {
      case 0:
        return _ScamShieldHero(delta: delta, isDark: isDark);
      case 1:
        return _HeatmapHero(delta: delta, isDark: isDark);
      default:
        return _CommunityAiHero(delta: delta, isDark: isDark);
    }
  }
}

class _IllustrationFrame extends StatelessWidget {
  const _IllustrationFrame({
    required this.child,
    required this.accent,
  });

  final Widget child;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AspectRatio(
      aspectRatio: 0.92,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF111D33).withOpacity(0.88),
                          const Color(0xFF0B1425).withOpacity(0.94),
                        ]
                      : [
                          const Color(0xFFF7FBFF).withOpacity(0.92),
                          const Color(0xFFE6F2FF).withOpacity(0.88),
                        ],
                ),
                border: Border.all(
                  color: accent.withOpacity(isDark ? 0.26 : 0.34),
                  width: 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(isDark ? 0.28 : 0.16),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.32 : 0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const Positioned.fill(child: _SoftGridOverlay()),
          child,
        ],
      ),
    );
  }
}

class _SoftGridOverlay extends StatelessWidget {
  const _SoftGridOverlay();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IgnorePointer(
      child: CustomPaint(
        painter: _GridPainter(
          lineColor: (isDark ? Colors.white : const Color(0xFF334155)).withOpacity(isDark ? 0.04 : 0.06),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    const step = 26.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => oldDelegate.lineColor != lineColor;
}

class _ScamShieldHero extends StatelessWidget {
  const _ScamShieldHero({
    required this.delta,
    required this.isDark,
  });

  final double delta;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF22D3EE);
    final emerald = const Color(0xFF16A34A);
    final scam = const Color(0xFFFB7185);
    final orange = const Color(0xFFF59E0B);

    return Transform.translate(
      offset: Offset(delta * 16, delta.abs() * 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 28,
            left: 42,
            child: _ThreatCard(
              label: 'SMS',
              icon: Icons.sms_rounded,
              color: scam,
              rotation: -0.18,
              glow: scam.withOpacity(0.28),
            ),
          ),
          Positioned(
            top: 72,
            right: 18,
            child: _ThreatCard(
              label: 'QR',
              icon: Icons.qr_code_rounded,
              color: orange,
              rotation: 0.11,
              glow: orange.withOpacity(0.28),
            ),
          ),
          Positioned(
            bottom: 84,
            left: 18,
            child: _ThreatCard(
              label: 'EMAIL',
              icon: Icons.mail_rounded,
              color: scam,
              rotation: 0.08,
              glow: scam.withOpacity(0.22),
            ),
          ),
          Positioned(
            bottom: 126,
            right: 22,
            child: _ThreatCard(
              label: 'ALERT',
              icon: Icons.warning_rounded,
              color: orange,
              rotation: -0.14,
              glow: orange.withOpacity(0.22),
            ),
          ),
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accent.withOpacity(isDark ? 0.22 : 0.14),
                  accent.withOpacity(0.04),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.26),
                  blurRadius: 72,
                  spreadRadius: 18,
                ),
              ],
            ),
          ),
          Positioned(
            top: 48,
            child: Transform.scale(
              scale: 1.02 + (delta.abs() * 0.03),
              child: SizedBox(
                width: 210,
                height: 240,
                child: CustomPaint(
                  painter: _ShieldPainter(
                    fill: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(isDark ? 0.12 : 0.42),
                        emerald.withOpacity(isDark ? 0.18 : 0.24),
                      ],
                    ),
                    outline: accent.withOpacity(0.9),
                    innerGlow: emerald.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 76,
            child: Container(
              width: 132,
              height: 250,
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isDark ? const Color(0xFF15253F) : const Color(0xFFF9FCFF),
                    isDark ? const Color(0xFF0C1526) : const Color(0xFFE7F1FA),
                  ],
                ),
                border: Border.all(color: Colors.white.withOpacity(isDark ? 0.09 : 0.38)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.34 : 0.1),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 6,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accent.withOpacity(isDark ? 0.4 : 0.22),
                            emerald.withOpacity(isDark ? 0.26 : 0.16),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 14,
                            left: 12,
                            right: 12,
                            child: _MiniMessage(color: Colors.white.withOpacity(0.9), widthFactor: 0.82),
                          ),
                          Positioned(
                            top: 56,
                            left: 16,
                            right: 28,
                            child: _MiniMessage(color: Colors.white.withOpacity(0.72), widthFactor: 0.58),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(isDark ? 0.18 : 0.08),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMessage extends StatelessWidget {
  const _MiniMessage({
    required this.color,
    required this.widthFactor,
  });

  final Color color;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _ThreatCard extends StatelessWidget {
  const _ThreatCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.rotation,
    required this.glow,
  });

  final String label;
  final IconData icon;
  final Color color;
  final double rotation;
  final Color glow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 96,
        height: 72,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: (isDark ? const Color(0xFF0E1727) : Colors.white).withOpacity(0.88),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: glow,
              blurRadius: 22,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 11,
                    color: isDark ? const Color(0xFFEAF2FF) : const Color(0xFF0F172A),
                    letterSpacing: 0.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  _ShieldPainter({
    required this.fill,
    required this.outline,
    required this.innerGlow,
  });

  final Gradient fill;
  final Color outline;
  final Color innerGlow;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.06)
      ..cubicTo(size.width * 0.78, size.height * 0.06, size.width * 0.92, size.height * 0.18, size.width * 0.92, size.height * 0.42)
      ..cubicTo(size.width * 0.92, size.height * 0.7, size.width * 0.7, size.height * 0.9, size.width * 0.5, size.height * 0.98)
      ..cubicTo(size.width * 0.3, size.height * 0.9, size.width * 0.08, size.height * 0.7, size.width * 0.08, size.height * 0.42)
      ..cubicTo(size.width * 0.08, size.height * 0.18, size.width * 0.22, size.height * 0.06, size.width * 0.5, size.height * 0.06)
      ..close();

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final fillPaint = Paint()..shader = fill.createShader(rect);
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..color = outline
      ..strokeJoin = StrokeJoin.round;
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..color = innerGlow.withOpacity(0.36)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, outlinePaint);

    final circuit = Paint()
      ..color = Colors.white.withOpacity(0.34)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.32, size.height * 0.38),
      Offset(size.width * 0.68, size.height * 0.38),
      circuit,
    );
    canvas.drawLine(
      Offset(size.width * 0.32, size.height * 0.38),
      Offset(size.width * 0.32, size.height * 0.56),
      circuit,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, size.height * 0.38),
      Offset(size.width * 0.68, size.height * 0.56),
      circuit,
    );
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter oldDelegate) {
    return oldDelegate.fill != fill || oldDelegate.outline != outline || oldDelegate.innerGlow != innerGlow;
  }
}

class _HeatmapHero extends StatelessWidget {
  const _HeatmapHero({
    required this.delta,
    required this.isDark,
  });

  final double delta;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final emerald = const Color(0xFF16A34A);
    final cyan = const Color(0xFF22D3EE);
    final amber = const Color(0xFFF59E0B);
    final red = const Color(0xFFEF4444);

    return Transform.translate(
      offset: Offset(delta * 18, delta.abs() * 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 22,
            left: 18,
            child: _LocationChip(label: 'Tagum City', color: cyan),
          ),
          Positioned(
            top: 54,
            right: 24,
            child: _LocationChip(label: 'Panabo', color: emerald),
          ),
          Positioned(
            top: 172,
            left: 18,
            child: _LocationChip(label: 'Braulio', color: amber),
          ),
          Positioned(
            bottom: 82,
            right: 22,
            child: _LocationChip(label: 'Talaingod', color: red),
          ),
          Container(
            width: 288,
            height: 288,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  cyan.withOpacity(isDark ? 0.2 : 0.14),
                  cyan.withOpacity(0.03),
                ],
              ),
            ),
          ),
          Positioned(
            top: 36,
            child: _MapCard(isDark: isDark, cyan: cyan, emerald: emerald, amber: amber, red: red),
          ),
          Positioned(
            bottom: 24,
            right: 4,
            child: _AlertCard(
              isDark: isDark,
              title: 'Fake GCash Scam Reported in Tagum City.',
              subtitle: 'Real-time alert sent to nearby citizens.',
            ),
          ),
          Positioned(
            bottom: 32,
            left: 10,
            child: _PhoneAlertBubble(
              isDark: isDark,
              title: 'Live Alert',
              body: 'Scam activity is rising near your barangay.',
              accent: emerald,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF111D33) : Colors.white).withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.26)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.16),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 13,
                  color: isDark ? const Color(0xFFEAF2FF) : const Color(0xFF0F172A),
                ),
          ),
        ],
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({
    required this.isDark,
    required this.cyan,
    required this.emerald,
    required this.amber,
    required this.red,
  });

  final bool isDark;
  final Color cyan;
  final Color emerald;
  final Color amber;
  final Color red;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 286,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? const Color(0xFF16233D) : const Color(0xFFFDFEFF),
            isDark ? const Color(0xFF0B1425) : const Color(0xFFE8F2FB),
          ],
        ),
        border: Border.all(color: cyan.withOpacity(0.22)),
        boxShadow: [
          BoxShadow(
            color: cyan.withOpacity(0.18),
            blurRadius: 32,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _HeatmapPainter(
                  gridColor: (isDark ? Colors.white : const Color(0xFF334155)).withOpacity(isDark ? 0.05 : 0.07),
                  cyan: cyan,
                  emerald: emerald,
                  amber: amber,
                  red: red,
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 18,
              right: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Davao del Norte',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isDark ? const Color(0xFFF3F7FF) : const Color(0xFF0F172A),
                        ),
                  ),
                  Icon(Icons.my_location_rounded, size: 18, color: emerald),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.gridColor,
    required this.cyan,
    required this.emerald,
    required this.amber,
    required this.red,
  });

  final Color gridColor;
  final Color cyan;
  final Color emerald;
  final Color amber;
  final Color red;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    const step = 28.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final mapFill = Paint()
      ..shader = RadialGradient(
        colors: [
          cyan.withOpacity(0.22),
          emerald.withOpacity(0.16),
          amber.withOpacity(0.1),
          red.withOpacity(0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.36, 0.58, 0.74, 1.0],
      ).createShader(Rect.fromCenter(
        center: Offset(size.width * 0.52, size.height * 0.52),
        width: size.width * 0.9,
        height: size.height * 0.85,
      ));

    final mapPath = Path()
      ..moveTo(size.width * 0.16, size.height * 0.26)
      ..lineTo(size.width * 0.28, size.height * 0.20)
      ..lineTo(size.width * 0.46, size.height * 0.18)
      ..lineTo(size.width * 0.63, size.height * 0.26)
      ..lineTo(size.width * 0.80, size.height * 0.23)
      ..lineTo(size.width * 0.85, size.height * 0.41)
      ..lineTo(size.width * 0.74, size.height * 0.55)
      ..lineTo(size.width * 0.82, size.height * 0.72)
      ..lineTo(size.width * 0.62, size.height * 0.79)
      ..lineTo(size.width * 0.43, size.height * 0.83)
      ..lineTo(size.width * 0.22, size.height * 0.75)
      ..lineTo(size.width * 0.16, size.height * 0.58)
      ..lineTo(size.width * 0.20, size.height * 0.42)
      ..close();

    canvas.drawPath(mapPath, mapFill);

    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = cyan.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(mapPath, outline);

    final route = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.22)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(size.width * 0.26, size.height * 0.34), Offset(size.width * 0.76, size.height * 0.42), route);
    canvas.drawLine(Offset(size.width * 0.30, size.height * 0.66), Offset(size.width * 0.68, size.height * 0.34), route);
    canvas.drawLine(Offset(size.width * 0.38, size.height * 0.47), Offset(size.width * 0.76, size.height * 0.63), route);

    void pin(Offset center, Color color, double sizeFactor) {
      final glow = Paint()
        ..color = color.withOpacity(0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, 10 * sizeFactor, glow);
      final body = Paint()..color = color;
      canvas.drawCircle(center, 5.5 * sizeFactor, body);
      final stem = Paint()
        ..color = color
        ..strokeWidth = 3 * sizeFactor
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(center, Offset(center.dx, center.dy + 14 * sizeFactor), stem);
    }

    pin(Offset(size.width * 0.34, size.height * 0.33), cyan, 1);
    pin(Offset(size.width * 0.58, size.height * 0.41), emerald, 1.15);
    pin(Offset(size.width * 0.40, size.height * 0.63), amber, 0.9);
    pin(Offset(size.width * 0.70, size.height * 0.60), red, 1.25);
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor ||
        oldDelegate.cyan != cyan ||
        oldDelegate.emerald != emerald ||
        oldDelegate.amber != amber ||
        oldDelegate.red != red;
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.isDark,
    required this.title,
    required this.subtitle,
  });

  final bool isDark;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: (isDark ? const Color(0xFF0E1727) : Colors.white).withOpacity(0.96),
        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.18),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                'LIVE ALERT',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 12,
                      color: const Color(0xFFEF4444),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 13,
                  height: 1.15,
                  color: isDark ? const Color(0xFFEAF2FF) : const Color(0xFF0F172A),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? const Color(0xFF9FBCD8) : const Color(0xFF4F6478),
                  height: 1.3,
                ),
          ),
        ],
      ),
    );
  }
}

class _PhoneAlertBubble extends StatelessWidget {
  const _PhoneAlertBubble({
    required this.isDark,
    required this.title,
    required this.body,
    required this.accent,
  });

  final bool isDark;
  final String title;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 176,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: (isDark ? const Color(0xFF0E1727) : Colors.white).withOpacity(0.9),
        border: Border.all(color: accent.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: accent,
                  fontSize: 12,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? const Color(0xFFDBEAFE) : const Color(0xFF42566D),
                  height: 1.28,
                ),
          ),
        ],
      ),
    );
  }
}

class _CommunityAiHero extends StatelessWidget {
  const _CommunityAiHero({
    required this.delta,
    required this.isDark,
  });

  final double delta;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final emerald = const Color(0xFF16A34A);
    final cyan = const Color(0xFF22D3EE);
    final lime = const Color(0xFF84CC16);

    return Transform.translate(
      offset: Offset(delta * 18, delta.abs() * 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  emerald.withOpacity(isDark ? 0.2 : 0.16),
                  cyan.withOpacity(0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 26,
            left: 22,
            child: _CommunityNode(label: 'Schools', accent: cyan, icon: Icons.school_rounded),
          ),
          Positioned(
            top: 54,
            right: 20,
            child: _CommunityNode(label: 'Barangays', accent: emerald, icon: Icons.hub_rounded),
          ),
          Positioned(
            bottom: 70,
            left: 18,
            child: _CommunityNode(label: 'Businesses', accent: lime, icon: Icons.storefront_rounded),
          ),
          Positioned(
            bottom: 34,
            right: 22,
            child: _CommunityNode(label: 'Citizens', accent: cyan, icon: Icons.people_alt_rounded),
          ),
          Positioned(
            top: 96,
            child: _AiShieldCore(isDark: isDark, emerald: emerald, cyan: cyan),
          ),
          Positioned(
            bottom: 116,
            left: 38,
            child: _SuccessPill(
              label: 'Alert delivered',
              accent: lime,
              isDark: isDark,
            ),
          ),
          Positioned(
            bottom: 168,
            right: 28,
            child: _SuccessPill(
              label: 'Pattern learned',
              accent: emerald,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityNode extends StatelessWidget {
  const _CommunityNode({
    required this.label,
    required this.accent,
    required this.icon,
  });

  final String label;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: (isDark ? const Color(0xFF0E1727) : Colors.white).withOpacity(0.92),
        border: Border.all(color: accent.withOpacity(0.22)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.14),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 12,
                  color: isDark ? const Color(0xFFEAF2FF) : const Color(0xFF0F172A),
                ),
          ),
        ],
      ),
    );
  }
}

class _AiShieldCore extends StatelessWidget {
  const _AiShieldCore({
    required this.isDark,
    required this.emerald,
    required this.cyan,
  });

  final bool isDark;
  final Color emerald;
  final Color cyan;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 250,
            child: CustomPaint(
              painter: _ShieldPainter(
                fill: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(isDark ? 0.08 : 0.42),
                    emerald.withOpacity(isDark ? 0.16 : 0.2),
                  ],
                ),
                outline: cyan.withOpacity(0.92),
                innerGlow: emerald.withOpacity(0.45),
              ),
            ),
          ),
          Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  cyan.withOpacity(0.46),
                  emerald.withOpacity(0.22),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: cyan.withOpacity(0.24),
                  blurRadius: 42,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 48),
          ),
          Positioned(
            bottom: 44,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulseDot(color: emerald),
                const SizedBox(width: 10),
                _PulseDot(color: cyan),
                const SizedBox(width: 10),
                _PulseDot(color: const Color(0xFF84CC16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatelessWidget {
  const _PulseDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 1)],
      ),
    );
  }
}

class _SuccessPill extends StatelessWidget {
  const _SuccessPill({
    required this.label,
    required this.accent,
    required this.isDark,
  });

  final String label;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: (isDark ? const Color(0xFF0E1727) : Colors.white).withOpacity(0.92),
        border: Border.all(color: accent.withOpacity(0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 12,
                  color: isDark ? const Color(0xFFDAF6E4) : const Color(0xFF0F172A),
                ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.accent,
    required this.onPressed,
  });

  final String label;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(0.95),
                const Color(0xFF0F9D58),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 17,
                    letterSpacing: 0.1,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final active = Theme.of(context).colorScheme.primary;
    final inactive = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF52647A)
        : const Color(0xFFB2C2D1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final selected = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: selected ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: selected ? active : inactive,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: active.withOpacity(0.34),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class _OnboardingBackdrop extends StatelessWidget {
  const _OnboardingBackdrop({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final top = isDark ? const Color(0xFF0F172A) : const Color(0xFFEAF3FF);
    final bottom = isDark ? const Color(0xFF09111D) : const Color(0xFFD7EAF9);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: _GlowBlob(color: const Color(0xFF22D3EE).withOpacity(isDark ? 0.18 : 0.15), size: 220),
          ),
          Positioned(
            top: 100,
            right: -60,
            child: _GlowBlob(color: const Color(0xFF16A34A).withOpacity(isDark ? 0.14 : 0.12), size: 200),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: _GlowBlob(color: const Color(0xFF0EA5E9).withOpacity(isDark ? 0.13 : 0.1), size: 240),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ParticlePainter(isDark: isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0),
          ],
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);
    const count = 46;
    for (var i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 0.8 + random.nextDouble() * 1.8;
      final alpha = isDark ? 0.16 : 0.12;
      paint.color = (i.isEven ? const Color(0xFF22D3EE) : const Color(0xFF16A34A)).withOpacity(alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => oldDelegate.isDark != isDark;
}

class _HomePlaceholderScreen extends StatelessWidget {
  const _HomePlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_rounded, size: 72, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'DavnorShield is ready',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Replace this placeholder with your real home screen after onboarding.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFBCD0E6)
                          : const Color(0xFF466076),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

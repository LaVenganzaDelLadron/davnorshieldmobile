import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, required this.isDark});

  final bool isDark;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _BackgroundPainter(
            t: _controller.value,
            isDark: widget.isDark,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({required this.t, required this.isDark});

  final double t;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? const [Color(0xFF0F172A), Color(0xFF08111F)]
            : const [Color(0xFFEAF3FF), Color(0xFFD6E8F8)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    void glow(Offset center, double radius, Color color) {
      final p = Paint()
        ..shader = RadialGradient(colors: [color, color.withOpacity(0)]).createShader(
          Rect.fromCircle(center: center, radius: radius),
        );
      canvas.drawCircle(center, radius, p);
    }

    final c1 = Offset(size.width * (0.18 + 0.03 * math.sin(t * math.pi * 2)), size.height * 0.2);
    final c2 = Offset(size.width * 0.82, size.height * (0.28 + 0.02 * math.cos(t * math.pi * 2)));
    glow(c1, size.width * 0.32, const Color(0xFF22D3EE).withOpacity(isDark ? 0.12 : 0.1));
    glow(c2, size.width * 0.28, const Color(0xFF16A34A).withOpacity(isDark ? 0.1 : 0.08));

    final paint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF0F172A)).withOpacity(isDark ? 0.07 : 0.05)
      ..strokeWidth = 1;
    const step = 28.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final particlePaint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);
    for (var i = 0; i < 28; i++) {
      final px = (random.nextDouble() * size.width + t * 40 * (i.isEven ? 1 : -1)) % size.width;
      final py = (random.nextDouble() * size.height + t * 24 * (i % 3 - 1)) % size.height;
      particlePaint.color = (i.isEven ? const Color(0xFF22D3EE) : const Color(0xFF16A34A)).withOpacity(isDark ? 0.12 : 0.08);
      canvas.drawCircle(Offset(px, py), 1.4 + (i % 3) * 0.4, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.isDark != isDark;
  }
}

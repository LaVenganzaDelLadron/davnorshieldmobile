import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/onboarding_page_model.dart';

class HeroAnimation extends StatefulWidget {
  const HeroAnimation({
    super.key,
    required this.type,
  });

  final OnboardingAnimationType type;

  @override
  State<HeroAnimation> createState() => _HeroAnimationState();
}

class _HeroAnimationState extends State<HeroAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
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
        return switch (widget.type) {
          OnboardingAnimationType.shield => _ShieldHero(t: _controller.value),
          OnboardingAnimationType.map => _MapHero(t: _controller.value),
          OnboardingAnimationType.network => _NetworkHero(t: _controller.value),
        };
      },
    );
  }
}

class _ShieldHero extends StatelessWidget {
  const _ShieldHero({required this.t});

  final double t;

  @override
  Widget build(BuildContext context) {
    final pulse = 1 + (math.sin(t * math.pi * 2) * 0.03);
    return Stack(
      alignment: Alignment.center,
      children: [
        _GlowCircle(size: 240, color: AppColors.cyan.withOpacity(0.16 + 0.04 * pulse)),
        Transform.scale(
          scale: pulse,
          child: GlassLikePhone(
            child: CustomPaint(
              painter: _ShieldPainter(progress: t),
              child: const SizedBox(width: 190, height: 250),
            ),
          ),
        ),
        Positioned(
          top: 26,
          left: 28,
          child: _ThreatChip(label: 'SMS', color: const Color(0xFFFB7185), offset: math.sin(t * 2 * math.pi)),
        ),
        Positioned(
          top: 74,
          right: 28,
          child: _ThreatChip(label: 'QR', color: const Color(0xFFF59E0B), offset: math.cos(t * 2 * math.pi)),
        ),
      ],
    );
  }
}

class _MapHero extends StatelessWidget {
  const _MapHero({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _GlowCircle(size: 270, color: AppColors.emerald.withOpacity(0.12)),
        GlassLikePhone(
          width: 290,
          height: 280,
          child: CustomPaint(
            painter: _MapPainter(progress: t),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class _NetworkHero extends StatelessWidget {
  const _NetworkHero({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _GlowCircle(size: 260, color: AppColors.emerald.withOpacity(0.16)),
        GlassLikePhone(
          width: 290,
          height: 280,
          child: CustomPaint(
            painter: _NetworkPainter(progress: t),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _ThreatChip extends StatelessWidget {
  const _ThreatChip({required this.label, required this.color, required this.offset});
  final String label;
  final Color color;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offset * 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.88),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 12, color: AppColors.navy)),
      ),
    );
  }
}

class GlassLikePhone extends StatelessWidget {
  const GlassLikePhone({
    super.key,
    required this.child,
    this.width = 200,
    this.height = 240,
  });

  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: Colors.white.withOpacity(0.18),
        border: Border.all(color: Colors.white.withOpacity(0.28)),
        boxShadow: [BoxShadow(color: AppColors.cyan.withOpacity(0.14), blurRadius: 30)],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(34), child: child),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  _ShieldPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final shield = Path()
      ..moveTo(size.width * 0.5, size.height * 0.08)
      ..cubicTo(size.width * 0.8, size.height * 0.08, size.width * 0.9, size.height * 0.2, size.width * 0.9, size.height * 0.42)
      ..cubicTo(size.width * 0.9, size.height * 0.72, size.width * 0.7, size.height * 0.9, size.width * 0.5, size.height * 0.96)
      ..cubicTo(size.width * 0.3, size.height * 0.9, size.width * 0.1, size.height * 0.72, size.width * 0.1, size.height * 0.42)
      ..cubicTo(size.width * 0.1, size.height * 0.2, size.width * 0.2, size.height * 0.08, size.width * 0.5, size.height * 0.08)
      ..close();
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.cyan.withOpacity(0.55), AppColors.emerald.withOpacity(0.35)],
      ).createShader(Offset.zero & size);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..color = AppColors.cyan.withOpacity(0.18 + 0.05 * math.sin(progress * math.pi * 2))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.white.withOpacity(0.65);
    canvas.drawPath(shield, glow);
    canvas.drawPath(shield, fill);
    canvas.drawPath(shield, border);
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter oldDelegate) => oldDelegate.progress != progress;
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final map = Path()
      ..moveTo(size.width * 0.16, size.height * 0.28)
      ..lineTo(size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.48, size.height * 0.18)
      ..lineTo(size.width * 0.65, size.height * 0.26)
      ..lineTo(size.width * 0.82, size.height * 0.23)
      ..lineTo(size.width * 0.86, size.height * 0.42)
      ..lineTo(size.width * 0.76, size.height * 0.56)
      ..lineTo(size.width * 0.84, size.height * 0.73)
      ..lineTo(size.width * 0.62, size.height * 0.82)
      ..lineTo(size.width * 0.42, size.height * 0.84)
      ..lineTo(size.width * 0.2, size.height * 0.76)
      ..lineTo(size.width * 0.14, size.height * 0.58)
      ..close();
    final fill = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.cyan.withOpacity(0.22), AppColors.emerald.withOpacity(0.12), Colors.transparent],
      ).createShader(Rect.fromCenter(center: Offset(size.width * 0.52, size.height * 0.5), width: size.width, height: size.height));
    canvas.drawPath(map, fill);
    canvas.drawPath(map, Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = AppColors.cyan.withOpacity(0.6));
    for (final pin in [Offset(size.width * 0.35, size.height * 0.34), Offset(size.width * 0.57, size.height * 0.42), Offset(size.width * 0.7, size.height * 0.6)]) {
      final scale = 1 + math.sin(progress * math.pi * 2) * 0.12;
      canvas.drawCircle(pin, 8 * scale, Paint()..color = AppColors.emerald.withOpacity(0.18));
      canvas.drawCircle(pin, 4.5 * scale, Paint()..color = AppColors.emerald);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => oldDelegate.progress != progress;
}

class _NetworkPainter extends CustomPainter {
  _NetworkPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.42);
    final nodes = <Offset>[
      const Offset(-70, -40),
      const Offset(60, -50),
      const Offset(-80, 70),
      const Offset(80, 70),
      const Offset(0, 115),
    ].map((o) => center + o).toList();
    final line = Paint()..color = AppColors.cyan.withOpacity(0.3)..strokeWidth = 2;
    for (final node in nodes) {
      canvas.drawLine(center, node, line);
      final dot = Paint()..color = AppColors.emerald;
      canvas.drawCircle(node, 6, dot);
    }
    canvas.drawCircle(center, 28, Paint()..color = AppColors.cyan.withOpacity(0.24 + 0.06 * math.sin(progress * math.pi * 2)));
    canvas.drawCircle(center, 16, Paint()..color = Colors.white.withOpacity(0.92));
    canvas.drawCircle(center, 10, Paint()..color = AppColors.emerald);
  }

  @override
  bool shouldRepaint(covariant _NetworkPainter oldDelegate) => oldDelegate.progress != progress;
}

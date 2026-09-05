import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

enum AuthHeroVariant { welcome, login, signup }

class AuthHero extends StatefulWidget {
  const AuthHero({
    super.key,
    required this.variant,
  });

  final AuthHeroVariant variant;

  @override
  State<AuthHero> createState() => _AuthHeroState();
}

class _AuthHeroState extends State<AuthHero> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
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
        return switch (widget.variant) {
          AuthHeroVariant.welcome => _WelcomeHero(t: _controller.value),
          AuthHeroVariant.login => _LoginHero(t: _controller.value),
          AuthHeroVariant.signup => _SignupHero(t: _controller.value),
        };
      },
    );
  }
}

class _HeroBase extends StatelessWidget {
  const _HeroBase({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0.06),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: child,
    );
  }
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    return _HeroBase(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _Glow(t: t),
          Positioned(
            top: 28,
            child: Icon(Icons.location_pin, size: 30, color: AppColors.cyan.withOpacity(0.9)),
          ),
          Transform.translate(
            offset: Offset(0, math.sin(t * math.pi * 2) * 6),
            child: Container(
              width: 156,
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white.withOpacity(0.18),
                border: Border.all(color: Colors.white.withOpacity(0.22)),
              ),
              child: CustomPaint(painter: _ShieldPhonePainter(progress: t)),
            ),
          ),
          Positioned(
            top: 52,
            left: 26,
            child: _ThreatBadge(label: 'SMS', color: const Color(0xFFEF4444), t: t),
          ),
          Positioned(
            top: 92,
            right: 20,
            child: _ThreatBadge(label: 'QR', color: const Color(0xFFF59E0B), t: t + 0.3),
          ),
          Positioned(
            bottom: 42,
            left: 22,
            child: _ThreatBadge(label: 'LINK', color: const Color(0xFF22D3EE), t: t + 0.6),
          ),
        ],
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    return _HeroBase(
      child: Center(
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [AppColors.emerald.withOpacity(0.42), Colors.transparent]),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.shield_rounded, size: 88, color: Colors.white.withOpacity(0.92)),
              Positioned(
                bottom: 32,
                child: Text('Secure Login', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupHero extends StatelessWidget {
  const _SignupHero({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    return _HeroBase(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _Glow(t: t),
          CustomPaint(size: const Size(300, 220), painter: _NetworkPainter(progress: t)),
          Positioned(
            bottom: 28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text('Community secured by AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cyan.withOpacity(0.08 + 0.04 * math.sin(t * math.pi * 2).abs()),
      ),
    );
  }
}

class _ThreatBadge extends StatelessWidget {
  const _ThreatBadge({required this.label, required this.color, required this.t});
  final String label;
  final Color color;
  final double t;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, math.sin(t * math.pi * 2) * 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _ShieldPhonePainter extends CustomPainter {
  _ShieldPhonePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final shield = Path()
      ..moveTo(size.width * 0.5, size.height * 0.1)
      ..cubicTo(size.width * 0.76, size.height * 0.1, size.width * 0.86, size.height * 0.2, size.width * 0.86, size.height * 0.38)
      ..cubicTo(size.width * 0.86, size.height * 0.65, size.width * 0.68, size.height * 0.82, size.width * 0.5, size.height * 0.88)
      ..cubicTo(size.width * 0.32, size.height * 0.82, size.width * 0.14, size.height * 0.65, size.width * 0.14, size.height * 0.38)
      ..cubicTo(size.width * 0.14, size.height * 0.2, size.width * 0.24, size.height * 0.1, size.width * 0.5, size.height * 0.1)
      ..close();
    final fill = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.cyan.withOpacity(0.52), AppColors.emerald.withOpacity(0.36)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(shield, fill);
    canvas.drawPath(shield, Paint()..style = PaintingStyle.stroke..strokeWidth = 4..color = Colors.white.withOpacity(0.7));
    final pulse = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..color = AppColors.emerald.withOpacity(0.16 + 0.06 * math.sin(progress * math.pi * 2).abs())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(shield, pulse);
  }

  @override
  bool shouldRepaint(covariant _ShieldPhonePainter oldDelegate) => oldDelegate.progress != progress;
}

class _NetworkPainter extends CustomPainter {
  _NetworkPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.44);
    final nodes = [
      center + const Offset(-88, -52),
      center + const Offset(86, -44),
      center + const Offset(-90, 70),
      center + const Offset(92, 68),
    ];
    final line = Paint()
      ..strokeWidth = 2
      ..color = AppColors.cyan.withOpacity(0.32);
    for (final node in nodes) {
      canvas.drawLine(center, node, line);
      canvas.drawCircle(node, 6, Paint()..color = AppColors.emerald);
    }
    canvas.drawCircle(center, 28, Paint()..color = AppColors.cyan.withOpacity(0.24 + 0.05 * math.sin(progress * math.pi * 2).abs()));
    canvas.drawCircle(center, 14, Paint()..color = Colors.white.withOpacity(0.9));
  }

  @override
  bool shouldRepaint(covariant _NetworkPainter oldDelegate) => oldDelegate.progress != progress;
}

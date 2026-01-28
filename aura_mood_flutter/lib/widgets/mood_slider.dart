import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A pan gesture recognizer that wins the arena immediately,
/// preventing the parent ScrollView from stealing the gesture.
class _EagerPanGestureRecognizer extends PanGestureRecognizer {
  _EagerPanGestureRecognizer({super.supportedDevices});

  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}

class MoodSlider extends StatefulWidget {
  final String label;
  final int value;
  final Color minColor;
  final Color maxColor;
  final ValueChanged<int> onChanged;

  const MoodSlider({
    super.key,
    required this.label,
    required this.value,
    required this.minColor,
    required this.maxColor,
    required this.onChanged,
  });

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  bool _isDragging = false;

  static const double _startAngle = math.pi * 0.75;
  static const double _sweepAngle = math.pi * 1.5;
  static const double _ringSize = 120;

  Color get _currentColor {
    return Color.lerp(widget.minColor, widget.maxColor, (widget.value - 1) / 9)!;
  }

  void _handlePointer(Offset localPosition, double size) {
    final center = Offset(size / 2, size / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;

    var angle = math.atan2(dy, dx);

    // Normalize relative to start angle
    var relative = angle - _startAngle;
    if (relative < -math.pi) relative += 2 * math.pi;
    if (relative < 0) relative += 2 * math.pi;

    // Dead zone snap
    if (relative > _sweepAngle) {
      final distToStart = (2 * math.pi) - relative;
      final distToEnd = relative - _sweepAngle;
      widget.onChanged(distToStart < distToEnd ? 1 : 10);
      return;
    }

    final fraction = relative / _sweepAngle;
    final newValue = (fraction * 9 + 1).round().clamp(1, 10);
    if (newValue != widget.value) {
      widget.onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            // Use 120 as preferred size, but shrink if constrained
            final size = math.min(constraints.maxWidth, _ringSize);
            
            return SizedBox(
              width: size,
              height: size,
              child: RawGestureDetector(
                gestures: <Type, GestureRecognizerFactory>{
                  _EagerPanGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<_EagerPanGestureRecognizer>(
                    () => _EagerPanGestureRecognizer(),
                    (_EagerPanGestureRecognizer instance) {
                      instance
                        ..onStart = (details) {
                          setState(() => _isDragging = true);
                          _handlePointer(details.localPosition, size);
                        }
                        ..onUpdate = (details) {
                          _handlePointer(details.localPosition, size);
                        }
                        ..onEnd = (_) {
                          setState(() => _isDragging = false);
                        };
                    },
                  ),
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.glassBackground,
                    border: Border.all(color: AppColors.glassBorder),
                    boxShadow: [
                      if (_isDragging)
                        BoxShadow(
                          color: _currentColor.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 8,
                        ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: _MoodRingPainter(
                      value: widget.value,
                      minColor: widget.minColor,
                      maxColor: widget.maxColor,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.value}',
                        style: TextStyle(
                          fontSize: size * 0.26, // Scale text with size (32/120 ≈ 0.26)
                          fontWeight: FontWeight.bold,
                          color: _currentColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MoodRingPainter extends CustomPainter {
  final int value;
  final Color minColor;
  final Color maxColor;

  static const double _startAngle = math.pi * 0.75;
  static const double _sweepAngle = math.pi * 1.5;

  _MoodRingPainter({
    required this.value,
    required this.minColor,
    required this.maxColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 8.0;

    // Background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _startAngle,
      _sweepAngle,
      false,
      Paint()
        ..color = AppColors.glassBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Value arc with segmented gradient
    final valueFraction = (value - 1) / 9;
    final valueSweep = valueFraction * _sweepAngle;

    if (valueSweep > 0) {
      const segmentCount = 60;
      final activeSegments = (valueFraction * segmentCount).ceil().clamp(1, segmentCount);
      final segmentSweep = valueSweep / activeSegments;

      for (var i = 0; i < activeSegments; i++) {
        final t = activeSegments > 1 ? i / (activeSegments - 1) : 0.0;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          _startAngle + i * segmentSweep,
          segmentSweep + 0.02,
          false,
          Paint()
            ..color = Color.lerp(minColor, maxColor, t * valueFraction)!
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Thumb at current position
    final thumbAngle = _startAngle + valueFraction * _sweepAngle;
    final thumbPos = Offset(
      center.dx + radius * math.cos(thumbAngle),
      center.dy + radius * math.sin(thumbAngle),
    );
    final thumbColor = Color.lerp(minColor, maxColor, valueFraction)!;
    canvas.drawCircle(thumbPos, 10, Paint()..color = thumbColor);
    canvas.drawCircle(thumbPos, 5, Paint()..color = Colors.white);

    // Tick marks
    for (var i = 1; i <= 10; i++) {
      final tickFraction = (i - 1) / 9;
      final tickAngle = _startAngle + tickFraction * _sweepAngle;
      final inner = radius - 16;
      final outer = radius - 11;

      canvas.drawLine(
        Offset(center.dx + inner * math.cos(tickAngle), center.dy + inner * math.sin(tickAngle)),
        Offset(center.dx + outer * math.cos(tickAngle), center.dy + outer * math.sin(tickAngle)),
        Paint()
          ..color = i <= value
              ? Color.lerp(minColor, maxColor, tickFraction)!
              : AppColors.textMuted
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MoodRingPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

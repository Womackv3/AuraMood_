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

class SleepDial extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double minValue;
  final double maxValue;

  const SleepDial({
    super.key,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = 12,
  });

  @override
  State<SleepDial> createState() => _SleepDialState();
}

class _SleepDialState extends State<SleepDial> {
  // Config
  final double _startAngle = 135 * math.pi / 180; // Start at ~8 o'clock
  final double _sweepAngle = 270 * math.pi / 180; // Sweep 270 degrees

  void _updateValue(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Vector from center to touch
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    
    // Calculate angle in radians (-pi to pi)
    // atan2(y, x) returns angle from positive x-axis (3 o'clock)
    double angle = math.atan2(dy, dx);

    // Normalize angle to match our startAngle logic
    // We want the angle relative to "south" (6 o'clock) usually, or fit the 135-degree start.
    // Let's standardise: 0 is 3 o'clock. 
    // Our start is 135 deg (bottom left).
    // Let's rotate coordinates so start is 0.
    
    // simpler approach: convert angle to 0-2pi range starting from _startAngle
    double relativeAngle = angle - _startAngle;
    if (relativeAngle < 0) relativeAngle += 2 * math.pi;

    // Based on sweep angle, clamp/calculate progress
    double progress = relativeAngle / _sweepAngle;
    
    // Special handling for the "gap" at the bottom
    // If user touches in the gap, snap to nearest end
    if (progress > 1.0) {
      if (progress > 1.0 + (2 * math.pi - _sweepAngle) / 2) {
        progress = 0.0; // Closer to start
      } else {
        progress = 1.0; // Closer to end
      }
    }

    final newValue = widget.minValue + progress * (widget.maxValue - widget.minValue);
    // Round to nearest 0.5 for cleaner UX
    final rounded = (newValue * 2).round() / 2;
    
    if (rounded != widget.value) {
      widget.onChanged(rounded.clamp(widget.minValue, widget.maxValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sleep',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final size = math.min(constraints.maxWidth, 120.0);
            
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
                          _updateValue(details.localPosition, Size(size, size));
                        }
                        ..onUpdate = (details) {
                          _updateValue(details.localPosition, Size(size, size));
                        };
                    },
                  ),
                },
                child: Container(
                  // Add container decoration to match MoodSlider's "glass" look
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.glassBackground,
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: CustomPaint(
                    size: Size(size, size), 
                    painter: _DialPainter(
                      value: widget.value,
                      minValue: widget.minValue,
                      maxValue: widget.maxValue,
                      startAngle: _startAngle,
                      sweepAngle: _sweepAngle,
                      color: Color.lerp(AppColors.error, AppColors.success, widget.value / 12) ?? AppColors.accent,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.value.toStringAsFixed(1)}h',
                        style: TextStyle(
                          fontSize: size * 0.24, // Consistent scaling
                          fontWeight: FontWeight.bold,
                          color: Color.lerp(AppColors.error, AppColors.success, widget.value / 12),
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

class _DialPainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final double startAngle;
  final double sweepAngle;
  final Color color;

  _DialPainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Match MoodSlider's radius calculation (size/2 - 12)
    final radius = size.width / 2 - 12;
    
    // Background track
    final trackPaint = Paint()
      ..color = AppColors.glassBorder.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
      
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Active arc
    final progress = (value - minValue) / (maxValue - minValue);
    final activeAngle = progress * sweepAngle;
    
    final activePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      activeAngle,
      false,
      activePaint,
    );

    // Thumb (Handle)
    final thumbAngle = startAngle + activeAngle;
    final thumbX = center.dx + radius * math.cos(thumbAngle);
    final thumbY = center.dy + radius * math.sin(thumbAngle);
    final thumbCenter = Offset(thumbX, thumbY);
    
    // Thumb Glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(thumbCenter, 12, glowPaint);

    // Thumb Body
    final thumbPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(thumbCenter, 8, thumbPaint);
    
    // Thumb Border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(thumbCenter, 8, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _DialPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}

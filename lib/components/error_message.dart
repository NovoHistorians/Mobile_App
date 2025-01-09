import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class SamsungNotification extends StatefulWidget {
  final String message;
  final IconData icon;
  final Duration duration;
  final VoidCallback? onDismissed;
  final bool enableVibration;
  final NotificationType type;

  const SamsungNotification({
    Key? key,
    required this.message,
    required this.icon,
    this.duration = const Duration(seconds: 3),
    this.onDismissed,
    this.enableVibration = true,
    this.type = NotificationType.error,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String message,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
    bool enableVibration = true,
    NotificationType type = NotificationType.error,
  }) {
    OverlayState? overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 20,
        left: 16,
        right: 16,
        child: SamsungNotification(
          message: message,
          icon: icon,
          duration: duration,
          enableVibration: enableVibration,
          type: type,
          onDismissed: () {
            overlayEntry.remove();
            onDismissed?.call();
          },
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  State<SamsungNotification> createState() => _SamsungNotificationState();
}

// Add an enum for different notification types
enum NotificationType {
  error,
  success,
  warning,
  info,
}

class _SamsungNotificationState extends State<SamsungNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
    _triggerVibration();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismissed?.call();
        });
      }
    });
  }

  Future<void> _triggerVibration() async {
    if (!widget.enableVibration) return;

    // Check if device supports vibration
    bool? hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator ?? false) {
      switch (widget.type) {
        case NotificationType.error:
          // Error pattern: long vibration
          Vibration.vibrate(duration: 200);
          break;
        case NotificationType.warning:
          // Warning pattern: two short vibrations
          Vibration.vibrate(pattern: [0, 100, 100, 100]);
          break;
        case NotificationType.success:
          // Success pattern: one short vibration
          Vibration.vibrate(duration: 50);
          break;
        case NotificationType.info:
          // Info pattern: very short vibration
          Vibration.vibrate(duration: 20);
          break;
      }
    } else {
      // Fallback to haptic feedback if vibration is not available
      switch (widget.type) {
        case NotificationType.error:
          HapticFeedback.heavyImpact();
          break;
        case NotificationType.warning:
          HapticFeedback.mediumImpact();
          break;
        case NotificationType.success:
        case NotificationType.info:
          HapticFeedback.lightImpact();
          break;
      }
    }
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case NotificationType.error:
        return Colors.red[900] ?? Colors.red;
      case NotificationType.warning:
        return Colors.orange[900] ?? Colors.orange;
      case NotificationType.success:
        return Colors.green[900] ?? Colors.green;
      case NotificationType.info:
        return const Color.fromARGB(255, 100, 100, 100) ?? Colors.black;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onDismissed,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/logo_app.png',
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

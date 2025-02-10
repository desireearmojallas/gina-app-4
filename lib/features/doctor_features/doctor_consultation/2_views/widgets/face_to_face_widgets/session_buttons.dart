import 'package:flutter/material.dart';

class SessionControlButtons extends StatelessWidget {
  final bool isSessionStarted;
  final bool isSessionEnded;
  final bool isWithinTimeRange;
  final bool is15MinutesBeforeTheStartTime;
  final Size size;
  final VoidCallback onStartSession;
  final VoidCallback onEndSession;

  const SessionControlButtons({
    super.key,
    required this.isSessionStarted,
    required this.isSessionEnded,
    required this.isWithinTimeRange,
    required this.is15MinutesBeforeTheStartTime,
    required this.size,
    required this.onStartSession,
    required this.onEndSession,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton(
          icon: Icons.play_arrow_rounded,
          label: 'Begin Session',
          isEnabled: !isSessionStarted && !isSessionEnded && isWithinTimeRange,
          onTap: onStartSession,
        ),
        _buildButton(
          icon: Icons.stop_rounded,
          label: 'Conclude Session',
          isEnabled: isSessionStarted && !isSessionEnded && isWithinTimeRange,
          onTap: onEndSession,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size.width * 0.3,
        height: size.height * 0.12,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [
                    const Color(0xFFFB6C85)
                        .withOpacity(is15MinutesBeforeTheStartTime ? 0.6 : 1.0),
                    const Color(0xFFFF3D68)
                        .withOpacity(is15MinutesBeforeTheStartTime ? 0.6 : 1.0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : Colors.grey.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    spreadRadius: -2,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white.withOpacity(is15MinutesBeforeTheStartTime
                  ? 0.6
                  : isEnabled
                      ? 1.0
                      : 0.2),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(is15MinutesBeforeTheStartTime
                    ? 0.6
                    : isEnabled
                        ? 1.0
                        : 0.2),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

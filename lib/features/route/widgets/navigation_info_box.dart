import 'package:flutter/material.dart';

class NavigationInfoBox extends StatelessWidget {
  const NavigationInfoBox({
    super.key,
    required this.distance,
    required this.duration,
    required this.onCancel,
  });

  final double? distance;
  final double? duration;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    // if (distance == null || duration == null) {
    //   return const SizedBox.shrink();
    // }

    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            distance == null
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      Icon(Icons.route_outlined, color: Colors.white, size: 18),
                      SizedBox(width: 5),

                      Text(
                        "Distance: ${(distance! / 1000).toStringAsFixed(2)} km",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
            distance == null
                ? const SizedBox.shrink()
                : Text(
                    " • ETA: ${(duration! / 60).toStringAsFixed(0)} min",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

            Padding(
              padding: distance != null
                  ? const EdgeInsets.only(left: 8.0)
                  : EdgeInsets.zero,
              child: GestureDetector(
                onTap: onCancel,
                child: const Icon(Icons.close, color: Colors.red, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

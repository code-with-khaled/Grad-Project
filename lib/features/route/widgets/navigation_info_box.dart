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
    if (distance == null || duration == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Distance: ${(distance! / 1000).toStringAsFixed(2)} km",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "ETA: ${(duration! / 60).toStringAsFixed(0)} min",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: onCancel,
            child: const Icon(Icons.close, color: Colors.red, size: 22),
          ),
        ],
      ),
    );
  }
}

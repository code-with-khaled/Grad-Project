import 'package:flutter/material.dart';

class NumberedMarker extends StatelessWidget {
  final int number;
  final bool visited;

  const NumberedMarker({super.key, required this.number, this.visited = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: visited ? Colors.green : Colors.redAccent,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

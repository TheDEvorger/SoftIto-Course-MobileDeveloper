import 'package:flutter/material.dart';

class StokRozeti extends StatelessWidget {
  final int stok;

  const StokRozeti({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    final tukendiMi = stok == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tukendiMi ? Colors.red.shade100 : Colors.green.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: tukendiMi ? Colors.red.shade400 : Colors.green.shade400,
          width: 0.8,
        ),
      ),
      child: Text(
        tukendiMi ? 'Tükendi' : 'Stokta: $stok',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: tukendiMi ? Colors.red.shade800 : Colors.green.shade800,
        ),
      ),
    );
  }
}

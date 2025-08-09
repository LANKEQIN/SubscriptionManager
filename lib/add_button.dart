import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击事件暂时不做
      },
      child: Container(
        width: 56.0,
        height: 56.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepPurple,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 36.0,
        ),
      ),
    );
  }
}
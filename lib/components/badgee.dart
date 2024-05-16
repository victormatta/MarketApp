import 'package:flutter/material.dart';

class Bagdee extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const Bagdee({super.key, required this.child, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 3,
          top: -1,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color ?? Colors.purple
            ),
            constraints: const BoxConstraints(
              minHeight: 16,
              minWidth: 16,
            ),
            child: Text(value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10,
            color: Colors.white),
            ),
          ),
          )
      ],
    );
  }
}
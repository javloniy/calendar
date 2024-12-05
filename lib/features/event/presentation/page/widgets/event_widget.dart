import 'package:flutter/material.dart';

class EventWidget extends StatelessWidget {
  final double height;
  final int maxLines;
  final String text;
  final TextEditingController? textEditingController;

  const EventWidget({
    super.key,
    required this.height,
    required this.maxLines,
    required this.text,
    this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: textEditingController != null
          ? TextField(
        controller: textEditingController,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: text,
          border: InputBorder.none,
        ),
      )
          : Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}

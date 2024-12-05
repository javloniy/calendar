
import 'package:flutter/material.dart';

class EWidget extends StatelessWidget {
  final String eventName;
  final String eventDescription;
  final DateTime? startTime;
  final DateTime? finishTime;
  final Color color;

  const EWidget({
    super.key,
    required this.eventName,
    required this.eventDescription,
    required this.startTime,
    required this.finishTime,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border:  Border(top: BorderSide(color: color, width: 10)),
      ),
      child:  Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventName,
              style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Text(
              eventDescription,
              style:  TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                 Icon(Icons.access_time, size: 14, color: color),
                const SizedBox(width: 8),
                Text(
                  "${startTime!.hour}:${startTime!.minute}-${finishTime!.hour}:${finishTime!.minute}",
                  style:  TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
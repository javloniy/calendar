import 'package:calendar/features/data/models/event_model.dart';
import 'package:calendar/features/home/bloc/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/app_routes.dart';
import '../../../home/bloc/calendar_bloc.dart';
import '../../../home/bloc/calendar_state.dart';

class DetailsEvent extends StatefulWidget {
  final EventModel eventModel;

  const DetailsEvent({
    required this.eventModel,
    super.key,
  });

  @override
  State<DetailsEvent> createState() => _DetailsEventState();
}

class _DetailsEventState extends State<DetailsEvent> {
  String getTimeDifference() {
    if (widget.eventModel.eventStartTime != null && widget.eventModel.eventFinishTime != null) {
      Duration difference = widget.eventModel.eventFinishTime!.difference(widget.eventModel.eventStartTime!);

      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;

      return "$hours:$minutes";
    } else {
      return "Invalid times";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 3),
        child: AppBar(
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              context.pop(Routes.home);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                context.pushNamed(
                  Routes.event,
                  extra: widget.eventModel,
                );
              },
              child: const Icon(
                size: 16,
                Icons.edit,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
          ],
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocListener<CalendarBloc, CalendarState>(
              listener: (context, state) {
                if (state.isSuccess == true) context.pop();
                if (state.isLoading == false) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Malumot topilmadi"),
                  ));
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    widget.eventModel.eventName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.eventModel.eventDescription,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.eventModel.eventStartTime} - ',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${widget.eventModel.eventFinishTime}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 28),
        child: BlocListener<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if (state.isSuccess == true) context.pop();
            if (state.isLoading == false) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("no event "),
              ));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Reminder",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 10),
              Text(
                  getTimeDifference(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 28),
              const Text("Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 10),
              Text(widget.eventModel.eventDescription,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xfffde7e8),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            context.read<CalendarBloc>().add(DeleteEvent(
                  widget.eventModel.id!,
                  widget.eventModel.nowDateTime,
                ));
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.red),
              Text(
                'Delete Event',
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

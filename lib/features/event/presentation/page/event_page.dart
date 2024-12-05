import 'package:calendar/core/extensions/date_format.dart';
import 'package:calendar/features/event/presentation/page/widgets/event_widget.dart';
import 'package:calendar/features/event/presentation/page/widgets/w_text.dart';
import 'package:calendar/features/home/bloc/calendar_bloc.dart';
import 'package:calendar/features/home/bloc/calendar_state.dart';
import 'package:calendar/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/event_model.dart';
import '../../../home/bloc/calendar_event.dart';

class EventPage extends StatefulWidget {
  final EventModel? eventModel;

  const EventPage({super.key, this.eventModel});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late final TextEditingController eventNameController;
  late final TextEditingController eventDescriptionController;
  final ValueNotifier<int> colorCode = ValueNotifier<int>(0);

  late DateTime startTime;
  late DateTime finishTime;

  String dateFormat({required String formatCode, required DateTime dateTime}) {
    return DateFormat(formatCode).format(dateTime).toString();
  }

  bool checkInfo(
    String eventNameController,
    String eventDescriptionController,
    DateTime? startTime,
    DateTime? finishTime,
  ) {
    return eventNameController != "" && eventDescriptionController != "" && startTime != null && finishTime != null;
  }

  @override
  void initState() {
    eventNameController = TextEditingController(text: widget.eventModel?.eventName);
    eventDescriptionController = TextEditingController(text: widget.eventModel?.eventDescription);
    startTime = widget.eventModel?.eventStartTime ?? DateTime.now();
    finishTime = widget.eventModel?.eventFinishTime ?? DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    super.dispose();
  }

  void addEvent(CalendarState state) {
    if (checkInfo(
      eventNameController.text,
      eventDescriptionController.text,
      startTime,
      finishTime,
    )) {
      context.read<CalendarBloc>().add(
        AddEvent(
          EventModel(
            eventFinishTime: finishTime,
            eventStartTime: startTime,
            color: colors[selectedIndex],
            eventDescription: eventDescriptionController.text,
            eventName: eventNameController.text,
            createdAt: state.selectedDate.dateFormat(),
          ),
          state.selectedDate,
        ),
      );
      context.pop();
    }
  }


  void updateEvent(CalendarState state) {
    if (checkInfo(
      eventNameController.text,
      eventDescriptionController.text,
      startTime,
      finishTime,
    )) {
      context.read<CalendarBloc>().add(
        UpdateEvent(
          widget.eventModel!.copyWith(
            eventFinishTime: finishTime,
            eventStartTime: startTime,
            color: colors[selectedIndex],
            eventDescription: eventDescriptionController.text,
            eventName: eventNameController.text,
          ),
          state.selectedDate,
        ),
      );
      context.pop();
    }
  }

  Future<void> selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? TimeOfDay.fromDateTime(startTime) : TimeOfDay.fromDateTime(finishTime),
    );
    if (pickedTime != null) {
      setState(() {
        final selectedDate = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (isStartTime) {
          startTime = selectedDate;
        } else {
          finishTime = selectedDate;
        }
      });
    }
  }


  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.pink,
    Colors.black,
    Colors.cyan,
  ];
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                context.pop(Routes.home);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WText(text: 'Event name'),
                const SizedBox(height: 4),
                EventWidget(
                  height: 42,
                  maxLines: 1,
                  text: 'Event name...',
                  textEditingController: eventNameController,
                ),
                const SizedBox(height: 16),
                const WText(text: 'Event description'),
                const SizedBox(height: 4),
                EventWidget(
                  height: 120,
                  maxLines: 7,
                  text: 'Event description...',
                  textEditingController: eventDescriptionController,
                ),
                const SizedBox(height: 16),
                const WText(text: 'Priority color'),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(colors.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: colors[index],
                          border: Border.all(
                            color: selectedIndex == index ? Colors.black : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                const WText(text: 'Start time'),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => selectTime(context, true),
                  child: EventWidget(
                    height: 42,
                    maxLines: 1,
                    text: dateFormat(formatCode: 'HH:mm', dateTime: startTime),
                    textEditingController: null,
                  ),
                ),
                const SizedBox(height: 16),
                const WText(text: 'Finish time'),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => selectTime(context, false),
                  child: EventWidget(
                    height: 42,
                    maxLines: 1,
                    text: dateFormat(formatCode: 'HH:mm', dateTime: finishTime),
                    textEditingController: null,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (widget.eventModel != null) {
                  updateEvent(state);
                } else {
                  addEvent(state);
                }
              },
              child: Text(
                widget.eventModel == null ? "Add" : "Update",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

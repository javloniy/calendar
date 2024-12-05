import 'package:calendar/features/home/presentation/pages/widgets/e_widget.dart';
import 'package:calendar/services/event_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/app_routes.dart';
import '../../../data/models/event_model.dart';
import '../../bloc/calendar_bloc.dart';
import '../../bloc/calendar_event.dart';
import '../../bloc/calendar_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(GetAllEvent(date: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            String formattedDate = "${state.selectedDate.day} ${monthNames[state.selectedDate.month - 1]} ${state.selectedDate.year}";
            String weekDay = [
              "Yakshanba",
              "Dushanba",
              "Seyshanba",
              "Chorshanba",
              "Payshanba",
              "Juma",
              "Shanba",
            ][state.selectedDate.weekday % 7];

            return Column(
              children: [
                Text(
                  weekDay,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController controller = TextEditingController();
                  return AlertDialog(
                    title: const Text("Kun.Oy.Yil Kiriting"),
                    content: TextField(
                      controller: controller,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(hintText: "kk.oy.yyyy"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text("Bekor qilish"),
                      ),
                      TextButton(
                        onPressed: () {
                          final input = controller.text;
                          final parts = input.split(".");
                          if (parts.length == 3) {
                            final day = int.tryParse(parts[0]) ?? 0;
                            final month = int.tryParse(parts[1]) ?? 0;
                            final year = int.tryParse(parts[2]) ?? 0;
                            if (day > 0 && month > 0 && month <= 12 && year >= 1950 && year <= 2950) {
                              final newDate = DateTime(year, month, day);
                              if (day <= DateTime(year, month + 1, 0).day) {
                                context.read<CalendarBloc>().add(ChangeDateEvent(newDate));
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        child: const Text("Qo'shish"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        context.read<CalendarBloc>().add(PreviousMonthEvent());
                      },
                    ),
                    Text(
                      "${monthNames[state.currentMonth.month - 1]} ${state.currentMonth.year}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        context.read<CalendarBloc>().add(NextMonthEvent());
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ["Du", "Se", "Chor", "Pay", "Jum", "Shan", "Yak"].map((day) => Text(day, style: const TextStyle(fontWeight: FontWeight.bold))).toList(),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          itemCount: DateTime(state.currentMonth.year, state.currentMonth.month + 1, 0).day + DateTime(state.currentMonth.year, state.currentMonth.month, 1).weekday - 1,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                          itemBuilder: (context, index) {
                            final firstWeekday = DateTime(state.currentMonth.year, state.currentMonth.month, 1).weekday;
                            if (index < firstWeekday - 1) {
                              return const SizedBox.shrink();
                            }

                            final day = DateTime(
                              state.currentMonth.year,
                              state.currentMonth.month,
                              index - firstWeekday + 2,
                            );

                            final isToday = day.year == today.year && day.month == today.month && day.day == today.day;
                            final isSelectedDay = day.year == state.selectedDate.year && day.month == state.selectedDate.month && day.day == state.selectedDate.day;

                            return GestureDetector(
                              onTap: () {
                                context.read<CalendarBloc>().add(ChangeDateEvent(day));
                              },
                              child: BlocProvider(
                                create: (context) => CalendarBloc(EventService.instance),
                                child: DayButton(isToday: isToday, isSelectedDay: isSelectedDay, day: day),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Schedule",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(100, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              context.pushNamed(Routes.event);
                            },
                            child: const Text(
                              '+ Add Event',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: BlocBuilder<CalendarBloc, CalendarState>(
                          builder: (context, state) {
                            return ListView.separated(
                              scrollDirection: Axis.vertical,
                              controller: ScrollController(),
                              itemCount: state.eventModels.length,
                              separatorBuilder: (context, index) => SizedBox(height: size.height * 0.01),
                              itemBuilder: (context, index) {
                                final EventModel event = state.eventModels[index];
                                return GestureDetector(
                                  onTap: () {
                                    context.pushNamed(Routes.details, extra: event);
                                  },
                                  child: EWidget(
                                    eventName: event.eventName,
                                    eventDescription: event.eventDescription,
                                    startTime: event.eventStartTime,
                                    finishTime: event.eventFinishTime,
                                    color: event.color,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DayButton extends StatefulWidget {
  const DayButton({
    super.key,
    required this.isToday,
    required this.isSelectedDay,
    required this.day,
  });

  final bool isToday;
  final bool isSelectedDay;
  final DateTime day;

  @override
  State<DayButton> createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(GetAllEvent(date: widget.day));
  }

  @override
  void didUpdateWidget(covariant DayButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.day != oldWidget.day) {
      context.read<CalendarBloc>().add(GetAllEvent(date: widget.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        final events = state.eventModels
            .toList();

        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isToday
                ? Colors.blue
                : widget.isSelectedDay
                ? Colors.blue.withOpacity(0.5)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.day.day}",
                style: TextStyle(
                  color: widget.isToday || widget.isSelectedDay
                      ? Colors.white
                      : Colors.black,
                  fontWeight: widget.isToday || widget.isSelectedDay
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (events.isNotEmpty)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 2,
                  children: events.map((event) {
                    return CircleAvatar(
                      radius: 3,
                      backgroundColor: event.color,
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}


final List<String> monthNames = [
  "Yanvar", "Fevral", "Mart", "Aprel", "May", "Iyun", "Iyul", "Avgust",
  "Sentabr", "Oktabr", "Noyabr", "Dekabr",
];
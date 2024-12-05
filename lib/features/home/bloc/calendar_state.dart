import 'package:equatable/equatable.dart';

import '../../data/models/event_model.dart';

class CalendarState extends Equatable {
  final DateTime selectedDate;
  final DateTime currentMonth;
  // final DateTime? dateTime;
  final List<EventModel> eventModels;
  final bool isLoading;

  final bool? isSuccess;

  const CalendarState({
    required this.selectedDate,
    required this.currentMonth,
    // this.dateTime,
    this.eventModels = const [],
    this.isLoading = false,
    this.isSuccess,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? currentMonth,
    DateTime? dateTime,
    List<EventModel>? eventModels,
    bool? isLoading,
    bool? isSuccess,
  }) {
    return CalendarState(
      // dateTime: dateTime ?? this.dateTime,
      eventModels: eventModels ?? this.eventModels,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      selectedDate: selectedDate ?? this.selectedDate,
      currentMonth: currentMonth ?? this.currentMonth,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        currentMonth,
        // dateTime,
        eventModels,
        isLoading,
        isSuccess,
      ];
}

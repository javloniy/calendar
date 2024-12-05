import 'package:calendar/features/data/models/event_model.dart';
import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NextMonthEvent extends CalendarEvent {}

class PreviousMonthEvent extends CalendarEvent {}

class UpdateSelectedDateEvent extends CalendarEvent {
  final DateTime newDate;

  UpdateSelectedDateEvent(this.newDate);

  @override
  List<Object?> get props => [newDate];
}

class ChangeDateEvent extends CalendarEvent {
  final DateTime newDate;

  ChangeDateEvent(this.newDate);

  @override
  List<Object?> get props => [newDate];
}

class AddEvent extends CalendarEvent{
  final EventModel eventModel;
  final DateTime dateTime;

  AddEvent(this.eventModel, this.dateTime);
}

class DeleteEvent extends CalendarEvent{
  final int id;
  final DateTime dateTime;
  DeleteEvent(this.id, this.dateTime);
}

class UpdateEvent extends CalendarEvent{
  final EventModel eventModel;
  final DateTime dateTime;

  UpdateEvent(this.eventModel, this.dateTime);
}

class GetAllEvent extends CalendarEvent{
  final DateTime date;

  GetAllEvent({required this.date});
}





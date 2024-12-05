import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/event_services.dart';
import '../../data/models/event_model.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final EventService eventService;

  CalendarBloc(this.eventService)
      : super(CalendarState(
          selectedDate: DateTime.now(),
          currentMonth: DateTime.now(),
        )) {
    on<NextMonthEvent>((event, emit) {
      DateTime nextMonth = DateTime(state.currentMonth.year, state.currentMonth.month + 1, 1);

      if (nextMonth.year > 2950) {
        nextMonth = DateTime(1950, 1, 1);
      }

      emit(state.copyWith(currentMonth: nextMonth));
    });

    on<PreviousMonthEvent>((event, emit) {
      DateTime previousMonth = DateTime(state.currentMonth.year, state.currentMonth.month - 1, 1);

      if (previousMonth.year < 1950) {
        previousMonth = DateTime(2950, 12, 1);
      }

      emit(state.copyWith(currentMonth: previousMonth));
    });

    on<UpdateSelectedDateEvent>((event, emit) {
      emit(CalendarState(
        selectedDate: event.newDate,
        currentMonth: state.currentMonth,
      ));
      add(GetAllEvent(date: event.newDate));
    });
    on<ChangeDateEvent>((event, emit) {
      add(GetAllEvent(date: event.newDate));
      emit(state.copyWith(
        selectedDate: event.newDate,
        currentMonth: DateTime(event.newDate.year, event.newDate.month),
      ));
    });

    on<GetAllEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final List<EventModel> events = await eventService.getAllEvents(event.date);

        emit(state.copyWith(
          eventModels: events,
          isLoading: false,
        ));
      } catch (error, stack) {
        print(error);
        print(stack);
        emit(state.copyWith(isLoading: false));
      }
    });
    on<AddEvent>(_addEvent);

    on<UpdateEvent>(_updateEvent);

    on<DeleteEvent>(_deleteEvent);
  }

  Future<void> _addEvent(AddEvent event, Emitter<CalendarState> emit) async {
    print("Nimadir");
    emit(state.copyWith(isLoading: true));
    try {
      await eventService.addEvent(event.eventModel);
      emit(state.copyWith(isLoading: false));
      add(GetAllEvent(date: state.selectedDate));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _updateEvent(UpdateEvent event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await eventService.updateEvent(event.eventModel);
      add(GetAllEvent(date: state.selectedDate));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _deleteEvent(DeleteEvent event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await eventService.deleteEvent(event.id);
      emit(state.copyWith(isSuccess: true));
      add(GetAllEvent(date: state.selectedDate));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarState(DateRangePickerController()));

  void moveForward() {
    state.datePickerController.forward!();
  }

  void moveBackward() {
    state.datePickerController.backward!();
  }

  @override
  Future<void> close() async {
    super.close();
    state.datePickerController.dispose();
  }
}

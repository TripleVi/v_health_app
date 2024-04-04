import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'daily_activities_state.dart';

class DailyActivitiesCubit extends Cubit<DailyActivitiesState> {
  DailyActivitiesCubit() : super(DailyActivitiesInitial());
}

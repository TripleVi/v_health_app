import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupInitial()) {
    on<GroupEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

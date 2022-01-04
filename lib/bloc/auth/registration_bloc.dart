import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_hour_flutter/api/repository.dart';
import 'package:power_hour_flutter/model/user_model.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  Repository? repository;
  RegistrationBloc(this.repository) : super(RegistrationIsNotStartState());
  @override
  RegistrationState get initialState => RegistrationIsNotStartState();
  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegistrationFailed) {
      yield RegistrationFailedState();
    } else if (event is RegistrationCompleting) {
      final user = event.user;

      //print(user);
      AuthUser? userServerData = await repository!.getRegistrationAuthUser(
        user.email,
        event.password,
        user.full_name,
        user.phone
      );
      yield RegistrationStateCompleted(userServerData);
    } else if (event is RegistrationNotStarted) {
      yield RegistrationIsNotStartState();
    } else if (event is RegistrationStarted) {
      yield RegistrationStartedState();
    }
  }
}

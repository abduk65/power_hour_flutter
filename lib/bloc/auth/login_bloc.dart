import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_hour_flutter/api/repository.dart';
import 'package:power_hour_flutter/model/user_model.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState> {
  Repository? repository;
  LoginBloc(this.repository):super(LoginIsNotStartState()){
    repository = repository;
  }
  @override
  LoginState get initialState => LoginIsNotStartState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginCompletingFailed) {
      yield LoginCompletingFailedState();
    } else if (event is LoginCompleting) {
      AuthUser? userServerData = await repository!.getLoginAuthUser(event.email,event.password);
      // print("inside bloc  $userServerData");
      yield LoginCompletingStateCompleted(userServerData);
    } else if (event is LoginCompletingNotStarted) {
      yield LoginIsNotStartState();
    }else if (event is LoginCompletingStarted) {
      yield LoginCompletingStartedState();
    }
  }
}
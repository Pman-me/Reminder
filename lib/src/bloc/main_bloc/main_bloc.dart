import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify_me/src/configs/app_routes.dart';
import '../../core/constants/route_constant.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<MainNavigatedTo>(_onNavigatedTo);
  }

  _onNavigatedTo(MainNavigatedTo event, Emitter<MainState> emit) {
    Navigator.of(event.context).push(AppRoutes.generateRoute(
         RouteSettings(name: kSetNotifScreenRoute)));
  }
}

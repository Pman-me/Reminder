part of 'main_bloc.dart';

abstract class MainEvent extends Equatable{

  @override
  List<Object> get props =>[];
}

class MainNavigatedTo extends MainEvent{
  BuildContext context;

  MainNavigatedTo({required this.context});
}

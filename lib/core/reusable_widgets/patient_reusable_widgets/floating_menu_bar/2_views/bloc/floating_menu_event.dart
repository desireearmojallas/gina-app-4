part of 'floating_menu_bloc.dart';

abstract class FloatingMenuEvent extends Equatable {
  const FloatingMenuEvent();

  @override
  List<Object> get props => [];
}

class GetPatientNameEvent extends FloatingMenuEvent {}

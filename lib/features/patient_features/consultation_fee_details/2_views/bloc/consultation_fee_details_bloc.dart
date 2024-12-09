import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'consultation_fee_details_event.dart';
part 'consultation_fee_details_state.dart';

class ConsultationFeeDetailsBloc
    extends Bloc<ConsultationFeeDetailsEvent, ConsultationFeeDetailsState> {
  ConsultationFeeDetailsBloc() : super(ConsultationFeeDetailsInitial()) {}
}

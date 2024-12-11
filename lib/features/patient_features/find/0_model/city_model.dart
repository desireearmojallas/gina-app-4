import 'package:equatable/equatable.dart';
import 'package:geodesy/geodesy.dart';

class CityModel extends Equatable {
  final String name;
  final LatLng coordinates;

  const CityModel({
    required this.name,
    required this.coordinates,
  });

  @override
  List<Object> get props => [name, coordinates];
}

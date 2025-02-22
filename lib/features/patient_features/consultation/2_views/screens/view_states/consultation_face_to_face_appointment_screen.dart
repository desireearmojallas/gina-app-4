import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:icons_plus/icons_plus.dart';
import 'dart:ui' as ui;

class FaceToFaceAppointmentScreen extends StatefulWidget {
  final AppointmentModel appointment;
  final DoctorModel doctor;

  const FaceToFaceAppointmentScreen({
    super.key,
    required this.appointment,
    required this.doctor,
  });

  @override
  State<FaceToFaceAppointmentScreen> createState() =>
      _FaceToFaceAppointmentScreenState();
}

//! follow the doctor_office_address_map_view.dart for realtime marker updates

class _FaceToFaceAppointmentScreenState
    extends State<FaceToFaceAppointmentScreen> {
  late GoogleMapController mapController;
  LatLng? _patientLocation;
  late LatLng _doctorLocation;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  StreamSubscription<Position>? _positionStreamSubscription;
  BitmapDescriptor? _patientMarkerIcon;

  @override
  void initState() {
    super.initState();
    _doctorLocation = _parseLatLng(widget.doctor.officeLatLngAddress) ??
        const LatLng(10.3157, 123.8854);
    _getCurrentLocation();
    _listenToLocationChanges();
    _loadCustomMarker();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  /// Load custom marker icon
  Future<void> _loadCustomMarker() async {
    _patientMarkerIcon = await _createCircularMarker(
      Images.patientProfileIcon,
      120,
      Colors.white,
    );
  }

  /// Get the patient's current location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint('Location permission denied');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (!mounted) return;
    setState(() {
      _patientLocation = LatLng(position.latitude, position.longitude);
      _addMarkers();
      _drawRoute();
      _isLoading = false;
    });
  }

  /// Listen to location changes
  void _listenToLocationChanges() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        // distanceFilter: 10,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      if (!mounted) return;
      setState(() {
        _patientLocation = LatLng(position.latitude, position.longitude);
        _updatePatientMarker();
        _drawRoute();
      });
    });
  }

  /// Update the patient marker position
  void _updatePatientMarker() {
    final patientMarker = _markers.firstWhere(
      (marker) => marker.markerId == const MarkerId('patientLocation'),
      orElse: () => const Marker(markerId: MarkerId('patientLocation')),
    );

    _markers.remove(patientMarker);
    _markers.add(Marker(
      markerId: const MarkerId('patientLocation'),
      position: _patientLocation!,
      infoWindow: const InfoWindow(title: 'Your Location'),
      icon: _patientMarkerIcon ?? patientMarker.icon,
    ));
  }

  /// Parse LatLng from stored string
  LatLng? _parseLatLng(String? latLngString) {
    if (latLngString == null) return null;
    final regex = RegExp(r'LatLng\(([^,]+), ([^,]+)\)');
    final match = regex.firstMatch(latLngString);
    if (match == null) return null;
    final lat = double.tryParse(match.group(1)!);
    final lng = double.tryParse(match.group(2)!);
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  /// Add markers for patient and doctor locations
  Future<void> _addMarkers() async {
    final doctorMarker = await _createCircularMarker(
      Images.doctorProfileIcon1,
      120,
      Colors.white,
    );

    if (!mounted) return;
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('patientLocation'),
        position: _patientLocation!,
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: _patientMarkerIcon!,
      ));

      _markers.add(Marker(
        markerId: const MarkerId('doctorOffice'),
        position: _doctorLocation,
        infoWindow: InfoWindow(title: widget.doctor.officeMapsLocationAddress),
        icon: doctorMarker,
      ));
    });
  }

  Future<BitmapDescriptor> _createCircularMarker(
      String assetPath, int size, Color borderColor) async {
    final byteData = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: size,
      targetHeight: size,
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..isAntiAlias = true;
    final radius = size / 2;

    // 1. Create a circular clip path
    final path = Path();
    path.addOval(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius));
    canvas.clipPath(path);

    // 2. Draw the image (it will be clipped to the circle)
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(
          0, 0, size.toDouble(), size.toDouble()), // Scale to fit the circle
      paint,
    );

    // 3. Draw the border (after clipping the image)
    paint.color = borderColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 15.0;
    canvas.drawCircle(Offset(radius, radius), radius, paint);

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  /// Draw a polyline from Patient to Doctor
  Future<void> _drawRoute() async {
    if (_patientLocation == null) return;

    List<LatLng> polylineCoordinates =
        await _getPolylinePoints(_patientLocation!, _doctorLocation);

    debugPrint(
        'Polyline Coordinates: $polylineCoordinates'); // Debugging statement

    if (!mounted) return;
    setState(() {
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        color: GinaAppTheme.lightTertiaryContainer,
        width: 5,
        points: polylineCoordinates,
      ));
      debugPrint('Polyline added: $_polylines'); // Debugging statement
    });
  }

  /// Fetch route points using Google Directions API
  Future<List<LatLng>> _getPolylinePoints(
      LatLng start, LatLng destination) async {
    const String apiKey = 'AIzaSyBg5KxB2Rdw7UV86btx0YJFmGkfF3CXUbc';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] != 'OK') {
      debugPrint(
          'Error fetching directions: ${data['status']}'); // Debugging statement
      return [];
    }

    List<LatLng> routePoints = [];
    var steps = data['routes'][0]['legs'][0]['steps'];

    for (var step in steps) {
      var startLocation = step['start_location'];
      routePoints.add(LatLng(startLocation['lat'], startLocation['lng']));
      var endLocation = step['end_location'];
      routePoints.add(LatLng(endLocation['lat'], endLocation['lng']));
    }

    return routePoints;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final width = MediaQuery.of(context).size.width;
        final ginaTheme = Theme.of(context);

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.45,
          minChildSize: 0.2,
          maxChildSize: 0.55,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(5),
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 33,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.9),
                                    width: 3.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.transparent,
                                  foregroundImage:
                                      AssetImage(Images.patientProfileIcon),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.9),
                                  width: 3.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.transparent,
                                foregroundImage:
                                    AssetImage(Images.doctorProfileIcon1),
                              ),
                            ),
                          ],
                        ),
                        const Gap(40),
                        Flexible(
                          child: Text(
                            'Appointment with Dr. ${widget.doctor.name}',
                            style: ginaTheme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          MingCute.location_fill,
                          color: Colors.grey[500],
                          size: 16,
                        ),
                        const Gap(5),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Location:\n',
                                  style:
                                      ginaTheme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${widget.doctor.officeAddress}\n${widget.doctor.officeMapsLocationAddress}',
                                  style: ginaTheme.textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              MingCute.calendar_line,
                              color: Colors.grey[500],
                              size: 16,
                            ),
                            const Gap(5),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Date:\n',
                                      style: ginaTheme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${widget.appointment.appointmentDate}\n',
                                      style: ginaTheme.textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              MingCute.time_line,
                              color: Colors.grey[500],
                              size: 16,
                            ),
                            const Gap(5),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Time:\n',
                                      style: ginaTheme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${widget.appointment.appointmentTime}',
                                      style: ginaTheme.textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(20),
                    Text(
                      '*Please arrive at least 15 minutes before your scheduled appointment time to ensure a smooth check-in process.',
                      style: ginaTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      width: width * 0.9,
                      child: FilledButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Okay, got it!',
                          style: ginaTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: GinaAppTheme.lightOnTertiaryContainer,
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: GinaAppTheme.lightTertiaryContainer,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Remember to arrive early!',
                          style: ginaTheme.textTheme.bodySmall?.copyWith(
                            color: GinaAppTheme.lightTertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const Gap(70),
                    Center(
                      child: Text(
                        'Powered by Google Maps • GINA',
                        style: ginaTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CustomLoadingIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _doctorLocation,
                    zoom: 14,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showBottomSheet(context);
          },
          child: const Icon(Icons.info),
        ),
      ),
    );
  }
}

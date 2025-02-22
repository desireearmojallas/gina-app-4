import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;

class DoctorOfficeAddressMapView extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorOfficeAddressMapView({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorOfficeAddressMapView> createState() =>
      _DoctorOfficeAddressMapViewState();
}

class _DoctorOfficeAddressMapViewState
    extends State<DoctorOfficeAddressMapView> {
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
      icon: _patientMarkerIcon ?? patientMarker.icon, // Use the custom icon
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Office Address',
      ),
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
    );
  }
}

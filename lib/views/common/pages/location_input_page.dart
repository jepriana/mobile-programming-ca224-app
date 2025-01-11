import 'package:flutter/material.dart';

class LocationInputPage extends StatelessWidget {
  final Function(String location, double latitude, double longitude)
      onLocationSelected;
  final String? initialLocation;
  final double? initialLatitude;
  final double? initialLongitude;

  const LocationInputPage({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Placeholder(),
    );
  }
}

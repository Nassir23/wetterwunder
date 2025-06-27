import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/location_model.dart';

class LocationService extends ChangeNotifier {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  LocationModel? _currentLocation;
  List<LocationModel> _savedLocations = [];
  LocationModel? _selectedLocation;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  LocationModel? get currentLocation => _currentLocation;
  List<LocationModel> get savedLocations => _savedLocations;
  LocationModel? get selectedLocation => _selectedLocation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Keys for SharedPreferences
  static const String _savedLocationsKey = 'saved_locations';
  static const String _selectedLocationKey = 'selected_location';

  // Initialize the service
  Future<void> initialize() async {
    await _loadSavedLocations();
    await _loadSelectedLocation();
  }

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  // Get current position using GPS
  Future<Position?> getCurrentPosition() async {
    try {
      _setLoading(true);
      _clearError();

      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError(
            'Location services are disabled. Please enable them in settings.');
        return null;
      }

      // Check and request permission
      LocationPermission permission = await requestLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _setError('Location permission denied. Please enable location access.');
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      return position;
    } catch (e) {
      _setError('Failed to get current location: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get current location with address
  Future<LocationModel?> getCurrentLocationWithAddress() async {
    try {
      Position? position = await getCurrentPosition();
      if (position == null) return null;

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        LocationModel location = LocationModel(
          name: placemark.locality ??
              placemark.subAdministrativeArea ??
              'Unknown',
          country: placemark.country ?? 'Unknown',
          state: placemark.administrativeArea ?? '',
          latitude: position.latitude,
          longitude: position.longitude,
          isCurrentLocation: true,
          lastUpdated: DateTime.now(),
        );

        _currentLocation = location;
        notifyListeners();
        return location;
      }
    } catch (e) {
      _setError('Failed to get address: ${e.toString()}');
    }

    return null;
  }

  // Search locations by name
  Future<List<LocationModel>> searchLocationsByName(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      _setLoading(true);
      _clearError();

      List<Location> locations = await locationFromAddress(query);
      List<LocationModel> results = [];

      for (Location location in locations.take(10)) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark placemark = placemarks.first;

            LocationModel locationModel = LocationModel(
              name: placemark.locality ??
                  placemark.subAdministrativeArea ??
                  query,
              country: placemark.country ?? 'Unknown',
              state: placemark.administrativeArea ?? '',
              latitude: location.latitude,
              longitude: location.longitude,
              isCurrentLocation: false,
            );

            results.add(locationModel);
          }
        } catch (e) {
          // Skip this location if geocoding fails
          continue;
        }
      }

      return results;
    } catch (e) {
      _setError('Failed to search locations: ${e.toString()}');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Save a location
  Future<void> saveLocation(LocationModel location) async {
    // Check if location already exists
    bool exists = _savedLocations.any((saved) =>
        saved.name == location.name && saved.country == location.country);

    if (!exists) {
      _savedLocations.add(location);
      await _saveSavedLocations();
      notifyListeners();
      Fluttertoast.showToast(
        msg: 'Location saved successfully',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Location already saved',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  // Remove a saved location
  Future<void> removeSavedLocation(LocationModel location) async {
    _savedLocations.removeWhere((saved) =>
        saved.name == location.name && saved.country == location.country);

    // If removed location was selected, clear selection
    if (_selectedLocation != null &&
        _selectedLocation!.name == location.name &&
        _selectedLocation!.country == location.country) {
      _selectedLocation = null;
      await _saveSelectedLocation();
    }

    await _saveSavedLocations();
    notifyListeners();
    Fluttertoast.showToast(
      msg: 'Location removed',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  // Set selected location
  Future<void> setSelectedLocation(LocationModel location) async {
    _selectedLocation = location;
    await _saveSelectedLocation();
    notifyListeners();
  }

  // Clear selected location
  Future<void> clearSelectedLocation() async {
    _selectedLocation = null;
    await _saveSelectedLocation();
    notifyListeners();
  }

  // Get weather location (selected or current)
  LocationModel? getWeatherLocation() {
    return _selectedLocation ?? _currentLocation;
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Persistence methods
  Future<void> _loadSavedLocations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? locationsJson = prefs.getString(_savedLocationsKey);

      if (locationsJson != null) {
        List<dynamic> locationsList = jsonDecode(locationsJson);
        _savedLocations =
            locationsList.map((json) => LocationModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Failed to load saved locations: $e');
    }
  }

  Future<void> _saveSavedLocations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String locationsJson = jsonEncode(
        _savedLocations.map((location) => location.toJson()).toList(),
      );
      await prefs.setString(_savedLocationsKey, locationsJson);
    } catch (e) {
      debugPrint('Failed to save locations: $e');
    }
  }

  Future<void> _loadSelectedLocation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? locationJson = prefs.getString(_selectedLocationKey);

      if (locationJson != null) {
        _selectedLocation = LocationModel.fromJson(jsonDecode(locationJson));
      }
    } catch (e) {
      debugPrint('Failed to load selected location: $e');
    }
  }

  Future<void> _saveSelectedLocation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_selectedLocation != null) {
        String locationJson = jsonEncode(_selectedLocation!.toJson());
        await prefs.setString(_selectedLocationKey, locationJson);
      } else {
        await prefs.remove(_selectedLocationKey);
      }
    } catch (e) {
      debugPrint('Failed to save selected location: $e');
    }
  }

  // Open device location settings
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      _setError('Could not open location settings');
    }
  }

  // Open app settings
  Future<void> openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      _setError('Could not open app settings');
    }
  }
}

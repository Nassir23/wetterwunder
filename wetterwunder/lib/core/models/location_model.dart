class LocationModel {
  final String name;
  final String country;
  final String state;
  final double latitude;
  final double longitude;
  final bool isCurrentLocation;
  final DateTime? lastUpdated;

  LocationModel({
    required this.name,
    required this.country,
    this.state = '',
    required this.latitude,
    required this.longitude,
    this.isCurrentLocation = false,
    this.lastUpdated,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      isCurrentLocation: json['isCurrentLocation'] ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'isCurrentLocation': isCurrentLocation,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  String get displayName {
    if (state.isNotEmpty && state != name) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }

  String get shortDisplayName {
    if (state.isNotEmpty && state != name) {
      return '$name, $state';
    }
    return name;
  }

  LocationModel copyWith({
    String? name,
    String? country,
    String? state,
    double? latitude,
    double? longitude,
    bool? isCurrentLocation,
    DateTime? lastUpdated,
  }) {
    return LocationModel(
      name: name ?? this.name,
      country: country ?? this.country,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          country == other.country &&
          state == other.state &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode =>
      name.hashCode ^
      country.hashCode ^
      state.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;

  @override
  String toString() {
    return 'LocationModel{name: $name, country: $country, state: $state, lat: $latitude, lng: $longitude, isCurrent: $isCurrentLocation}';
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/benefit_card_widget.dart';
import './widgets/location_icon_widget.dart';

class LocationPermissionOnboarding extends StatefulWidget {
  const LocationPermissionOnboarding({super.key});

  @override
  State<LocationPermissionOnboarding> createState() =>
      _LocationPermissionOnboardingState();
}

class _LocationPermissionOnboardingState
    extends State<LocationPermissionOnboarding> {
  bool _isLoading = false;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _locationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),

                  // Weather location icon
                  LocationIconWidget(),

                  SizedBox(height: 6.h),

                  // Headline
                  Text(
                    'Get Weather for Your Location',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 2.h),

                  // Supporting text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Allow location access to get automatic weather updates, severe weather alerts, and accurate hourly forecasts for your exact location.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Benefits showcase
                  _buildBenefitsSection(),

                  SizedBox(height: 8.h),

                  // Primary button - Enable Location
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleEnableLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'location_on',
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Enable Location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Secondary button - Manual location
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _handleManualLocation,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'search',
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Enter Location Manually',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Privacy note
                  _buildPrivacyNote(),

                  SizedBox(height: 2.h),
                ],
              ),
            ),

            // Skip button in top-right corner
            Positioned(
              top: 2.h,
              right: 4.w,
              child: TextButton(
                onPressed: _isLoading ? null : _handleSkip,
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                ),
                child: Text(
                  'Skip',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    final benefits = [
      {
        'icon': 'refresh',
        'title': 'Automatic Updates',
        'description': 'Get real-time weather updates without manual refresh',
      },
      {
        'icon': 'warning',
        'title': 'Severe Weather Alerts',
        'description':
            'Receive instant notifications for dangerous weather conditions',
      },
      {
        'icon': 'schedule',
        'title': 'Hourly Forecasts',
        'description': 'Access detailed hour-by-hour weather predictions',
      },
    ];

    return Column(
      children: benefits.map((benefit) {
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: BenefitCardWidget(
            icon: benefit['icon'] as String,
            title: benefit['title'] as String,
            description: benefit['description'] as String,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrivacyNote() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'privacy_tip',
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Protected',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 0.5.h),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                    children: [
                      const TextSpan(
                        text:
                            'Your location data is used only for weather services. View our ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' for details.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleEnableLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check location services
      bool serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Request permission
      LocationPermission permission =
          await _locationService.requestLocationPermission();

      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
      } else if (permission == LocationPermission.deniedForever) {
        _showPermissionDeniedForeverDialog();
      } else {
        // Permission granted, get location
        final location = await _locationService.getCurrentLocationWithAddress();

        if (location != null) {
          _showSuccessConfirmation();
          // Set as selected location and navigate
          await _locationService.setSelectedLocation(location);
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/weather-dashboard');
            }
          });
        } else {
          _showLocationErrorDialog();
        }
      }
    } catch (e) {
      _showLocationErrorDialog();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleManualLocation() {
    // Navigate to location management for manual selection
    Navigator.pushNamed(context, '/location-management');
  }

  void _handleSkip() {
    // Navigate to dashboard without location
    Navigator.pushReplacementNamed(context, '/weather-dashboard');
  }

  void _showSuccessConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Location access enabled successfully!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'location_off',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              const Text('Location Services Disabled'),
            ],
          ),
          content: const Text(
            'Location services are disabled on this device. Please enable them in Settings to use GPS location.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleManualLocation();
              },
              child: const Text('Use Manual Location'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _locationService.openLocationSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'location_off',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              const Text('Location Permission Denied'),
            ],
          ),
          content: const Text(
            'Location permission was denied. You can try again or enter your location manually.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleManualLocation();
              },
              child: const Text('Manual Location'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleEnableLocation();
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'block',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              const Text('Location Permission Blocked'),
            ],
          ),
          content: const Text(
            'Location permission has been permanently denied. Please enable it in app settings to use GPS location.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleManualLocation();
              },
              child: const Text('Manual Location'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _locationService.openAppSettings();
              },
              child: const Text('App Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'error',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              const Text('Location Error'),
            ],
          ),
          content: Text(
            _locationService.errorMessage ??
                'Failed to get your current location. Please try again or enter location manually.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleManualLocation();
              },
              child: const Text('Manual Location'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleEnableLocation();
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }
}

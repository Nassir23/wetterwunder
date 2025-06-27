import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _loadingRotationAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _loadingRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.linear,
    ));

    _logoAnimationController.forward();
    _loadingAnimationController.repeat();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization steps
      await _checkLocationPermissions();
      await _loadCachedWeatherData();
      await _fetchUserPreferences();
      await _prepareApiConnections();

      // Navigate based on initialization results
      await _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  Future<void> _checkLocationPermissions() async {
    setState(() {
      _initializationStatus = 'Checking location permissions...';
    });
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadCachedWeatherData() async {
    setState(() {
      _initializationStatus = 'Loading cached weather data...';
    });
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _fetchUserPreferences() async {
    setState(() {
      _initializationStatus = 'Fetching user preferences...';
    });
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _prepareApiConnections() async {
    setState(() {
      _initializationStatus = 'Preparing API connections...';
    });
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _navigateToNextScreen() async {
    setState(() {
      _initializationStatus = 'Ready!';
      _isInitializing = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      // Simulate navigation logic based on user state
      final bool hasLocationPermission = true; // Mock permission check
      final bool isFirstTimeUser = false; // Mock first-time user check

      if (isFirstTimeUser) {
        Navigator.pushReplacementNamed(
            context, '/location-permission-onboarding');
      } else if (hasLocationPermission) {
        Navigator.pushReplacementNamed(context, '/weather-dashboard');
      } else {
        Navigator.pushReplacementNamed(
            context, '/location-permission-onboarding');
      }
    }
  }

  void _handleInitializationError(dynamic error) {
    setState(() {
      _initializationStatus = 'Initialization failed';
      _isInitializing = false;
    });

    // Show error and navigate to offline mode after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/weather-dashboard');
      }
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.7),
              AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.5),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFadeAnimation,
                        child: ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLoadingIndicator(),
                    SizedBox(height: 3.h),
                    _buildStatusText(),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'wb_sunny',
            color: Colors.white,
            size: 12.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'WetterWunder',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _loadingRotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _loadingRotationAnimation.value * 2 * 3.14159,
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: CustomIconWidget(
              iconName: _isInitializing ? 'cloud' : 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusText() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        _initializationStatus,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

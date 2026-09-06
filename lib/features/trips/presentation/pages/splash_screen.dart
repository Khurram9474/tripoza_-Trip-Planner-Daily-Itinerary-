import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _glowController;
  late final AnimationController _orbitController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _logoRotation;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Main entrance animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Continuous glow animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Slow orbit animation
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.0,
        0.65,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.72,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.0,
          0.75,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _logoRotation = Tween<double>(
      begin: -0.025,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOut,
      ),
    );

    _textFade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.45,
        1.0,
        curve: Curves.easeOut,
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.45,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _mainController.forward();

    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(
      const Duration(milliseconds: 2800),
    );

    if (!mounted) return;

    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _glowController.dispose();
    _orbitController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final logoSize = math.min(
      size.width * 0.42,
      180.0,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF090B18),
              Color(0xFF11152A),
              Color(0xFF17152B),
              Color(0xFF080A14),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background decorative circles
            _buildBackgroundDecoration(),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _glowController,
                          _orbitController,
                        ]),
                        builder: (context, child) {
                          final glowValue =
                              0.45 + (_glowController.value * 0.35);

                          return Transform.rotate(
                            angle: _logoRotation.value,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow behind logo
                                Container(
                                  width: logoSize + 40,
                                  height: logoSize + 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFE94560,
                                        ).withOpacity(glowValue * 0.35),
                                        blurRadius: 55,
                                        spreadRadius: 12,
                                      ),
                                      BoxShadow(
                                        color: const Color(
                                          0xFF5B5FEF,
                                        ).withOpacity(glowValue * 0.25),
                                        blurRadius: 80,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),

                                // Orbit ring
                                Transform.rotate(
                                  angle: _orbitController.value *
                                      math.pi *
                                      2,
                                  child: Container(
                                    width: logoSize + 30,
                                    height: logoSize + 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(
                                          0.08,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),

                                // Actual Tripoza logo
                                ClipOval(
                                  child: Image.asset(
                                    'assets/images/tripoza_logo.png',
                                    width: logoSize,
                                    height: logoSize,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        width: logoSize,
                                        height: logoSize,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.secondary,
                                        ),
                                        child: const Icon(
                                          Icons.travel_explore_rounded,
                                          size: 70,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // App name + tagline
                      FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: Column(
                            children: [
                              Text(
                                AppConstants.appName,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.displayLarge.copyWith(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                AppConstants.appTagline,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.tagline.copyWith(
                                  color: Colors.white.withOpacity(0.65),
                                  fontSize: 14,
                                  letterSpacing: 0.4,
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Loading indicator
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.65),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom branding
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textFade,
                child: Text(
                  'EXPLORE • PLAN • EXPERIENCE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecoration() {
    return IgnorePointer(
      child: Stack(
        children: [
          // Top-right glow
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE94560).withOpacity(0.07),
              ),
            ),
          ),

          // Bottom-left glow
          Positioned(
            bottom: -120,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF5B5FEF).withOpacity(0.07),
              ),
            ),
          ),

          // Decorative travel dots
          Positioned(
            top: 120,
            left: 45,
            child: _dot(5),
          ),

          Positioned(
            top: 190,
            right: 55,
            child: _dot(3),
          ),

          Positioned(
            bottom: 180,
            right: 45,
            child: _dot(4),
          ),

          Positioned(
            bottom: 130,
            left: 65,
            child: _dot(3),
          ),
        ],
      ),
    );
  }

  Widget _dot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.25),
      ),
    );
  }
}
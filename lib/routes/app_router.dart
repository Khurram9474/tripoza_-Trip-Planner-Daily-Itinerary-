import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/features/activities/presentation/widgets/itinerary_screen.dart';
import 'package:tripora/features/trips/presentation/pages/my_trip_screen.dart';
import '../features/trips/presentation/pages/splash_screen.dart';
import '../features/trips/presentation/pages/home_screen.dart';
import '../features/trips/presentation/pages/create_trip_screen.dart';
import '../features/trips/presentation/pages/trip_details_screen.dart';
import '../features/activities/presentation/pages/add_activity_screen.dart';
import '../features/activities/presentation/pages/edit_activity_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const home = '/home';
  static const myTrips = '/my-trips';
  static const createTrip = '/create-trip';
  static const editTrip = '/edit-trip/:tripId';
  static const tripDetails = '/trip/:tripId';
  static const itinerary = '/trip/:tripId/itinerary';
  static const addActivity = '/trip/:tripId/add-activity';
  static const editActivity = '/trip/:tripId/activity/:activityId/edit';

  static String editTripPath(String tripId) => '/edit-trip/$tripId';
  static String tripDetailsPath(String tripId) => '/trip/$tripId';
  static String itineraryPath(String tripId) => '/trip/$tripId/itinerary';
  static String addActivityPath(String tripId) => '/trip/$tripId/add-activity';
  static String editActivityPath(String tripId, String activityId) =>
      '/trip/$tripId/activity/$activityId/edit';
}

/// Shared fade+slide transition for all routes except the splash screen.
CustomTransitionPage<void> _buildPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.03),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => _buildPage(const HomeScreen()),
    ),
    GoRoute(
      path: AppRoutes.myTrips,
      pageBuilder: (context, state) => _buildPage(const MyTripsScreen()),
    ),
    GoRoute(
      path: AppRoutes.createTrip,
      pageBuilder: (context, state) => _buildPage(const CreateTripScreen()),
    ),
    GoRoute(
      path: AppRoutes.editTrip,
      pageBuilder: (context, state) {
        final tripId = state.pathParameters['tripId']!;
        return _buildPage(CreateTripScreen(editingTripId: tripId));
      },
    ),
    GoRoute(
      path: AppRoutes.tripDetails,
      pageBuilder: (context, state) {
        final tripId = state.pathParameters['tripId']!;
        return _buildPage(TripDetailsScreen(tripId: tripId));
      },
    ),
    GoRoute(
      path: AppRoutes.itinerary,
      pageBuilder: (context, state) {
        final tripId = state.pathParameters['tripId']!;
        return _buildPage(ItineraryScreen(tripId: tripId));
      },
    ),
    GoRoute(
      path: AppRoutes.addActivity,
      pageBuilder: (context, state) {
        final tripId = state.pathParameters['tripId']!;
        final dayParam = state.uri.queryParameters['day'];
        final preselectedDay = dayParam != null ? int.tryParse(dayParam) : null;
        return _buildPage(
          AddActivityScreen(tripId: tripId, preselectedDay: preselectedDay),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.editActivity,
      pageBuilder: (context, state) {
        final tripId = state.pathParameters['tripId']!;
        final activityId = state.pathParameters['activityId']!;
        return _buildPage(
          EditActivityScreen(tripId: tripId, activityId: activityId),
        );
      },
    ),
  ],
);
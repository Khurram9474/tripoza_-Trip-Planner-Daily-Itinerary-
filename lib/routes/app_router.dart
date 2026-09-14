import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/features/activities/presentation/widgets/itinerary_screen.dart';
import 'package:tripora/features/services/presentation/pages/booking_screen.dart';
import 'package:tripora/features/services/presentation/pages/booking_summary_screen.dart';
import 'package:tripora/features/services/presentation/pages/travel_services_screen.dart';
import 'package:tripora/features/trips/presentation/pages/my_trip_screen.dart';
import '../features/trips/presentation/pages/splash_screen.dart';
import '../features/trips/presentation/pages/home_screen.dart';
import '../features/trips/presentation/pages/create_trip_screen.dart';
import '../features/trips/presentation/pages/trip_details_screen.dart';
import '../features/activities/presentation/pages/add_activity_screen.dart';
import '../features/activities/presentation/pages/edit_activity_screen.dart';
import '../features/services/presentation/pages/service_details_screen.dart';
import '../features/bookings/presentation/pages/booking_confirmation_screen.dart';
import '../features/bookings/presentation/pages/my_bookings_screen.dart';
import '../features/bookings/presentation/pages/booking_details_screen.dart';

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

  // Week 5 — Travel Services & Booking
  static const services = '/services';
  static const serviceDetails = '/service/:id';
  static const booking = '/booking/:serviceId';
  static const bookingSummary = '/booking-summary';
  static const bookingConfirmation = '/booking-confirmation/:bookingId';
  static const myBookings = '/my-bookings';
  static const bookingDetails = '/booking-details/:bookingId';

  static String editTripPath(String tripId) => '/edit-trip/$tripId';
  static String tripDetailsPath(String tripId) => '/trip/$tripId';
  static String itineraryPath(String tripId) => '/trip/$tripId/itinerary';
  static String addActivityPath(String tripId) => '/trip/$tripId/add-activity';
  static String editActivityPath(String tripId, String activityId) =>
      '/trip/$tripId/activity/$activityId/edit';

  // Week 5 path builders
  static String serviceDetailsPath(String id) => '/service/$id';
  static String bookingPath(String serviceId) => '/booking/$serviceId';
  static String bookingConfirmationPath(String bookingId) => '/booking-confirmation/$bookingId';
  static String bookingDetailsPath(String bookingId) => '/booking-details/$bookingId';
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

    // ---------------- Week 5 — Travel Services & Booking ----------------
    GoRoute(
      path: AppRoutes.services,
      pageBuilder: (context, state) => _buildPage(const TravelServicesScreen()),
    ),
    GoRoute(
      path: AppRoutes.serviceDetails,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return _buildPage(ServiceDetailsScreen(serviceId: id));
      },
    ),
    GoRoute(
      path: AppRoutes.booking,
      pageBuilder: (context, state) {
        final serviceId = state.pathParameters['serviceId']!;
        return _buildPage(BookingScreen(serviceId: serviceId));
      },
    ),
    GoRoute(
      path: AppRoutes.bookingSummary,
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return _buildPage(
          BookingSummaryScreen(
            serviceId: args['serviceId'] as String,
            serviceName: args['serviceName'] as String,
            serviceCategory: args['serviceCategory'] as String,
            customerName: args['customerName'] as String,
            phone: args['phone'] as String,
            email: args['email'] as String,
            bookingDate: args['bookingDate'] as DateTime,
            numberOfPeople: args['numberOfPeople'] as int,
            pricePerPerson: args['pricePerPerson'] as double,
            specialRequest: args['specialRequest'] as String,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bookingConfirmation,
      pageBuilder: (context, state) {
        final bookingId = state.pathParameters['bookingId']!;
        return _buildPage(BookingConfirmationScreen(bookingId: bookingId));
      },
    ),
    GoRoute(
      path: AppRoutes.myBookings,
      pageBuilder: (context, state) => _buildPage(const MyBookingsScreen()),
    ),
    GoRoute(
      path: AppRoutes.bookingDetails,
      pageBuilder: (context, state) {
        final bookingId = state.pathParameters['bookingId']!;
        return _buildPage(BookingDetailsScreen(bookingId: bookingId));
      },
    ),
  ],
);
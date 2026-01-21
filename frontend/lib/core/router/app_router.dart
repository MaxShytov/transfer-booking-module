import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/booking/booking_detail_screen.dart';
import '../../presentation/screens/booking/extras_selection_screen.dart';
import '../../presentation/screens/booking/passenger_details_screen.dart';
import '../../presentation/screens/booking/review_screen.dart';
import '../../presentation/screens/booking/route_selection_screen.dart';
import '../../presentation/screens/booking/vehicle_selection_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../home_screen.dart';

/// Listenable for auth state changes to trigger router refresh.
class _AuthStateNotifierListenable extends ChangeNotifier {
  _AuthStateNotifierListenable(this._ref) {
    _ref.listen(authStateProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref _ref;
}

/// Provider for the router refresh listenable.
final _routerRefreshListenableProvider = Provider<_AuthStateNotifierListenable>((ref) {
  return _AuthStateNotifierListenable(ref);
});

/// Provider for the app router.
final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(_routerRefreshListenableProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      // Read current auth state inside redirect (not in provider creation)
      final container = ProviderScope.containerOf(context);
      final authState = container.read(authStateProvider);

      final isAuthenticated = authState.isAuthenticated;
      final isUnauthenticated = authState.isUnauthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      // Only redirect to login if explicitly unauthenticated
      // (not during loading, initial, or error states)
      if (isUnauthenticated && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      // If authenticated and on login/register, redirect to home
      if (isAuthenticated && (isLoggingIn || isRegistering)) {
        return '/';
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Booking wizard routes
      GoRoute(
        path: '/booking',
        name: 'booking',
        builder: (context, state) => const RouteSelectionScreen(),
      ),
      GoRoute(
        path: '/booking/route',
        name: 'booking-route',
        builder: (context, state) => const RouteSelectionScreen(),
      ),
      GoRoute(
        path: '/booking/vehicle',
        name: 'booking-vehicle',
        builder: (context, state) => const VehicleSelectionScreen(),
      ),
      GoRoute(
        path: '/booking/extras',
        name: 'booking-extras',
        builder: (context, state) => const ExtrasSelectionScreen(),
      ),
      GoRoute(
        path: '/booking/passenger',
        name: 'booking-passenger',
        builder: (context, state) => const PassengerDetailsScreen(),
      ),
      GoRoute(
        path: '/booking/review',
        name: 'booking-review',
        builder: (context, state) => const ReviewScreen(),
      ),

      // Booking details route
      GoRoute(
        path: '/bookings/:id',
        name: 'booking-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BookingDetailScreen(bookingId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

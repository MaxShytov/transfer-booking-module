import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../data/models/booking.dart';
import '../data/models/fixed_route.dart';
import '../data/repositories/booking_repository.dart';
import '../data/repositories/routes_repository.dart';
import '../l10n/generated/app_localizations.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/booking_flow_provider.dart';
import '../presentation/widgets/atoms/gradient_button.dart';
import 'theme/app_dimensions.dart';

/// Provider for popular routes (fixed routes from API).
final popularRoutesProvider = FutureProvider<List<FixedRoute>>((ref) async {
  final repository = ref.watch(routesRepositoryProvider);
  return repository.getFixedRoutes();
});

/// Home screen with Cupertino tab navigation.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late CupertinoTabController _tabController;
  final GlobalKey<_BookingsListTabState> _bookingsListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController();
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    // Refresh bookings list when switching to the bookings tab
    if (_tabController.index == 1) {
      _bookingsListKey.currentState?.refreshBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle_outline),
            activeIcon: const Icon(Icons.add_circle),
            label: l10n.tabBook,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt_outlined),
            activeIcon: const Icon(Icons.list_alt),
            label: l10n.tabMyBookings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            activeIcon: const Icon(Icons.more_horiz),
            label: l10n.tabMore,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return _BookingTab();
              case 1:
                return _BookingsListTab(key: _bookingsListKey);
              case 2:
                return _MoreTab();
              default:
                return _BookingTab();
            }
          },
        );
      },
    );
  }
}

/// Booking tab with main action.
class _BookingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.appTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.account_circle),
          onPressed: () => context.push('/profile'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                l10n.bookTransfer,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                l10n.bookTransferSubtitle,
                style: TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXl),

              // Quick booking card - iOS grouped style
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppDimensions.paddingLg),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 64,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),
                    Text(
                      l10n.readyToTravel,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    Text(
                      l10n.bookingDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Booking button
                    GradientButton(
                      text: l10n.bookTransfer,
                      onPressed: () => context.push('/booking'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXl),

              // Popular routes section
              Text(
                l10n.popularRoutes,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              _PopularRoutesList(
                onRouteSelected: (route) => _startBookingWithRoute(context, ref, route),
                priceFromLabel: l10n.priceFrom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startBookingWithRoute(BuildContext context, WidgetRef ref, FixedRoute route) {
    final notifier = ref.read(bookingFlowProvider.notifier);

    // Reset booking state and set locations
    notifier.reset();
    notifier.setPickupLocation(SelectedLocation(
      address: route.pickupAddress,
      lat: route.pickupLat,
      lng: route.pickupLng,
      isPredefined: true,
    ));
    notifier.setDropoffLocation(SelectedLocation(
      address: route.dropoffAddress,
      lat: route.dropoffLat,
      lng: route.dropoffLng,
      isPredefined: true,
    ));

    // Navigate to booking
    context.push('/booking');
  }
}

/// Widget that loads and displays popular routes from API.
class _PopularRoutesList extends ConsumerWidget {
  final void Function(FixedRoute route) onRouteSelected;
  final String priceFromLabel;

  const _PopularRoutesList({
    required this.onRouteSelected,
    required this.priceFromLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesAsync = ref.watch(popularRoutesProvider);

    return routesAsync.when(
      data: (routes) => Column(
        children: routes.map((route) => _CupertinoPopularRouteCard(
          from: route.pickupAddress,
          to: route.dropoffAddress,
          price: '€${route.basePrice.toStringAsFixed(0)}',
          priceFromLabel: priceFromLabel,
          onTap: () => onRouteSelected(route),
        )).toList(),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: CupertinoActivityIndicator(),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Failed to load routes',
          style: TextStyle(
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ),
    );
  }
}

/// Bookings list tab.
class _BookingsListTab extends ConsumerStatefulWidget {
  const _BookingsListTab({super.key});

  @override
  ConsumerState<_BookingsListTab> createState() => _BookingsListTabState();
}

class _BookingsListTabState extends ConsumerState<_BookingsListTab>
    with WidgetsBindingObserver {
  List<BookingListItem>? _bookings;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBookings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _loadBookings();
    }
  }

  /// Public method to refresh bookings from parent widget.
  void refreshBookings() {
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated) {
      setState(() {
        _isLoading = false;
        _bookings = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final bookings = await ref.read(bookingRepositoryProvider).getBookings();
      if (mounted) {
        setState(() {
          _bookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authStateProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.tabMyBookings),
      ),
      child: SafeArea(
        child: !authState.isAuthenticated
            ? _buildLoginPrompt(context, l10n)
            : _isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : _error != null
                    ? _buildError(context, l10n)
                    : _bookings == null || _bookings!.isEmpty
                        ? _buildEmpty(context, l10n)
                        : _buildBookingsList(context, l10n),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 64,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            l10n.login,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            l10n.bookingHistoryWillAppear,
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          CupertinoButton.filled(
            child: Text(l10n.login),
            onPressed: () => context.push('/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time,
            size: 64,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            l10n.noBookingsYet,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            l10n.bookingHistoryWillAppear,
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: CupertinoColors.systemRed,
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            _error ?? 'Error',
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          CupertinoButton.filled(
            child: Text(l10n.retry),
            onPressed: _loadBookings,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, AppLocalizations l10n) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: _loadBookings,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final booking = _bookings![index];
                return _BookingCard(
                  booking: booking,
                  onTap: () => context.push('/bookings/${booking.id}'),
                );
              },
              childCount: _bookings!.length,
            ),
          ),
        ),
      ],
    );
  }
}

/// Booking card widget.
class _BookingCard extends StatelessWidget {
  final BookingListItem booking;
  final VoidCallback onTap;

  const _BookingCard({
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CupertinoColors.separator.resolveFrom(context),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: reference + badges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          booking.bookingReference,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: CupertinoColors.label,
                          ),
                        ),
                        if (booking.isRoundTrip) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemIndigo.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sync_alt,
                                  size: 10,
                                  color: CupertinoColors.systemIndigo,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Round Trip',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: CupertinoColors.systemIndigo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _StatusBadge(status: booking.status),
                ],
              ),
              const SizedBox(height: 12),
              // Route
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: CupertinoColors.systemGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.pickupAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: CupertinoColors.systemRed,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.dropoffAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Footer row: date/time + price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${booking.serviceDate} ${booking.pickupTime.substring(0, 5)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (booking.isRoundTrip && booking.returnDate != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.subdirectory_arrow_right,
                                size: 14,
                                color: CupertinoColors.systemIndigo.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${booking.returnDate} ${booking.returnTime?.substring(0, 5) ?? ''}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemIndigo.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '${booking.currency == 'EUR' ? '€' : booking.currency}${booking.finalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: CupertinoColors.systemBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Status badge widget.
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'pending':
        backgroundColor = CupertinoColors.systemYellow.withOpacity(0.2);
        textColor = CupertinoColors.systemOrange;
        break;
      case 'confirmed':
        backgroundColor = CupertinoColors.systemBlue.withOpacity(0.2);
        textColor = CupertinoColors.systemBlue;
        break;
      case 'in_progress':
        backgroundColor = CupertinoColors.systemPurple.withOpacity(0.2);
        textColor = CupertinoColors.systemPurple;
        break;
      case 'completed':
        backgroundColor = CupertinoColors.systemGreen.withOpacity(0.2);
        textColor = CupertinoColors.systemGreen;
        break;
      case 'cancelled':
        backgroundColor = CupertinoColors.systemRed.withOpacity(0.2);
        textColor = CupertinoColors.systemRed;
        break;
      default:
        backgroundColor = CupertinoColors.systemGrey.withOpacity(0.2);
        textColor = CupertinoColors.systemGrey;
    }

    String displayText;
    switch (status) {
      case 'pending':
        displayText = 'Pending';
        break;
      case 'confirmed':
        displayText = 'Confirmed';
        break;
      case 'in_progress':
        displayText = 'In Progress';
        break;
      case 'completed':
        displayText = 'Completed';
        break;
      case 'cancelled':
        displayText = 'Cancelled';
        break;
      default:
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

/// More options tab.
class _MoreTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.tabMore),
      ),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          children: [
            // Dispatcher link for admin/manager users
            if (user != null && user.canAccessDispatcher)
              CupertinoListTile.notched(
                leading: const Icon(
                  Icons.people_alt,
                  color: CupertinoColors.systemIndigo,
                ),
                title: const Text('Диспетчерская'),
                subtitle: const Text('Управление заказами'),
                trailing: const CupertinoListTileChevron(),
                onTap: () => context.push('/dispatcher'),
              ),
            CupertinoListTile.notched(
              leading: const Icon(Icons.person_outline),
              title: Text(l10n.profile),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.push('/profile'),
            ),
            CupertinoListTile.notched(
              leading: const Icon(Icons.help_outline),
              title: Text(l10n.helpAndSupport),
              trailing: const CupertinoListTileChevron(),
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (ctx) => CupertinoAlertDialog(
                    title: Text(l10n.comingSoon),
                    content: Text(l10n.helpComingSoon),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(l10n.ok),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                );
              },
            ),
            CupertinoListTile.notched(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.about),
              trailing: const CupertinoListTileChevron(),
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (ctx) => CupertinoAlertDialog(
                    title: Text(l10n.appTitle),
                    content: Text('${l10n.version('1.0.0')}\n${l10n.copyright('2026')}'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(l10n.ok),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Popular route card with Cupertino style.
class _CupertinoPopularRouteCard extends StatelessWidget {
  final String from;
  final String to;
  final String price;
  final String priceFromLabel;
  final VoidCallback onTap;

  const _CupertinoPopularRouteCard({
    required this.from,
    required this.to,
    required this.price,
    required this.priceFromLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: CupertinoColors.separator.resolveFrom(context),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: CupertinoColors.systemBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      from,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: CupertinoColors.label,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 12,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            to,
                            style: TextStyle(
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.systemBlue,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    priceFromLabel,
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

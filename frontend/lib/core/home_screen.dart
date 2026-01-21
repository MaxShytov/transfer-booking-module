import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../data/models/booking.dart';
import '../data/repositories/booking_repository.dart';
import '../l10n/generated/app_localizations.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/booking_flow_provider.dart';
import '../presentation/widgets/atoms/gradient_button.dart';
import 'theme/app_dimensions.dart';

/// Popular route data for quick booking.
class PopularRoute {
  final String fromName;
  final String toName;
  final String price;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;

  const PopularRoute({
    required this.fromName,
    required this.toName,
    required this.price,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
  });
}

/// Predefined popular routes with coordinates.
const _popularRoutes = [
  PopularRoute(
    fromName: 'Cagliari Airport',
    toName: 'City Center',
    price: '€35',
    pickupLat: 39.2514,
    pickupLng: 9.0543,
    dropoffLat: 39.2238,
    dropoffLng: 9.1217,
  ),
  PopularRoute(
    fromName: 'Cagliari Airport',
    toName: 'Villasimius',
    price: '€80',
    pickupLat: 39.2514,
    pickupLng: 9.0543,
    dropoffLat: 39.1452,
    dropoffLng: 9.5178,
  ),
  PopularRoute(
    fromName: 'Olbia Airport',
    toName: 'Porto Cervo',
    price: '€65',
    pickupLat: 40.8987,
    pickupLng: 9.5176,
    dropoffLat: 41.1318,
    dropoffLng: 9.5322,
  ),
];

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
            icon: const Icon(CupertinoIcons.add_circled),
            activeIcon: const Icon(CupertinoIcons.add_circled_solid),
            label: l10n.tabBook,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.list_bullet),
            activeIcon: const Icon(CupertinoIcons.list_bullet),
            label: l10n.tabMyBookings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.ellipsis),
            activeIcon: const Icon(CupertinoIcons.ellipsis),
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
          child: const Icon(CupertinoIcons.person_circle),
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
              ..._popularRoutes.map((route) => _CupertinoPopularRouteCard(
                from: route.fromName,
                to: route.toName,
                price: route.price,
                priceFromLabel: l10n.priceFrom,
                onTap: () => _startBookingWithRoute(context, ref, route),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _startBookingWithRoute(BuildContext context, WidgetRef ref, PopularRoute route) {
    final notifier = ref.read(bookingFlowProvider.notifier);

    // Reset booking state and set locations
    notifier.reset();
    notifier.setPickupLocation(SelectedLocation(
      address: route.fromName,
      lat: route.pickupLat,
      lng: route.pickupLng,
      isPredefined: true,
    ));
    notifier.setDropoffLocation(SelectedLocation(
      address: route.toName,
      lat: route.dropoffLat,
      lng: route.dropoffLng,
      isPredefined: true,
    ));

    // Navigate to booking
    context.push('/booking');
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
            CupertinoIcons.person_circle,
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
            CupertinoIcons.clock,
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
            CupertinoIcons.exclamationmark_circle,
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
              // Header row: reference + status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.bookingReference,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: CupertinoColors.label,
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
                    CupertinoIcons.location,
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
                    CupertinoIcons.location_solid,
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
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 14,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${booking.serviceDate} ${booking.pickupTime.substring(0, 5)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    ],
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
class _MoreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.tabMore),
      ),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          children: [
            CupertinoListTile.notched(
              leading: const Icon(CupertinoIcons.person),
              title: Text(l10n.profile),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.push('/profile'),
            ),
            CupertinoListTile.notched(
              leading: const Icon(CupertinoIcons.question_circle),
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
              leading: const Icon(CupertinoIcons.info),
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
                  CupertinoIcons.car_detailed,
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
                          CupertinoIcons.arrow_right,
                          size: 12,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          to,
                          style: TextStyle(
                            color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            fontSize: 13,
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
                CupertinoIcons.chevron_right,
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

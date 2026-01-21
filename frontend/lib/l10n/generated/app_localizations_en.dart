// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '8Move Transfer';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get done => 'Done';

  @override
  String get retry => 'Retry';

  @override
  String get skip => 'Skip';

  @override
  String get continueButton => 'Continue';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get expand => 'Expand';

  @override
  String get selected => 'Selected';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordMinChars => 'At least 8 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Repeat your password';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'Enter your first name';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'Enter your last name';

  @override
  String get phone => 'Phone';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get phoneHint => '+39 123 456 7890';

  @override
  String get loginError => 'Login Error';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get profile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get notSet => 'Not set';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleDriver => 'Driver';

  @override
  String get roleCustomer => 'Customer';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langFrench => 'Français';

  @override
  String get langArabic => 'العربية';

  @override
  String get bookTransfer => 'Book a Transfer';

  @override
  String get route => 'Route';

  @override
  String get pickupLocation => 'Pickup Location';

  @override
  String get dropoffLocation => 'Dropoff Location';

  @override
  String get dateTime => 'Date & Time';

  @override
  String get pickupDate => 'Pickup Date';

  @override
  String get returnDate => 'Return Date';

  @override
  String get time => 'Time';

  @override
  String get date => 'Date';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectTime => 'Select time';

  @override
  String get passengersAndLuggage => 'Passengers & Luggage';

  @override
  String get adults => 'Adults';

  @override
  String get children => 'Children';

  @override
  String get childrenSubtitle => 'Under 12 years';

  @override
  String get childSeats => 'Toddlers up to 4 years';

  @override
  String get childSeatsSubtitle => 'Child seat required';

  @override
  String get boosterSeats => 'Children 4-12 years';

  @override
  String get boosterSeatsSubtitle => 'Booster seat required';

  @override
  String get largeLuggage => 'Large Luggage';

  @override
  String get largeLuggageSubtitle => 'Suitcases, large bags';

  @override
  String get smallLuggage => 'Small Luggage';

  @override
  String get smallLuggageSubtitle => 'Backpacks, carry-on bags';

  @override
  String get oneWay => 'One Way';

  @override
  String get roundTrip => 'Round Trip';

  @override
  String get discountBadge => '-10%';

  @override
  String get continueToVehicle => 'Continue to Vehicle Selection';

  @override
  String get cancelBookingTitle => 'Cancel Booking?';

  @override
  String get cancelBookingMessage =>
      'Are you sure you want to cancel? Your progress will be lost.';

  @override
  String get continueBooking => 'Continue Booking';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get gpsComingSoon => 'GPS location will be available soon.';

  @override
  String get selectVehicle => 'Select Vehicle';

  @override
  String passengersAndBagsInfo(int passengers, int bags) {
    return '$passengers passengers, $bags large bags';
  }

  @override
  String passengersDetailedInfo(
    int total,
    int toddlers,
    int children,
    int bags,
  ) {
    return '$total passengers (incl. $toddlers toddlers, $children children), $bags large bags';
  }

  @override
  String inclToddlers(int count) {
    return 'incl. $count toddlers';
  }

  @override
  String inclChildren(int count) {
    return 'incl. $count children';
  }

  @override
  String minChildSeatsRequired(int count) {
    return 'Minimum $count required for toddlers';
  }

  @override
  String minBoosterSeatsRequired(int count) {
    return 'Minimum $count required for children';
  }

  @override
  String notSuitableForPassengersAndBags(int passengers, int bags) {
    return 'Not suitable for $passengers passengers and $bags bags';
  }

  @override
  String maxPassengers(int count) {
    return 'Max $count passengers';
  }

  @override
  String maxLargeBags(int count) {
    return 'Max $count large bags';
  }

  @override
  String selectedVehicle(String vehicle) {
    return 'Selected: $vehicle';
  }

  @override
  String get continueToExtras => 'Continue to Extras';

  @override
  String get failedToLoadVehicles => 'Failed to load vehicles';

  @override
  String get passengers => 'passengers';

  @override
  String get largeBags => 'large bags';

  @override
  String get smallBags => 'small bags';

  @override
  String get pax => 'pax';

  @override
  String get extraServices => 'Extra Services';

  @override
  String get optionalServices => 'Optional Services';

  @override
  String get optionalServicesSubtitle =>
      'Enhance your journey with these extras';

  @override
  String get includedServices => 'Included Services';

  @override
  String get includedServicesSubtitle =>
      'These fees may apply based on your trip';

  @override
  String get selectedExtras => 'Selected extras:';

  @override
  String get failedToLoadExtras => 'Failed to load extras';

  @override
  String get noExtrasAvailable => 'No extras available';

  @override
  String get continueToNextStep => 'Continue to the next step';

  @override
  String get each => 'each';

  @override
  String get passengerDetails => 'Passenger Details';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => '+39 xxx xxx xxxx';

  @override
  String get tripDetailsOptional => 'Trip Details (Optional)';

  @override
  String get flightNumber => 'Flight Number';

  @override
  String get outboundFlightNumber => 'Outbound Flight Number';

  @override
  String get returnFlightNumber => 'Return Flight Number';

  @override
  String get flightNumberHint => 'e.g. FR1234';

  @override
  String get flightMonitoringInfo => 'We will monitor your flight for delays';

  @override
  String get specialRequests => 'Special Requests';

  @override
  String get specialRequestsHint => 'Any special requirements?';

  @override
  String get continueToReview => 'Continue to Review';

  @override
  String get reviewBooking => 'Review Booking';

  @override
  String get calculatingPrice => 'Calculating final price...';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get discountOff => '10% OFF';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get bookingConfirmed => 'Booking Confirmed!';

  @override
  String get bookingConfirmedMessage =>
      'Your transfer has been booked successfully. You will receive a confirmation email shortly.';

  @override
  String get bookingFailed => 'Booking Failed';

  @override
  String get failedToCalculatePrice => 'Failed to calculate price';

  @override
  String get agreeToTermsPart1 => 'I agree to the ';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get andConnector => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get priceBreakdown => 'Price Breakdown';

  @override
  String get price => 'Price';

  @override
  String get pricingType => 'Pricing Type';

  @override
  String get fixedRoute => 'Fixed Route';

  @override
  String get distanceBased => 'Distance Based';

  @override
  String get distance => 'Distance';

  @override
  String get basePrice => 'Base Price';

  @override
  String get multipliersApplied => 'Multipliers Applied';

  @override
  String vehicleMultiplier(String name) {
    return 'Vehicle ($name)';
  }

  @override
  String passengersMultiplier(int count) {
    return 'Passengers ($count)';
  }

  @override
  String get seasonMultiplier => 'Season';

  @override
  String seasonMultiplierNamed(String name) {
    return 'Season ($name)';
  }

  @override
  String get timeMultiplier => 'Time';

  @override
  String timeMultiplierNamed(String name) {
    return 'Time ($name)';
  }

  @override
  String get subtotal => 'Subtotal';

  @override
  String get extrasTotal => 'Extras Total';

  @override
  String get total => 'TOTAL';

  @override
  String get calculationFormula => 'Calculation Formula';

  @override
  String get formulaText =>
      '(Base × Vehicle × Passengers × Season × Time) + Extras';

  @override
  String includesExtras(int count) {
    return 'Includes $count extra service(s)';
  }

  @override
  String get stepRoute => 'Route';

  @override
  String get stepVehicle => 'Vehicle';

  @override
  String get stepExtras => 'Extras';

  @override
  String get stepDetails => 'Details';

  @override
  String get stepReview => 'Review';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get notSelected => 'Not selected';

  @override
  String get dateNotSelected => 'Date not selected';

  @override
  String get timeNotSelected => 'Time not selected';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get extras => 'Extras';

  @override
  String get passenger => 'Passenger';

  @override
  String flightInfo(String number) {
    return 'Flight: $number';
  }

  @override
  String get enterAddressOrSelect => 'Enter address or select from list';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get currentLocationSubtitle => 'Use GPS to detect your location';

  @override
  String get chooseOnMap => 'Choose on Map';

  @override
  String get chooseOnMapSubtitle => 'Select a custom location on the map';

  @override
  String get noMatchingLocations => 'No matching locations found';

  @override
  String get pickup => 'Pickup';

  @override
  String get dropoff => 'Dropoff';

  @override
  String get loadingRoute => 'Loading route...';

  @override
  String get selectLocationsToSeeRoute => 'Select locations to see route';

  @override
  String get moveMapToSelectLocation => 'Move the map to select location';

  @override
  String get selectPickupLocation => 'Select Pickup Location';

  @override
  String get selectDropoffLocation => 'Select Dropoff Location';

  @override
  String get confirmPickup => 'Confirm Pickup';

  @override
  String get confirmDropoff => 'Confirm Dropoff';

  @override
  String get routePreview => 'Route Preview';

  @override
  String get locationSelected => 'Location selected';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Please enter a valid email';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String get validationPasswordMinLength =>
      'Password must be at least 8 characters';

  @override
  String get validationConfirmPasswordRequired =>
      'Please confirm your password';

  @override
  String get validationPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName is required';
  }

  @override
  String get validationPhoneInvalid => 'Please enter a valid phone number';

  @override
  String get validationFirstNameRequired => 'Please enter your first name';

  @override
  String get validationLastNameRequired => 'Please enter your last name';

  @override
  String get validationPhoneRequired => 'Please enter your phone number';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get bookTransferSubtitle => 'Book your airport transfer easily';

  @override
  String get readyToTravel => 'Ready to Travel?';

  @override
  String get bookingDescription =>
      'Book your airport transfer in just a few steps.\nChoose your route, vehicle, and extras.';

  @override
  String get popularRoutes => 'Popular Routes';

  @override
  String get tabBook => 'Book';

  @override
  String get tabMyBookings => 'My Bookings';

  @override
  String get tabMore => 'More';

  @override
  String get noBookingsYet => 'No Bookings Yet';

  @override
  String get bookingHistoryWillAppear =>
      'Your booking history will appear here';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get helpComingSoon => 'Help & Support will be available soon.';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String copyright(String year) {
    return '© $year 8Move Transfer';
  }

  @override
  String get priceFrom => 'from';

  @override
  String get yourRoute => 'Your route';

  @override
  String get swapLocations => 'Swap locations';

  @override
  String get travelDate => 'Travel date';

  @override
  String get travelDates => 'Travel dates';

  @override
  String get outbound => 'OUTBOUND';

  @override
  String get returnTrip => 'RETURN';

  @override
  String get departure => 'Departure';

  @override
  String get arrival => 'Arrival';

  @override
  String get departureAbbrev => 'Dep';

  @override
  String get arrivalAbbrev => 'Arr';

  @override
  String get now => 'now';

  @override
  String get applyButton => 'Apply';

  @override
  String get outboundDate => 'Outbound date';

  @override
  String get returnDateModal => 'Return date';

  @override
  String get today => 'Today';

  @override
  String get tripInfo => 'Trip info';

  @override
  String get distanceLabel => 'DISTANCE';

  @override
  String get durationLabel => 'DURATION';

  @override
  String get passengersCard => 'Passengers';

  @override
  String get luggageCard => 'Luggage';

  @override
  String get large => 'Large';

  @override
  String get small => 'Small';

  @override
  String get surfboardBikeGolf => 'Surfboard/Bike/Golf';

  @override
  String get skiSnowboard => 'Ski/Snowboard';

  @override
  String get otherSportsEquipment => 'Other sports';

  @override
  String get otherSportsPlaceholder => 'Please specify equipment...';

  @override
  String get hour => 'Hour';

  @override
  String get minute => 'Minute';
}

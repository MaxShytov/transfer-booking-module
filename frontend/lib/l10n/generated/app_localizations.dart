import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('it'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'8Move Transfer'**
  String get appTitle;

  /// Login button and title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button and link
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Expand button
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// Selected indicator
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// Password hint for minimum characters
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordMinChars;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Confirm password placeholder
  ///
  /// In en, this message translates to:
  /// **'Repeat your password'**
  String get confirmPasswordHint;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// First name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get firstNameHint;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Last name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get lastNameHint;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Optional phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// Phone placeholder
  ///
  /// In en, this message translates to:
  /// **'+39 123 456 7890'**
  String get phoneHint;

  /// Login error dialog title
  ///
  /// In en, this message translates to:
  /// **'Login Error'**
  String get loginError;

  /// Registration prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Create account title and button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Login prompt
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Fallback for empty values
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// Admin role label
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get roleAdmin;

  /// Manager role label
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get roleManager;

  /// Driver role label
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get roleDriver;

  /// Customer role label
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleCustomer;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// Italian language name
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get langItalian;

  /// German language name
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get langGerman;

  /// French language name
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// Book transfer screen title
  ///
  /// In en, this message translates to:
  /// **'Book a Transfer'**
  String get bookTransfer;

  /// Route section header
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// Pickup location label
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// Dropoff location label
  ///
  /// In en, this message translates to:
  /// **'Dropoff Location'**
  String get dropoffLocation;

  /// Date and time section header
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// Pickup date label
  ///
  /// In en, this message translates to:
  /// **'Pickup Date'**
  String get pickupDate;

  /// Return date label
  ///
  /// In en, this message translates to:
  /// **'Return Date'**
  String get returnDate;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Date picker placeholder
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Time picker placeholder
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// Passengers and luggage section header
  ///
  /// In en, this message translates to:
  /// **'Passengers & Luggage'**
  String get passengersAndLuggage;

  /// Adults stepper label
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get adults;

  /// Children stepper label
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// Children age description
  ///
  /// In en, this message translates to:
  /// **'Under 12 years'**
  String get childrenSubtitle;

  /// Large luggage stepper label
  ///
  /// In en, this message translates to:
  /// **'Large Luggage'**
  String get largeLuggage;

  /// Large luggage description
  ///
  /// In en, this message translates to:
  /// **'Suitcases, large bags'**
  String get largeLuggageSubtitle;

  /// Small luggage stepper label
  ///
  /// In en, this message translates to:
  /// **'Small Luggage'**
  String get smallLuggage;

  /// Small luggage description
  ///
  /// In en, this message translates to:
  /// **'Backpacks, carry-on bags'**
  String get smallLuggageSubtitle;

  /// One way trip type
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get oneWay;

  /// Round trip type
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get roundTrip;

  /// Round trip discount badge
  ///
  /// In en, this message translates to:
  /// **'-10%'**
  String get discountBadge;

  /// Continue to vehicle selection button
  ///
  /// In en, this message translates to:
  /// **'Continue to Vehicle Selection'**
  String get continueToVehicle;

  /// Cancel booking dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking?'**
  String get cancelBookingTitle;

  /// Cancel booking confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel? Your progress will be lost.'**
  String get cancelBookingMessage;

  /// Continue booking button in dialog
  ///
  /// In en, this message translates to:
  /// **'Continue Booking'**
  String get continueBooking;

  /// Coming soon dialog title
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// GPS feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'GPS location will be available soon.'**
  String get gpsComingSoon;

  /// Vehicle selection screen title
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicle;

  /// Passenger and bags info banner
  ///
  /// In en, this message translates to:
  /// **'{passengers} passengers, {bags} large bags'**
  String passengersAndBagsInfo(int passengers, int bags);

  /// Vehicle not suitable message
  ///
  /// In en, this message translates to:
  /// **'Not suitable for {passengers} passengers and {bags} bags'**
  String notSuitableForPassengersAndBags(int passengers, int bags);

  /// Maximum passengers limit
  ///
  /// In en, this message translates to:
  /// **'Max {count} passengers'**
  String maxPassengers(int count);

  /// Maximum large bags limit
  ///
  /// In en, this message translates to:
  /// **'Max {count} large bags'**
  String maxLargeBags(int count);

  /// Selected vehicle confirmation
  ///
  /// In en, this message translates to:
  /// **'Selected: {vehicle}'**
  String selectedVehicle(String vehicle);

  /// Continue to extras button
  ///
  /// In en, this message translates to:
  /// **'Continue to Extras'**
  String get continueToExtras;

  /// Vehicle loading error
  ///
  /// In en, this message translates to:
  /// **'Failed to load vehicles'**
  String get failedToLoadVehicles;

  /// Passengers label (plural)
  ///
  /// In en, this message translates to:
  /// **'passengers'**
  String get passengers;

  /// Large bags label
  ///
  /// In en, this message translates to:
  /// **'large bags'**
  String get largeBags;

  /// Small bags label
  ///
  /// In en, this message translates to:
  /// **'small bags'**
  String get smallBags;

  /// Abbreviated passengers
  ///
  /// In en, this message translates to:
  /// **'pax'**
  String get pax;

  /// Extra services screen title
  ///
  /// In en, this message translates to:
  /// **'Extra Services'**
  String get extraServices;

  /// Optional services section header
  ///
  /// In en, this message translates to:
  /// **'Optional Services'**
  String get optionalServices;

  /// Optional services description
  ///
  /// In en, this message translates to:
  /// **'Enhance your journey with these extras'**
  String get optionalServicesSubtitle;

  /// Included services section header
  ///
  /// In en, this message translates to:
  /// **'Included Services'**
  String get includedServices;

  /// Included services description
  ///
  /// In en, this message translates to:
  /// **'These fees may apply based on your trip'**
  String get includedServicesSubtitle;

  /// Selected extras count label
  ///
  /// In en, this message translates to:
  /// **'Selected extras:'**
  String get selectedExtras;

  /// Extras loading error
  ///
  /// In en, this message translates to:
  /// **'Failed to load extras'**
  String get failedToLoadExtras;

  /// No extras empty state title
  ///
  /// In en, this message translates to:
  /// **'No extras available'**
  String get noExtrasAvailable;

  /// No extras empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Continue to the next step'**
  String get continueToNextStep;

  /// Price per item qualifier
  ///
  /// In en, this message translates to:
  /// **'each'**
  String get each;

  /// Passenger details screen title
  ///
  /// In en, this message translates to:
  /// **'Passenger Details'**
  String get passengerDetails;

  /// Contact info section header
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Phone number placeholder
  ///
  /// In en, this message translates to:
  /// **'+39 xxx xxx xxxx'**
  String get phoneNumberHint;

  /// Optional trip details section header
  ///
  /// In en, this message translates to:
  /// **'Trip Details (Optional)'**
  String get tripDetailsOptional;

  /// Flight number field label
  ///
  /// In en, this message translates to:
  /// **'Flight Number'**
  String get flightNumber;

  /// Flight number placeholder
  ///
  /// In en, this message translates to:
  /// **'e.g. FR1234'**
  String get flightNumberHint;

  /// Flight monitoring helper text
  ///
  /// In en, this message translates to:
  /// **'We will monitor your flight for delays'**
  String get flightMonitoringInfo;

  /// Special requests field label
  ///
  /// In en, this message translates to:
  /// **'Special Requests'**
  String get specialRequests;

  /// Special requests placeholder
  ///
  /// In en, this message translates to:
  /// **'Any special requirements?'**
  String get specialRequestsHint;

  /// Continue to review button
  ///
  /// In en, this message translates to:
  /// **'Continue to Review'**
  String get continueToReview;

  /// Review booking screen title
  ///
  /// In en, this message translates to:
  /// **'Review Booking'**
  String get reviewBooking;

  /// Price calculation loading text
  ///
  /// In en, this message translates to:
  /// **'Calculating final price...'**
  String get calculatingPrice;

  /// Total price label
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// Discount badge text
  ///
  /// In en, this message translates to:
  /// **'10% OFF'**
  String get discountOff;

  /// Confirm booking button
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// Booking success dialog title
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmed;

  /// Booking success message
  ///
  /// In en, this message translates to:
  /// **'Your transfer has been booked successfully. You will receive a confirmation email shortly.'**
  String get bookingConfirmedMessage;

  /// Booking error dialog title
  ///
  /// In en, this message translates to:
  /// **'Booking Failed'**
  String get bookingFailed;

  /// Price calculation error
  ///
  /// In en, this message translates to:
  /// **'Failed to calculate price'**
  String get failedToCalculatePrice;

  /// Terms agreement text part 1
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToTermsPart1;

  /// Terms and conditions link
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// And connector between terms and privacy
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andConnector;

  /// Privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Price breakdown title (detailed)
  ///
  /// In en, this message translates to:
  /// **'Price Breakdown'**
  String get priceBreakdown;

  /// Price title (simple)
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Pricing type label
  ///
  /// In en, this message translates to:
  /// **'Pricing Type'**
  String get pricingType;

  /// Fixed route pricing type
  ///
  /// In en, this message translates to:
  /// **'Fixed Route'**
  String get fixedRoute;

  /// Distance based pricing type
  ///
  /// In en, this message translates to:
  /// **'Distance Based'**
  String get distanceBased;

  /// Distance label
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// Base price label
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get basePrice;

  /// Multipliers section header
  ///
  /// In en, this message translates to:
  /// **'Multipliers Applied'**
  String get multipliersApplied;

  /// Vehicle multiplier label
  ///
  /// In en, this message translates to:
  /// **'Vehicle ({name})'**
  String vehicleMultiplier(String name);

  /// Passengers multiplier label
  ///
  /// In en, this message translates to:
  /// **'Passengers ({count})'**
  String passengersMultiplier(int count);

  /// Season multiplier label
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get seasonMultiplier;

  /// Season multiplier with name
  ///
  /// In en, this message translates to:
  /// **'Season ({name})'**
  String seasonMultiplierNamed(String name);

  /// Time multiplier label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeMultiplier;

  /// Time multiplier with name
  ///
  /// In en, this message translates to:
  /// **'Time ({name})'**
  String timeMultiplierNamed(String name);

  /// Subtotal label
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Extras total label
  ///
  /// In en, this message translates to:
  /// **'Extras Total'**
  String get extrasTotal;

  /// Total price label
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get total;

  /// Formula section header
  ///
  /// In en, this message translates to:
  /// **'Calculation Formula'**
  String get calculationFormula;

  /// Price calculation formula
  ///
  /// In en, this message translates to:
  /// **'(Base × Vehicle × Passengers × Season × Time) + Extras'**
  String get formulaText;

  /// Extras count summary
  ///
  /// In en, this message translates to:
  /// **'Includes {count} extra service(s)'**
  String includesExtras(int count);

  /// Booking step 1 label
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get stepRoute;

  /// Booking step 2 label
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get stepVehicle;

  /// Booking step 3 label
  ///
  /// In en, this message translates to:
  /// **'Extras'**
  String get stepExtras;

  /// Booking step 4 label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get stepDetails;

  /// Booking step 5 label
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get stepReview;

  /// From location label
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// To location label
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Location not selected fallback
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// Date not selected fallback
  ///
  /// In en, this message translates to:
  /// **'Date not selected'**
  String get dateNotSelected;

  /// Time not selected fallback
  ///
  /// In en, this message translates to:
  /// **'Time not selected'**
  String get timeNotSelected;

  /// Vehicle section title
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// Extras section title
  ///
  /// In en, this message translates to:
  /// **'Extras'**
  String get extras;

  /// Passenger section title
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get passenger;

  /// Flight number display
  ///
  /// In en, this message translates to:
  /// **'Flight: {number}'**
  String flightInfo(String number);

  /// Location input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter address or select from list'**
  String get enterAddressOrSelect;

  /// GPS location option
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// GPS option description
  ///
  /// In en, this message translates to:
  /// **'Use GPS to detect your location'**
  String get currentLocationSubtitle;

  /// Map selection option
  ///
  /// In en, this message translates to:
  /// **'Choose on Map'**
  String get chooseOnMap;

  /// Map option description
  ///
  /// In en, this message translates to:
  /// **'Select a custom location on the map'**
  String get chooseOnMapSubtitle;

  /// Empty location search state
  ///
  /// In en, this message translates to:
  /// **'No matching locations found'**
  String get noMatchingLocations;

  /// Pickup marker/label
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// Dropoff marker/label
  ///
  /// In en, this message translates to:
  /// **'Dropoff'**
  String get dropoff;

  /// Route loading indicator
  ///
  /// In en, this message translates to:
  /// **'Loading route...'**
  String get loadingRoute;

  /// Empty map state
  ///
  /// In en, this message translates to:
  /// **'Select locations to see route'**
  String get selectLocationsToSeeRoute;

  /// Map selection instruction
  ///
  /// In en, this message translates to:
  /// **'Move the map to select location'**
  String get moveMapToSelectLocation;

  /// Pickup selection title
  ///
  /// In en, this message translates to:
  /// **'Select Pickup Location'**
  String get selectPickupLocation;

  /// Dropoff selection title
  ///
  /// In en, this message translates to:
  /// **'Select Dropoff Location'**
  String get selectDropoffLocation;

  /// Confirm pickup button
  ///
  /// In en, this message translates to:
  /// **'Confirm Pickup'**
  String get confirmPickup;

  /// Confirm dropoff button
  ///
  /// In en, this message translates to:
  /// **'Confirm Dropoff'**
  String get confirmDropoff;

  /// Route preview screen title
  ///
  /// In en, this message translates to:
  /// **'Route Preview'**
  String get routePreview;

  /// Location selected fallback
  ///
  /// In en, this message translates to:
  /// **'Location selected'**
  String get locationSelected;

  /// Email required error
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// Invalid email error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validationEmailInvalid;

  /// Password required error
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// Password too short error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordMinLength;

  /// Confirm password required error
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get validationConfirmPasswordRequired;

  /// Passwords mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsDoNotMatch;

  /// Generic field required error
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String validationFieldRequired(String fieldName);

  /// Invalid phone error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get validationPhoneInvalid;

  /// First name required error
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get validationFirstNameRequired;

  /// Last name required error
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get validationLastNameRequired;

  /// Phone required error
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get validationPhoneRequired;

  /// Language picker title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Use device language option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Subtitle on home screen
  ///
  /// In en, this message translates to:
  /// **'Book your airport transfer easily'**
  String get bookTransferSubtitle;

  /// Card title on home screen
  ///
  /// In en, this message translates to:
  /// **'Ready to Travel?'**
  String get readyToTravel;

  /// Booking card description
  ///
  /// In en, this message translates to:
  /// **'Book your airport transfer in just a few steps.\nChoose your route, vehicle, and extras.'**
  String get bookingDescription;

  /// Popular routes section title
  ///
  /// In en, this message translates to:
  /// **'Popular Routes'**
  String get popularRoutes;

  /// Book tab label
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get tabBook;

  /// My Bookings tab label
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get tabMyBookings;

  /// More tab label
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get tabMore;

  /// Empty bookings message
  ///
  /// In en, this message translates to:
  /// **'No Bookings Yet'**
  String get noBookingsYet;

  /// Empty bookings subtitle
  ///
  /// In en, this message translates to:
  /// **'Your booking history will appear here'**
  String get bookingHistoryWillAppear;

  /// Help menu item
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// Help coming soon message
  ///
  /// In en, this message translates to:
  /// **'Help & Support will be available soon.'**
  String get helpComingSoon;

  /// About menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version string
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// Copyright notice
  ///
  /// In en, this message translates to:
  /// **'© {year} 8Move Transfer'**
  String copyright(String year);

  /// Price from label
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get priceFrom;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => '8Move Transfer';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get logout => 'Abmelden';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get done => 'Fertig';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get skip => 'Überspringen';

  @override
  String get continueButton => 'Weiter';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get close => 'Schließen';

  @override
  String get expand => 'Erweitern';

  @override
  String get selected => 'Ausgewählt';

  @override
  String get email => 'E-Mail';

  @override
  String get emailHint => 'Geben Sie Ihre E-Mail ein';

  @override
  String get password => 'Passwort';

  @override
  String get passwordHint => 'Geben Sie Ihr Passwort ein';

  @override
  String get passwordMinChars => 'Mindestens 8 Zeichen';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get confirmPasswordHint => 'Passwort wiederholen';

  @override
  String get firstName => 'Vorname';

  @override
  String get firstNameHint => 'Geben Sie Ihren Vornamen ein';

  @override
  String get lastName => 'Nachname';

  @override
  String get lastNameHint => 'Geben Sie Ihren Nachnamen ein';

  @override
  String get phone => 'Telefon';

  @override
  String get phoneOptional => 'Telefon (optional)';

  @override
  String get phoneHint => '+49 123 456 7890';

  @override
  String get loginError => 'Anmeldefehler';

  @override
  String get noAccount => 'Noch kein Konto?';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto?';

  @override
  String get logoutConfirmTitle => 'Abmelden';

  @override
  String get logoutConfirmMessage =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get profile => 'Profil';

  @override
  String get language => 'Sprache';

  @override
  String get notSet => 'Nicht festgelegt';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleDriver => 'Fahrer';

  @override
  String get roleCustomer => 'Kunde';

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
  String get bookTransfer => 'Transfer buchen';

  @override
  String get route => 'Route';

  @override
  String get pickupLocation => 'Abholort';

  @override
  String get dropoffLocation => 'Zielort';

  @override
  String get dateTime => 'Datum & Uhrzeit';

  @override
  String get pickupDate => 'Abholdatum';

  @override
  String get returnDate => 'Rückfahrtdatum';

  @override
  String get time => 'Uhrzeit';

  @override
  String get date => 'Datum';

  @override
  String get selectDate => 'Datum wählen';

  @override
  String get selectTime => 'Uhrzeit wählen';

  @override
  String get passengersAndLuggage => 'Passagiere & Gepäck';

  @override
  String get adults => 'Erwachsene';

  @override
  String get children => 'Kinder';

  @override
  String get childrenSubtitle => 'Unter 12 Jahren';

  @override
  String get childSeats => 'Kleinkinder bis 4 Jahre';

  @override
  String get childSeatsSubtitle => 'Kindersitz erforderlich';

  @override
  String get boosterSeats => 'Kinder 4-12 Jahre';

  @override
  String get boosterSeatsSubtitle => 'Sitzerhöhung erforderlich';

  @override
  String get largeLuggage => 'Großes Gepäck';

  @override
  String get largeLuggageSubtitle => 'Koffer, große Taschen';

  @override
  String get smallLuggage => 'Kleines Gepäck';

  @override
  String get smallLuggageSubtitle => 'Rucksäcke, Handgepäck';

  @override
  String get oneWay => 'Einfache Fahrt';

  @override
  String get roundTrip => 'Hin- und Rückfahrt';

  @override
  String get discountBadge => '-10%';

  @override
  String get continueToVehicle => 'Weiter zur Fahrzeugauswahl';

  @override
  String get cancelBookingTitle => 'Buchung abbrechen?';

  @override
  String get cancelBookingMessage =>
      'Sind Sie sicher, dass Sie abbrechen möchten? Ihr Fortschritt geht verloren.';

  @override
  String get continueBooking => 'Buchung fortsetzen';

  @override
  String get comingSoon => 'Demnächst verfügbar';

  @override
  String get gpsComingSoon => 'GPS-Ortung wird bald verfügbar sein.';

  @override
  String get selectVehicle => 'Fahrzeug wählen';

  @override
  String passengersAndBagsInfo(int passengers, int bags) {
    return '$passengers Passagiere, $bags große Gepäckstücke';
  }

  @override
  String passengersDetailedInfo(
    int total,
    int toddlers,
    int children,
    int bags,
  ) {
    return '$total Passagiere (inkl. $toddlers Kleinkinder, $children Kinder), $bags große Gepäckstücke';
  }

  @override
  String inclToddlers(int count) {
    return 'inkl. $count Kleinkinder';
  }

  @override
  String inclChildren(int count) {
    return 'inkl. $count Kinder';
  }

  @override
  String minChildSeatsRequired(int count) {
    return 'Mindestens $count für Kleinkinder erforderlich';
  }

  @override
  String minBoosterSeatsRequired(int count) {
    return 'Mindestens $count für Kinder erforderlich';
  }

  @override
  String notSuitableForPassengersAndBags(int passengers, int bags) {
    return 'Nicht geeignet für $passengers Passagiere und $bags Gepäckstücke';
  }

  @override
  String maxPassengers(int count) {
    return 'Max. $count Passagiere';
  }

  @override
  String maxLargeBags(int count) {
    return 'Max. $count große Gepäckstücke';
  }

  @override
  String selectedVehicle(String vehicle) {
    return 'Ausgewählt: $vehicle';
  }

  @override
  String get continueToExtras => 'Weiter zu Extras';

  @override
  String get failedToLoadVehicles => 'Fahrzeuge konnten nicht geladen werden';

  @override
  String get passengers => 'Passagiere';

  @override
  String get largeBags => 'große Gepäckstücke';

  @override
  String get smallBags => 'kleine Gepäckstücke';

  @override
  String get pax => 'Pers.';

  @override
  String get extraServices => 'Zusatzleistungen';

  @override
  String get optionalServices => 'Optionale Leistungen';

  @override
  String get optionalServicesSubtitle =>
      'Verbessern Sie Ihre Reise mit diesen Extras';

  @override
  String get includedServices => 'Inkludierte Leistungen';

  @override
  String get includedServicesSubtitle =>
      'Diese Gebühren können je nach Ihrer Fahrt anfallen';

  @override
  String get selectedExtras => 'Ausgewählte Extras:';

  @override
  String get failedToLoadExtras => 'Extras konnten nicht geladen werden';

  @override
  String get noExtrasAvailable => 'Keine Extras verfügbar';

  @override
  String get continueToNextStep => 'Weiter zum nächsten Schritt';

  @override
  String get each => 'pro Stück';

  @override
  String get passengerDetails => 'Passagierdaten';

  @override
  String get contactInformation => 'Kontaktinformationen';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get phoneNumberHint => '+49 xxx xxx xxxx';

  @override
  String get tripDetailsOptional => 'Reisedetails (Optional)';

  @override
  String get flightNumber => 'Flugnummer';

  @override
  String get outboundFlightNumber => 'Hinflug-Flugnummer';

  @override
  String get returnFlightNumber => 'Rückflug-Flugnummer';

  @override
  String get flightNumberHint => 'z.B. FR1234';

  @override
  String get flightMonitoringInfo =>
      'Wir überwachen Ihren Flug auf Verspätungen';

  @override
  String get specialRequests => 'Besondere Wünsche';

  @override
  String get specialRequestsHint => 'Haben Sie besondere Anforderungen?';

  @override
  String get continueToReview => 'Weiter zur Übersicht';

  @override
  String get reviewBooking => 'Buchung überprüfen';

  @override
  String get calculatingPrice => 'Endpreis wird berechnet...';

  @override
  String get totalPrice => 'Gesamtpreis';

  @override
  String get discountOff => '10% RABATT';

  @override
  String get confirmBooking => 'Buchung bestätigen';

  @override
  String get bookingConfirmed => 'Buchung bestätigt!';

  @override
  String get bookingConfirmedMessage =>
      'Ihr Transfer wurde erfolgreich gebucht. Sie erhalten in Kürze eine Bestätigungs-E-Mail.';

  @override
  String get bookingFailed => 'Buchung fehlgeschlagen';

  @override
  String get failedToCalculatePrice => 'Preis konnte nicht berechnet werden';

  @override
  String get agreeToTermsPart1 => 'Ich akzeptiere die ';

  @override
  String get termsAndConditions => 'Allgemeinen Geschäftsbedingungen';

  @override
  String get andConnector => ' und die ';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get priceBreakdown => 'Preisaufschlüsselung';

  @override
  String get price => 'Preis';

  @override
  String get pricingType => 'Preistyp';

  @override
  String get fixedRoute => 'Festpreis-Route';

  @override
  String get distanceBased => 'Entfernungsbasiert';

  @override
  String get distance => 'Entfernung';

  @override
  String get basePrice => 'Grundpreis';

  @override
  String get multipliersApplied => 'Angewandte Faktoren';

  @override
  String vehicleMultiplier(String name) {
    return 'Fahrzeug ($name)';
  }

  @override
  String passengersMultiplier(int count) {
    return 'Passagiere ($count)';
  }

  @override
  String get seasonMultiplier => 'Saison';

  @override
  String seasonMultiplierNamed(String name) {
    return 'Saison ($name)';
  }

  @override
  String get timeMultiplier => 'Uhrzeit';

  @override
  String timeMultiplierNamed(String name) {
    return 'Uhrzeit ($name)';
  }

  @override
  String get subtotal => 'Zwischensumme';

  @override
  String get extrasTotal => 'Extras Gesamt';

  @override
  String get total => 'GESAMT';

  @override
  String get calculationFormula => 'Berechnungsformel';

  @override
  String get formulaText =>
      '(Basis × Fahrzeug × Passagiere × Saison × Uhrzeit) + Extras';

  @override
  String includesExtras(int count) {
    return 'Enthält $count Zusatzleistung(en)';
  }

  @override
  String get stepRoute => 'Route';

  @override
  String get stepVehicle => 'Fahrzeug';

  @override
  String get stepExtras => 'Extras';

  @override
  String get stepDetails => 'Daten';

  @override
  String get stepReview => 'Übersicht';

  @override
  String get from => 'Von';

  @override
  String get to => 'Nach';

  @override
  String get notSelected => 'Nicht ausgewählt';

  @override
  String get dateNotSelected => 'Datum nicht ausgewählt';

  @override
  String get timeNotSelected => 'Uhrzeit nicht ausgewählt';

  @override
  String get vehicle => 'Fahrzeug';

  @override
  String get extras => 'Extras';

  @override
  String get passenger => 'Passagier';

  @override
  String flightInfo(String number) {
    return 'Flug: $number';
  }

  @override
  String get enterAddressOrSelect => 'Adresse eingeben oder aus Liste wählen';

  @override
  String get currentLocation => 'Aktueller Standort';

  @override
  String get currentLocationSubtitle =>
      'GPS verwenden um Ihren Standort zu erkennen';

  @override
  String get chooseOnMap => 'Auf Karte wählen';

  @override
  String get chooseOnMapSubtitle =>
      'Wählen Sie einen benutzerdefinierten Standort auf der Karte';

  @override
  String get noMatchingLocations => 'Keine passenden Standorte gefunden';

  @override
  String get pickup => 'Abholung';

  @override
  String get dropoff => 'Ziel';

  @override
  String get loadingRoute => 'Route wird geladen...';

  @override
  String get selectLocationsToSeeRoute =>
      'Standorte auswählen um Route zu sehen';

  @override
  String get moveMapToSelectLocation =>
      'Karte verschieben um Standort zu wählen';

  @override
  String get selectPickupLocation => 'Abholort wählen';

  @override
  String get selectDropoffLocation => 'Zielort wählen';

  @override
  String get confirmPickup => 'Abholung bestätigen';

  @override
  String get confirmDropoff => 'Ziel bestätigen';

  @override
  String get routePreview => 'Routenvorschau';

  @override
  String get locationSelected => 'Standort ausgewählt';

  @override
  String get validationEmailRequired => 'E-Mail ist erforderlich';

  @override
  String get validationEmailInvalid =>
      'Bitte geben Sie eine gültige E-Mail ein';

  @override
  String get validationPasswordRequired => 'Passwort ist erforderlich';

  @override
  String get validationPasswordMinLength =>
      'Das Passwort muss mindestens 8 Zeichen haben';

  @override
  String get validationConfirmPasswordRequired =>
      'Bitte bestätigen Sie Ihr Passwort';

  @override
  String get validationPasswordsDoNotMatch =>
      'Passwörter stimmen nicht überein';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName ist erforderlich';
  }

  @override
  String get validationPhoneInvalid =>
      'Bitte geben Sie eine gültige Telefonnummer ein';

  @override
  String get validationFirstNameRequired =>
      'Bitte geben Sie Ihren Vornamen ein';

  @override
  String get validationLastNameRequired =>
      'Bitte geben Sie Ihren Nachnamen ein';

  @override
  String get validationPhoneRequired =>
      'Bitte geben Sie Ihre Telefonnummer ein';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get bookTransferSubtitle =>
      'Buchen Sie einfach Ihren Flughafentransfer';

  @override
  String get readyToTravel => 'Bereit zu Reisen?';

  @override
  String get bookingDescription =>
      'Buchen Sie Ihren Flughafentransfer in wenigen Schritten.\nWählen Sie Route, Fahrzeug und Extras.';

  @override
  String get popularRoutes => 'Beliebte Routen';

  @override
  String get tabBook => 'Buchen';

  @override
  String get tabMyBookings => 'Meine Buchungen';

  @override
  String get tabMore => 'Mehr';

  @override
  String get noBookingsYet => 'Noch keine Buchungen';

  @override
  String get bookingHistoryWillAppear =>
      'Ihre Buchungshistorie wird hier angezeigt';

  @override
  String get helpAndSupport => 'Hilfe & Support';

  @override
  String get helpComingSoon => 'Hilfe & Support wird bald verfügbar sein.';

  @override
  String get about => 'Über';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String copyright(String year) {
    return '© $year 8Move Transfer';
  }

  @override
  String get priceFrom => 'ab';

  @override
  String get yourRoute => 'Ihre Route';

  @override
  String get swapLocations => 'Orte tauschen';

  @override
  String get travelDate => 'Reisedatum';

  @override
  String get travelDates => 'Reisedaten';

  @override
  String get outbound => 'HINFAHRT';

  @override
  String get returnTrip => 'RÜCKFAHRT';

  @override
  String get departure => 'Abfahrt';

  @override
  String get arrival => 'Ankunft';

  @override
  String get departureAbbrev => 'Abf';

  @override
  String get arrivalAbbrev => 'Ank';

  @override
  String get now => 'jetzt';

  @override
  String get applyButton => 'Anwenden';

  @override
  String get outboundDate => 'Hinfahrtsdatum';

  @override
  String get returnDateModal => 'Rückfahrtsdatum';

  @override
  String get today => 'Heute';

  @override
  String get tripInfo => 'Fahrtinfo';

  @override
  String get distanceLabel => 'ENTFERNUNG';

  @override
  String get durationLabel => 'DAUER';

  @override
  String get passengersCard => 'Passagiere';

  @override
  String get luggageCard => 'Gepäck';

  @override
  String get large => 'Groß';

  @override
  String get small => 'Klein';

  @override
  String get surfboardBikeGolf => 'Surfbrett/Fahrrad/Golf';

  @override
  String get skiSnowboard => 'Ski/Snowboard';

  @override
  String get otherSportsEquipment => 'Andere Sportgeräte';

  @override
  String get otherSportsPlaceholder => 'Bitte Ausrüstung angeben...';

  @override
  String get hour => 'Stunde';

  @override
  String get minute => 'Minute';
}

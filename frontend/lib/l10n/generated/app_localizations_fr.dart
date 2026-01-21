// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => '8Move Transfer';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get logout => 'Déconnexion';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get done => 'Terminé';

  @override
  String get retry => 'Réessayer';

  @override
  String get skip => 'Passer';

  @override
  String get continueButton => 'Continuer';

  @override
  String get edit => 'Modifier';

  @override
  String get close => 'Fermer';

  @override
  String get expand => 'Agrandir';

  @override
  String get selected => 'Sélectionné';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'Entrez votre e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHint => 'Entrez votre mot de passe';

  @override
  String get passwordMinChars => 'Au moins 8 caractères';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get confirmPasswordHint => 'Répétez votre mot de passe';

  @override
  String get firstName => 'Prénom';

  @override
  String get firstNameHint => 'Entrez votre prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get lastNameHint => 'Entrez votre nom';

  @override
  String get phone => 'Téléphone';

  @override
  String get phoneOptional => 'Téléphone (optionnel)';

  @override
  String get phoneHint => '+33 1 23 45 67 89';

  @override
  String get loginError => 'Erreur de connexion';

  @override
  String get noAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get logoutConfirmTitle => 'Déconnexion';

  @override
  String get logoutConfirmMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get profile => 'Profil';

  @override
  String get language => 'Langue';

  @override
  String get notSet => 'Non défini';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleDriver => 'Chauffeur';

  @override
  String get roleCustomer => 'Client';

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
  String get bookTransfer => 'Réserver un transfert';

  @override
  String get route => 'Itinéraire';

  @override
  String get pickupLocation => 'Lieu de prise en charge';

  @override
  String get dropoffLocation => 'Lieu de dépose';

  @override
  String get dateTime => 'Date et heure';

  @override
  String get pickupDate => 'Date de prise en charge';

  @override
  String get returnDate => 'Date de retour';

  @override
  String get time => 'Heure';

  @override
  String get date => 'Date';

  @override
  String get selectDate => 'Sélectionner la date';

  @override
  String get selectTime => 'Sélectionner l\'heure';

  @override
  String get passengersAndLuggage => 'Passagers et bagages';

  @override
  String get adults => 'Adultes';

  @override
  String get children => 'Enfants';

  @override
  String get childrenSubtitle => 'Moins de 12 ans';

  @override
  String get childSeats => 'Tout-petits jusqu\'à 4 ans';

  @override
  String get childSeatsSubtitle => 'Siège enfant requis';

  @override
  String get boosterSeats => 'Enfants 4-12 ans';

  @override
  String get boosterSeatsSubtitle => 'Rehausseur requis';

  @override
  String get largeLuggage => 'Gros bagages';

  @override
  String get largeLuggageSubtitle => 'Valises, grands sacs';

  @override
  String get smallLuggage => 'Petits bagages';

  @override
  String get smallLuggageSubtitle => 'Sacs à dos, bagages à main';

  @override
  String get oneWay => 'Aller simple';

  @override
  String get roundTrip => 'Aller-retour';

  @override
  String get discountBadge => '-10%';

  @override
  String get continueToVehicle => 'Continuer vers le choix du véhicule';

  @override
  String get cancelBookingTitle => 'Annuler la réservation ?';

  @override
  String get cancelBookingMessage =>
      'Êtes-vous sûr de vouloir annuler ? Votre progression sera perdue.';

  @override
  String get continueBooking => 'Continuer la réservation';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get gpsComingSoon => 'La localisation GPS sera bientôt disponible.';

  @override
  String get selectVehicle => 'Sélectionner un véhicule';

  @override
  String passengersAndBagsInfo(int passengers, int bags) {
    return '$passengers passagers, $bags gros bagages';
  }

  @override
  String passengersDetailedInfo(
    int total,
    int toddlers,
    int children,
    int bags,
  ) {
    return '$total passagers (dont $toddlers tout-petits, $children enfants), $bags gros bagages';
  }

  @override
  String inclToddlers(int count) {
    return 'dont $count tout-petits';
  }

  @override
  String inclChildren(int count) {
    return 'dont $count enfants';
  }

  @override
  String minChildSeatsRequired(int count) {
    return 'Minimum $count requis pour les tout-petits';
  }

  @override
  String minBoosterSeatsRequired(int count) {
    return 'Minimum $count requis pour les enfants';
  }

  @override
  String notSuitableForPassengersAndBags(int passengers, int bags) {
    return 'Non adapté pour $passengers passagers et $bags bagages';
  }

  @override
  String maxPassengers(int count) {
    return 'Max $count passagers';
  }

  @override
  String maxLargeBags(int count) {
    return 'Max $count gros bagages';
  }

  @override
  String selectedVehicle(String vehicle) {
    return 'Sélectionné : $vehicle';
  }

  @override
  String get continueToExtras => 'Continuer vers les extras';

  @override
  String get failedToLoadVehicles => 'Impossible de charger les véhicules';

  @override
  String get passengers => 'passagers';

  @override
  String get largeBags => 'gros bagages';

  @override
  String get smallBags => 'petits bagages';

  @override
  String get pax => 'pers.';

  @override
  String get extraServices => 'Services supplémentaires';

  @override
  String get optionalServices => 'Services optionnels';

  @override
  String get optionalServicesSubtitle =>
      'Améliorez votre voyage avec ces extras';

  @override
  String get includedServices => 'Services inclus';

  @override
  String get includedServicesSubtitle =>
      'Ces frais peuvent s\'appliquer selon votre trajet';

  @override
  String get selectedExtras => 'Extras sélectionnés :';

  @override
  String get failedToLoadExtras => 'Impossible de charger les extras';

  @override
  String get noExtrasAvailable => 'Aucun extra disponible';

  @override
  String get continueToNextStep => 'Continuer vers l\'étape suivante';

  @override
  String get each => 'chacun';

  @override
  String get passengerDetails => 'Informations passager';

  @override
  String get contactInformation => 'Coordonnées';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get phoneNumberHint => '+33 x xx xx xx xx';

  @override
  String get tripDetailsOptional => 'Détails du voyage (Optionnel)';

  @override
  String get flightNumber => 'Numéro de vol';

  @override
  String get outboundFlightNumber => 'Numéro de vol aller';

  @override
  String get returnFlightNumber => 'Numéro de vol retour';

  @override
  String get flightNumberHint => 'ex. FR1234';

  @override
  String get flightMonitoringInfo =>
      'Nous surveillerons votre vol pour les retards';

  @override
  String get specialRequests => 'Demandes spéciales';

  @override
  String get specialRequestsHint => 'Avez-vous des exigences particulières ?';

  @override
  String get continueToReview => 'Continuer vers le récapitulatif';

  @override
  String get reviewBooking => 'Récapitulatif de la réservation';

  @override
  String get calculatingPrice => 'Calcul du prix final...';

  @override
  String get totalPrice => 'Prix total';

  @override
  String get discountOff => '10% DE RÉDUCTION';

  @override
  String get confirmBooking => 'Confirmer la réservation';

  @override
  String get bookingConfirmed => 'Réservation confirmée !';

  @override
  String get bookingConfirmedMessage =>
      'Votre transfert a été réservé avec succès. Vous recevrez un e-mail de confirmation sous peu.';

  @override
  String get bookingFailed => 'Échec de la réservation';

  @override
  String get failedToCalculatePrice => 'Impossible de calculer le prix';

  @override
  String get agreeToTermsPart1 => 'J\'accepte les ';

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get andConnector => ' et la ';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get priceBreakdown => 'Détail du prix';

  @override
  String get price => 'Prix';

  @override
  String get pricingType => 'Type de tarification';

  @override
  String get fixedRoute => 'Itinéraire fixe';

  @override
  String get distanceBased => 'Basé sur la distance';

  @override
  String get distance => 'Distance';

  @override
  String get basePrice => 'Prix de base';

  @override
  String get multipliersApplied => 'Multiplicateurs appliqués';

  @override
  String vehicleMultiplier(String name) {
    return 'Véhicule ($name)';
  }

  @override
  String passengersMultiplier(int count) {
    return 'Passagers ($count)';
  }

  @override
  String get seasonMultiplier => 'Saison';

  @override
  String seasonMultiplierNamed(String name) {
    return 'Saison ($name)';
  }

  @override
  String get timeMultiplier => 'Horaire';

  @override
  String timeMultiplierNamed(String name) {
    return 'Horaire ($name)';
  }

  @override
  String get subtotal => 'Sous-total';

  @override
  String get extrasTotal => 'Total extras';

  @override
  String get total => 'TOTAL';

  @override
  String get calculationFormula => 'Formule de calcul';

  @override
  String get formulaText =>
      '(Base × Véhicule × Passagers × Saison × Horaire) + Extras';

  @override
  String includesExtras(int count) {
    return 'Comprend $count service(s) supplémentaire(s)';
  }

  @override
  String get stepRoute => 'Itinéraire';

  @override
  String get stepVehicle => 'Véhicule';

  @override
  String get stepExtras => 'Extras';

  @override
  String get stepDetails => 'Infos';

  @override
  String get stepReview => 'Récap.';

  @override
  String get from => 'De';

  @override
  String get to => 'À';

  @override
  String get notSelected => 'Non sélectionné';

  @override
  String get dateNotSelected => 'Date non sélectionnée';

  @override
  String get timeNotSelected => 'Heure non sélectionnée';

  @override
  String get vehicle => 'Véhicule';

  @override
  String get extras => 'Extras';

  @override
  String get passenger => 'Passager';

  @override
  String flightInfo(String number) {
    return 'Vol : $number';
  }

  @override
  String get enterAddressOrSelect =>
      'Entrez l\'adresse ou sélectionnez dans la liste';

  @override
  String get currentLocation => 'Position actuelle';

  @override
  String get currentLocationSubtitle =>
      'Utiliser le GPS pour détecter votre position';

  @override
  String get chooseOnMap => 'Choisir sur la carte';

  @override
  String get chooseOnMapSubtitle =>
      'Sélectionnez un emplacement personnalisé sur la carte';

  @override
  String get noMatchingLocations => 'Aucun emplacement correspondant trouvé';

  @override
  String get pickup => 'Prise en charge';

  @override
  String get dropoff => 'Dépose';

  @override
  String get loadingRoute => 'Chargement de l\'itinéraire...';

  @override
  String get selectLocationsToSeeRoute =>
      'Sélectionnez les emplacements pour voir l\'itinéraire';

  @override
  String get moveMapToSelectLocation =>
      'Déplacez la carte pour sélectionner l\'emplacement';

  @override
  String get selectPickupLocation => 'Sélectionner le lieu de prise en charge';

  @override
  String get selectDropoffLocation => 'Sélectionner le lieu de dépose';

  @override
  String get confirmPickup => 'Confirmer la prise en charge';

  @override
  String get confirmDropoff => 'Confirmer la dépose';

  @override
  String get routePreview => 'Aperçu de l\'itinéraire';

  @override
  String get locationSelected => 'Emplacement sélectionné';

  @override
  String get validationEmailRequired => 'L\'e-mail est requis';

  @override
  String get validationEmailInvalid => 'Veuillez entrer un e-mail valide';

  @override
  String get validationPasswordRequired => 'Le mot de passe est requis';

  @override
  String get validationPasswordMinLength =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get validationConfirmPasswordRequired =>
      'Veuillez confirmer votre mot de passe';

  @override
  String get validationPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName est requis';
  }

  @override
  String get validationPhoneInvalid =>
      'Veuillez entrer un numéro de téléphone valide';

  @override
  String get validationFirstNameRequired => 'Veuillez entrer votre prénom';

  @override
  String get validationLastNameRequired => 'Veuillez entrer votre nom';

  @override
  String get validationPhoneRequired =>
      'Veuillez entrer votre numéro de téléphone';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get bookTransferSubtitle =>
      'Réservez facilement votre transfert aéroport';

  @override
  String get readyToTravel => 'Prêt à Voyager ?';

  @override
  String get bookingDescription =>
      'Réservez votre transfert aéroport en quelques étapes.\nChoisissez votre itinéraire, véhicule et extras.';

  @override
  String get popularRoutes => 'Itinéraires Populaires';

  @override
  String get tabBook => 'Réserver';

  @override
  String get tabMyBookings => 'Mes Réservations';

  @override
  String get tabMore => 'Plus';

  @override
  String get noBookingsYet => 'Pas de Réservations';

  @override
  String get bookingHistoryWillAppear =>
      'Votre historique de réservations apparaîtra ici';

  @override
  String get helpAndSupport => 'Aide & Support';

  @override
  String get helpComingSoon =>
      'L\'aide et le support seront bientôt disponibles.';

  @override
  String get about => 'À propos';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String copyright(String year) {
    return '© $year 8Move Transfer';
  }

  @override
  String get priceFrom => 'à partir de';

  @override
  String get yourRoute => 'Votre itinéraire';

  @override
  String get swapLocations => 'Inverser les lieux';

  @override
  String get travelDate => 'Date de voyage';

  @override
  String get travelDates => 'Dates de voyage';

  @override
  String get outbound => 'ALLER';

  @override
  String get returnTrip => 'RETOUR';

  @override
  String get departure => 'Départ';

  @override
  String get arrival => 'Arrivée';

  @override
  String get departureAbbrev => 'Dép';

  @override
  String get arrivalAbbrev => 'Arr';

  @override
  String get now => 'maintenant';

  @override
  String get applyButton => 'Appliquer';

  @override
  String get outboundDate => 'Date d\'aller';

  @override
  String get returnDateModal => 'Date de retour';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get tripInfo => 'Info trajet';

  @override
  String get distanceLabel => 'DISTANCE';

  @override
  String get durationLabel => 'DURÉE';

  @override
  String get passengersCard => 'Passagers';

  @override
  String get luggageCard => 'Bagages';

  @override
  String get large => 'Grand';

  @override
  String get small => 'Petit';

  @override
  String get surfboardBikeGolf => 'Planche de surf/Vélo/Golf';

  @override
  String get skiSnowboard => 'Ski/Snowboard';

  @override
  String get otherSportsEquipment => 'Autres sports';

  @override
  String get otherSportsPlaceholder => 'Veuillez préciser l\'équipement...';

  @override
  String get hour => 'Heure';

  @override
  String get minute => 'Minute';
}

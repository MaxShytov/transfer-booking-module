// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => '8Move Transfer';

  @override
  String get login => 'Accedi';

  @override
  String get register => 'Registrati';

  @override
  String get logout => 'Esci';

  @override
  String get cancel => 'Annulla';

  @override
  String get ok => 'OK';

  @override
  String get done => 'Fatto';

  @override
  String get retry => 'Riprova';

  @override
  String get skip => 'Salta';

  @override
  String get continueButton => 'Continua';

  @override
  String get edit => 'Modifica';

  @override
  String get close => 'Chiudi';

  @override
  String get expand => 'Espandi';

  @override
  String get selected => 'Selezionato';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Inserisci la tua email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Inserisci la tua password';

  @override
  String get passwordMinChars => 'Almeno 8 caratteri';

  @override
  String get confirmPassword => 'Conferma Password';

  @override
  String get confirmPasswordHint => 'Ripeti la tua password';

  @override
  String get firstName => 'Nome';

  @override
  String get firstNameHint => 'Inserisci il tuo nome';

  @override
  String get lastName => 'Cognome';

  @override
  String get lastNameHint => 'Inserisci il tuo cognome';

  @override
  String get phone => 'Telefono';

  @override
  String get phoneOptional => 'Telefono (opzionale)';

  @override
  String get phoneHint => '+39 123 456 7890';

  @override
  String get loginError => 'Errore di Accesso';

  @override
  String get noAccount => 'Non hai un account?';

  @override
  String get createAccount => 'Crea Account';

  @override
  String get alreadyHaveAccount => 'Hai già un account?';

  @override
  String get logoutConfirmTitle => 'Esci';

  @override
  String get logoutConfirmMessage => 'Sei sicuro di voler uscire?';

  @override
  String get profile => 'Profilo';

  @override
  String get language => 'Lingua';

  @override
  String get notSet => 'Non impostato';

  @override
  String get roleAdmin => 'Amministratore';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleDriver => 'Autista';

  @override
  String get roleCustomer => 'Cliente';

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
  String get bookTransfer => 'Prenota un Transfer';

  @override
  String get route => 'Percorso';

  @override
  String get pickupLocation => 'Luogo di Partenza';

  @override
  String get dropoffLocation => 'Luogo di Arrivo';

  @override
  String get dateTime => 'Data e Ora';

  @override
  String get pickupDate => 'Data di Partenza';

  @override
  String get returnDate => 'Data di Ritorno';

  @override
  String get time => 'Ora';

  @override
  String get date => 'Data';

  @override
  String get selectDate => 'Seleziona data';

  @override
  String get selectTime => 'Seleziona ora';

  @override
  String get passengersAndLuggage => 'Passeggeri e Bagagli';

  @override
  String get adults => 'Adulti';

  @override
  String get children => 'Bambini';

  @override
  String get childrenSubtitle => 'Sotto i 12 anni';

  @override
  String get largeLuggage => 'Bagaglio Grande';

  @override
  String get largeLuggageSubtitle => 'Valigie, borse grandi';

  @override
  String get smallLuggage => 'Bagaglio Piccolo';

  @override
  String get smallLuggageSubtitle => 'Zaini, bagaglio a mano';

  @override
  String get oneWay => 'Solo Andata';

  @override
  String get roundTrip => 'Andata e Ritorno';

  @override
  String get discountBadge => '-10%';

  @override
  String get continueToVehicle => 'Continua alla Scelta Veicolo';

  @override
  String get cancelBookingTitle => 'Annullare la Prenotazione?';

  @override
  String get cancelBookingMessage =>
      'Sei sicuro di voler annullare? I tuoi progressi andranno persi.';

  @override
  String get continueBooking => 'Continua Prenotazione';

  @override
  String get comingSoon => 'Prossimamente';

  @override
  String get gpsComingSoon => 'La localizzazione GPS sarà disponibile presto.';

  @override
  String get selectVehicle => 'Seleziona Veicolo';

  @override
  String passengersAndBagsInfo(int passengers, int bags) {
    return '$passengers passeggeri, $bags bagagli grandi';
  }

  @override
  String notSuitableForPassengersAndBags(int passengers, int bags) {
    return 'Non adatto per $passengers passeggeri e $bags bagagli';
  }

  @override
  String maxPassengers(int count) {
    return 'Max $count passeggeri';
  }

  @override
  String maxLargeBags(int count) {
    return 'Max $count bagagli grandi';
  }

  @override
  String selectedVehicle(String vehicle) {
    return 'Selezionato: $vehicle';
  }

  @override
  String get continueToExtras => 'Continua agli Extra';

  @override
  String get failedToLoadVehicles => 'Impossibile caricare i veicoli';

  @override
  String get passengers => 'passeggeri';

  @override
  String get largeBags => 'bagagli grandi';

  @override
  String get smallBags => 'bagagli piccoli';

  @override
  String get pax => 'pax';

  @override
  String get extraServices => 'Servizi Extra';

  @override
  String get optionalServices => 'Servizi Opzionali';

  @override
  String get optionalServicesSubtitle =>
      'Arricchisci il tuo viaggio con questi extra';

  @override
  String get includedServices => 'Servizi Inclusi';

  @override
  String get includedServicesSubtitle =>
      'Questi costi potrebbero essere applicati in base al tuo viaggio';

  @override
  String get selectedExtras => 'Extra selezionati:';

  @override
  String get failedToLoadExtras => 'Impossibile caricare gli extra';

  @override
  String get noExtrasAvailable => 'Nessun extra disponibile';

  @override
  String get continueToNextStep => 'Continua al prossimo passo';

  @override
  String get each => 'cad.';

  @override
  String get passengerDetails => 'Dati Passeggero';

  @override
  String get contactInformation => 'Informazioni di Contatto';

  @override
  String get phoneNumber => 'Numero di Telefono';

  @override
  String get phoneNumberHint => '+39 xxx xxx xxxx';

  @override
  String get tripDetailsOptional => 'Dettagli Viaggio (Opzionale)';

  @override
  String get flightNumber => 'Numero Volo';

  @override
  String get flightNumberHint => 'es. FR1234';

  @override
  String get flightMonitoringInfo =>
      'Monitoreremo il tuo volo per eventuali ritardi';

  @override
  String get specialRequests => 'Richieste Speciali';

  @override
  String get specialRequestsHint => 'Hai richieste particolari?';

  @override
  String get continueToReview => 'Continua al Riepilogo';

  @override
  String get reviewBooking => 'Riepilogo Prenotazione';

  @override
  String get calculatingPrice => 'Calcolo del prezzo finale...';

  @override
  String get totalPrice => 'Prezzo Totale';

  @override
  String get discountOff => '10% DI SCONTO';

  @override
  String get confirmBooking => 'Conferma Prenotazione';

  @override
  String get bookingConfirmed => 'Prenotazione Confermata!';

  @override
  String get bookingConfirmedMessage =>
      'Il tuo transfer è stato prenotato con successo. Riceverai un\'email di conferma a breve.';

  @override
  String get bookingFailed => 'Prenotazione Fallita';

  @override
  String get failedToCalculatePrice => 'Impossibile calcolare il prezzo';

  @override
  String get agreeToTermsPart1 => 'Accetto i ';

  @override
  String get termsAndConditions => 'Termini e Condizioni';

  @override
  String get andConnector => ' e la ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get priceBreakdown => 'Dettaglio Prezzo';

  @override
  String get price => 'Prezzo';

  @override
  String get pricingType => 'Tipo di Prezzo';

  @override
  String get fixedRoute => 'Percorso Fisso';

  @override
  String get distanceBased => 'Basato sulla Distanza';

  @override
  String get distance => 'Distanza';

  @override
  String get basePrice => 'Prezzo Base';

  @override
  String get multipliersApplied => 'Moltiplicatori Applicati';

  @override
  String vehicleMultiplier(String name) {
    return 'Veicolo ($name)';
  }

  @override
  String passengersMultiplier(int count) {
    return 'Passeggeri ($count)';
  }

  @override
  String get seasonMultiplier => 'Stagione';

  @override
  String seasonMultiplierNamed(String name) {
    return 'Stagione ($name)';
  }

  @override
  String get timeMultiplier => 'Orario';

  @override
  String timeMultiplierNamed(String name) {
    return 'Orario ($name)';
  }

  @override
  String get subtotal => 'Subtotale';

  @override
  String get extrasTotal => 'Totale Extra';

  @override
  String get total => 'TOTALE';

  @override
  String get calculationFormula => 'Formula di Calcolo';

  @override
  String get formulaText =>
      '(Base × Veicolo × Passeggeri × Stagione × Orario) + Extra';

  @override
  String includesExtras(int count) {
    return 'Include $count servizio/i extra';
  }

  @override
  String get stepRoute => 'Percorso';

  @override
  String get stepVehicle => 'Veicolo';

  @override
  String get stepExtras => 'Extra';

  @override
  String get stepDetails => 'Dati';

  @override
  String get stepReview => 'Riepilogo';

  @override
  String get from => 'Da';

  @override
  String get to => 'A';

  @override
  String get notSelected => 'Non selezionato';

  @override
  String get dateNotSelected => 'Data non selezionata';

  @override
  String get timeNotSelected => 'Ora non selezionata';

  @override
  String get vehicle => 'Veicolo';

  @override
  String get extras => 'Extra';

  @override
  String get passenger => 'Passeggero';

  @override
  String flightInfo(String number) {
    return 'Volo: $number';
  }

  @override
  String get enterAddressOrSelect =>
      'Inserisci indirizzo o seleziona dalla lista';

  @override
  String get currentLocation => 'Posizione Attuale';

  @override
  String get currentLocationSubtitle =>
      'Usa il GPS per rilevare la tua posizione';

  @override
  String get chooseOnMap => 'Scegli sulla Mappa';

  @override
  String get chooseOnMapSubtitle =>
      'Seleziona una posizione personalizzata sulla mappa';

  @override
  String get noMatchingLocations => 'Nessuna posizione corrispondente trovata';

  @override
  String get pickup => 'Partenza';

  @override
  String get dropoff => 'Arrivo';

  @override
  String get loadingRoute => 'Caricamento percorso...';

  @override
  String get selectLocationsToSeeRoute =>
      'Seleziona le posizioni per vedere il percorso';

  @override
  String get moveMapToSelectLocation =>
      'Sposta la mappa per selezionare la posizione';

  @override
  String get selectPickupLocation => 'Seleziona Luogo di Partenza';

  @override
  String get selectDropoffLocation => 'Seleziona Luogo di Arrivo';

  @override
  String get confirmPickup => 'Conferma Partenza';

  @override
  String get confirmDropoff => 'Conferma Arrivo';

  @override
  String get routePreview => 'Anteprima Percorso';

  @override
  String get locationSelected => 'Posizione selezionata';

  @override
  String get validationEmailRequired => 'L\'email è obbligatoria';

  @override
  String get validationEmailInvalid => 'Inserisci un\'email valida';

  @override
  String get validationPasswordRequired => 'La password è obbligatoria';

  @override
  String get validationPasswordMinLength =>
      'La password deve contenere almeno 8 caratteri';

  @override
  String get validationConfirmPasswordRequired => 'Conferma la tua password';

  @override
  String get validationPasswordsDoNotMatch => 'Le password non corrispondono';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName è obbligatorio';
  }

  @override
  String get validationPhoneInvalid => 'Inserisci un numero di telefono valido';

  @override
  String get validationFirstNameRequired => 'Inserisci il tuo nome';

  @override
  String get validationLastNameRequired => 'Inserisci il tuo cognome';

  @override
  String get validationPhoneRequired => 'Inserisci il tuo numero di telefono';

  @override
  String get selectLanguage => 'Seleziona Lingua';

  @override
  String get systemDefault => 'Predefinito di Sistema';

  @override
  String get bookTransferSubtitle =>
      'Prenota facilmente il tuo transfer aeroportuale';

  @override
  String get readyToTravel => 'Pronto a Viaggiare?';

  @override
  String get bookingDescription =>
      'Prenota il tuo transfer aeroportuale in pochi passi.\nScegli il percorso, il veicolo e gli extra.';

  @override
  String get popularRoutes => 'Percorsi Popolari';

  @override
  String get tabBook => 'Prenota';

  @override
  String get tabMyBookings => 'Le Mie Prenotazioni';

  @override
  String get tabMore => 'Altro';

  @override
  String get noBookingsYet => 'Nessuna Prenotazione';

  @override
  String get bookingHistoryWillAppear =>
      'Lo storico delle prenotazioni apparirà qui';

  @override
  String get helpAndSupport => 'Assistenza e Supporto';

  @override
  String get helpComingSoon =>
      'Assistenza e Supporto saranno disponibili a breve.';

  @override
  String get about => 'Informazioni';

  @override
  String version(String version) {
    return 'Versione $version';
  }

  @override
  String copyright(String year) {
    return '© $year 8Move Transfer';
  }

  @override
  String get priceFrom => 'da';
}

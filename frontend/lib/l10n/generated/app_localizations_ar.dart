// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => '8Move Transfer';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'موافق';

  @override
  String get done => 'تم';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get skip => 'تخطي';

  @override
  String get continueButton => 'متابعة';

  @override
  String get edit => 'تعديل';

  @override
  String get close => 'إغلاق';

  @override
  String get expand => 'توسيع';

  @override
  String get selected => 'محدد';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get passwordMinChars => '8 أحرف على الأقل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get firstNameHint => 'أدخل اسمك الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get lastNameHint => 'أدخل اسم العائلة';

  @override
  String get phone => 'الهاتف';

  @override
  String get phoneOptional => 'الهاتف (اختياري)';

  @override
  String get phoneHint => '+966 5x xxx xxxx';

  @override
  String get loginError => 'خطأ في تسجيل الدخول';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get logoutConfirmTitle => 'تسجيل الخروج';

  @override
  String get logoutConfirmMessage => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get language => 'اللغة';

  @override
  String get notSet => 'غير محدد';

  @override
  String get roleAdmin => 'مدير النظام';

  @override
  String get roleManager => 'مدير';

  @override
  String get roleDriver => 'سائق';

  @override
  String get roleCustomer => 'عميل';

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
  String get bookTransfer => 'حجز نقل';

  @override
  String get route => 'المسار';

  @override
  String get pickupLocation => 'موقع الانطلاق';

  @override
  String get dropoffLocation => 'موقع الوصول';

  @override
  String get dateTime => 'التاريخ والوقت';

  @override
  String get pickupDate => 'تاريخ الانطلاق';

  @override
  String get returnDate => 'تاريخ العودة';

  @override
  String get time => 'الوقت';

  @override
  String get date => 'التاريخ';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get passengersAndLuggage => 'الركاب والأمتعة';

  @override
  String get adults => 'البالغون';

  @override
  String get children => 'الأطفال';

  @override
  String get childrenSubtitle => 'أقل من 12 سنة';

  @override
  String get largeLuggage => 'أمتعة كبيرة';

  @override
  String get largeLuggageSubtitle => 'حقائب سفر، حقائب كبيرة';

  @override
  String get smallLuggage => 'أمتعة صغيرة';

  @override
  String get smallLuggageSubtitle => 'حقائب ظهر، حقائب يد';

  @override
  String get oneWay => 'ذهاب فقط';

  @override
  String get roundTrip => 'ذهاب وعودة';

  @override
  String get discountBadge => '-10%';

  @override
  String get continueToVehicle => 'المتابعة لاختيار السيارة';

  @override
  String get cancelBookingTitle => 'إلغاء الحجز؟';

  @override
  String get cancelBookingMessage =>
      'هل أنت متأكد من رغبتك في الإلغاء؟ ستفقد تقدمك.';

  @override
  String get continueBooking => 'متابعة الحجز';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get gpsComingSoon => 'ستتوفر خدمة تحديد الموقع GPS قريباً.';

  @override
  String get selectVehicle => 'اختر السيارة';

  @override
  String passengersAndBagsInfo(int passengers, int bags) {
    return '$passengers ركاب، $bags أمتعة كبيرة';
  }

  @override
  String notSuitableForPassengersAndBags(int passengers, int bags) {
    return 'غير مناسب لـ $passengers ركاب و $bags أمتعة';
  }

  @override
  String maxPassengers(int count) {
    return 'الحد الأقصى $count ركاب';
  }

  @override
  String maxLargeBags(int count) {
    return 'الحد الأقصى $count أمتعة كبيرة';
  }

  @override
  String selectedVehicle(String vehicle) {
    return 'المحدد: $vehicle';
  }

  @override
  String get continueToExtras => 'المتابعة للخدمات الإضافية';

  @override
  String get failedToLoadVehicles => 'فشل في تحميل السيارات';

  @override
  String get passengers => 'ركاب';

  @override
  String get largeBags => 'أمتعة كبيرة';

  @override
  String get smallBags => 'أمتعة صغيرة';

  @override
  String get pax => 'راكب';

  @override
  String get extraServices => 'الخدمات الإضافية';

  @override
  String get optionalServices => 'خدمات اختيارية';

  @override
  String get optionalServicesSubtitle => 'حسّن رحلتك بهذه الإضافات';

  @override
  String get includedServices => 'الخدمات المشمولة';

  @override
  String get includedServicesSubtitle => 'قد تُطبق هذه الرسوم حسب رحلتك';

  @override
  String get selectedExtras => 'الإضافات المحددة:';

  @override
  String get failedToLoadExtras => 'فشل في تحميل الإضافات';

  @override
  String get noExtrasAvailable => 'لا توجد إضافات متاحة';

  @override
  String get continueToNextStep => 'المتابعة للخطوة التالية';

  @override
  String get each => 'للقطعة';

  @override
  String get passengerDetails => 'بيانات الراكب';

  @override
  String get contactInformation => 'معلومات الاتصال';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneNumberHint => '+966 5x xxx xxxx';

  @override
  String get tripDetailsOptional => 'تفاصيل الرحلة (اختياري)';

  @override
  String get flightNumber => 'رقم الرحلة';

  @override
  String get outboundFlightNumber => 'رقم رحلة الذهاب';

  @override
  String get returnFlightNumber => 'رقم رحلة العودة';

  @override
  String get flightNumberHint => 'مثال: FR1234';

  @override
  String get flightMonitoringInfo => 'سنراقب رحلتك لمعرفة التأخيرات';

  @override
  String get specialRequests => 'طلبات خاصة';

  @override
  String get specialRequestsHint => 'هل لديك متطلبات خاصة؟';

  @override
  String get continueToReview => 'المتابعة للمراجعة';

  @override
  String get reviewBooking => 'مراجعة الحجز';

  @override
  String get calculatingPrice => 'جارٍ حساب السعر النهائي...';

  @override
  String get totalPrice => 'السعر الإجمالي';

  @override
  String get discountOff => 'خصم 10%';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get bookingConfirmed => 'تم تأكيد الحجز!';

  @override
  String get bookingConfirmedMessage =>
      'تم حجز النقل بنجاح. ستتلقى رسالة تأكيد عبر البريد الإلكتروني قريباً.';

  @override
  String get bookingFailed => 'فشل الحجز';

  @override
  String get failedToCalculatePrice => 'فشل في حساب السعر';

  @override
  String get agreeToTermsPart1 => 'أوافق على ';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get andConnector => ' و';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get priceBreakdown => 'تفاصيل السعر';

  @override
  String get price => 'السعر';

  @override
  String get pricingType => 'نوع التسعير';

  @override
  String get fixedRoute => 'مسار ثابت';

  @override
  String get distanceBased => 'حسب المسافة';

  @override
  String get distance => 'المسافة';

  @override
  String get basePrice => 'السعر الأساسي';

  @override
  String get multipliersApplied => 'المعاملات المطبقة';

  @override
  String vehicleMultiplier(String name) {
    return 'السيارة ($name)';
  }

  @override
  String passengersMultiplier(int count) {
    return 'الركاب ($count)';
  }

  @override
  String get seasonMultiplier => 'الموسم';

  @override
  String seasonMultiplierNamed(String name) {
    return 'الموسم ($name)';
  }

  @override
  String get timeMultiplier => 'الوقت';

  @override
  String timeMultiplierNamed(String name) {
    return 'الوقت ($name)';
  }

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get extrasTotal => 'إجمالي الإضافات';

  @override
  String get total => 'الإجمالي';

  @override
  String get calculationFormula => 'صيغة الحساب';

  @override
  String get formulaText =>
      '(الأساسي × السيارة × الركاب × الموسم × الوقت) + الإضافات';

  @override
  String includesExtras(int count) {
    return 'يشمل $count خدمة إضافية';
  }

  @override
  String get stepRoute => 'المسار';

  @override
  String get stepVehicle => 'السيارة';

  @override
  String get stepExtras => 'الإضافات';

  @override
  String get stepDetails => 'البيانات';

  @override
  String get stepReview => 'المراجعة';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get notSelected => 'غير محدد';

  @override
  String get dateNotSelected => 'التاريخ غير محدد';

  @override
  String get timeNotSelected => 'الوقت غير محدد';

  @override
  String get vehicle => 'السيارة';

  @override
  String get extras => 'الإضافات';

  @override
  String get passenger => 'الراكب';

  @override
  String flightInfo(String number) {
    return 'رقم الرحلة: $number';
  }

  @override
  String get enterAddressOrSelect => 'أدخل العنوان أو اختر من القائمة';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get currentLocationSubtitle => 'استخدم GPS لتحديد موقعك';

  @override
  String get chooseOnMap => 'اختر على الخريطة';

  @override
  String get chooseOnMapSubtitle => 'حدد موقعاً مخصصاً على الخريطة';

  @override
  String get noMatchingLocations => 'لم يتم العثور على مواقع مطابقة';

  @override
  String get pickup => 'الانطلاق';

  @override
  String get dropoff => 'الوصول';

  @override
  String get loadingRoute => 'جارٍ تحميل المسار...';

  @override
  String get selectLocationsToSeeRoute => 'اختر المواقع لعرض المسار';

  @override
  String get moveMapToSelectLocation => 'حرّك الخريطة لاختيار الموقع';

  @override
  String get selectPickupLocation => 'اختر موقع الانطلاق';

  @override
  String get selectDropoffLocation => 'اختر موقع الوصول';

  @override
  String get confirmPickup => 'تأكيد الانطلاق';

  @override
  String get confirmDropoff => 'تأكيد الوصول';

  @override
  String get routePreview => 'معاينة المسار';

  @override
  String get locationSelected => 'تم تحديد الموقع';

  @override
  String get validationEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get validationEmailInvalid => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get validationPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get validationPasswordMinLength =>
      'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل';

  @override
  String get validationConfirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get validationPasswordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName مطلوب';
  }

  @override
  String get validationPhoneInvalid => 'يرجى إدخال رقم هاتف صحيح';

  @override
  String get validationFirstNameRequired => 'يرجى إدخال اسمك الأول';

  @override
  String get validationLastNameRequired => 'يرجى إدخال اسم العائلة';

  @override
  String get validationPhoneRequired => 'يرجى إدخال رقم هاتفك';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get systemDefault => 'إعداد النظام';

  @override
  String get bookTransferSubtitle => 'احجز خدمة النقل من المطار بسهولة';

  @override
  String get readyToTravel => 'هل أنت مستعد للسفر؟';

  @override
  String get bookingDescription =>
      'احجز خدمة النقل من المطار في خطوات بسيطة.\nاختر مسارك، السيارة، والإضافات.';

  @override
  String get popularRoutes => 'المسارات الشائعة';

  @override
  String get tabBook => 'حجز';

  @override
  String get tabMyBookings => 'حجوزاتي';

  @override
  String get tabMore => 'المزيد';

  @override
  String get noBookingsYet => 'لا توجد حجوزات بعد';

  @override
  String get bookingHistoryWillAppear => 'سيظهر سجل حجوزاتك هنا';

  @override
  String get helpAndSupport => 'المساعدة والدعم';

  @override
  String get helpComingSoon => 'ستتوفر المساعدة والدعم قريباً.';

  @override
  String get about => 'حول التطبيق';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String copyright(String year) {
    return '© $year 8Move Transfer';
  }

  @override
  String get priceFrom => 'من';

  @override
  String get yourRoute => 'مسارك';

  @override
  String get swapLocations => 'تبديل المواقع';

  @override
  String get travelDate => 'تاريخ السفر';

  @override
  String get travelDates => 'تواريخ السفر';

  @override
  String get outbound => 'الذهاب';

  @override
  String get returnTrip => 'العودة';

  @override
  String get departure => 'المغادرة';

  @override
  String get arrival => 'الوصول';

  @override
  String get departureAbbrev => 'مغا';

  @override
  String get arrivalAbbrev => 'وصو';

  @override
  String get now => 'الآن';

  @override
  String get applyButton => 'تطبيق';

  @override
  String get outboundDate => 'تاريخ الذهاب';

  @override
  String get returnDateModal => 'تاريخ العودة';

  @override
  String get today => 'اليوم';

  @override
  String get tripInfo => 'معلومات الرحلة';

  @override
  String get distanceLabel => 'المسافة';

  @override
  String get durationLabel => 'المدة';

  @override
  String get passengersCard => 'الركاب';

  @override
  String get luggageCard => 'الأمتعة';

  @override
  String get large => 'كبير';

  @override
  String get small => 'صغير';

  @override
  String get surfboardBikeGolf => 'لوح تزلج/دراجة/غولف';

  @override
  String get skiSnowboard => 'تزلج/سنوبورد';

  @override
  String get otherSportsEquipment => 'رياضات أخرى';

  @override
  String get otherSportsPlaceholder => 'يرجى تحديد المعدات...';

  @override
  String get hour => 'الساعة';

  @override
  String get minute => 'الدقيقة';
}

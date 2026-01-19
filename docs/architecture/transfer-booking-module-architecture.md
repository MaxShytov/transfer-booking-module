# Transfer Booking Module - Architecture & Planning

**Project:** transfer-booking-module  
**Tech Stack:** Django + PostgreSQL + Flutter Web  
**Target Client:** Sardinia Airport Transfer (Marco Cutolo)  
**Date:** January 15, 2026

---

## 🏗️ PROJECT STRUCTURE

```
transfer-booking-module/
│
├── backend/                           # Django Backend
│   ├── apps/                          # Django Applications
│   │   ├── core/                      # Base utilities, mixins, abstract models
│   │   │   ├── __init__.py
│   │   │   ├── models.py              # TimeStampedModel, UUIDModel, etc.
│   │   │   ├── managers.py            # Custom QuerySet managers
│   │   │   ├── mixins.py              # Model mixins
│   │   │   ├── utils.py               # Utility functions (haversine, etc.)
│   │   │   ├── validators.py          # Custom validators
│   │   │   └── exceptions.py          # Custom exceptions
│   │   │
│   │   ├── accounts/                  # User authentication & management
│   │   │   ├── migrations/            # Django migrations
│   │   │   ├── __init__.py
│   │   │   ├── models.py              # User, UserProfile
│   │   │   ├── managers.py            # UserManager
│   │   │   ├── serializers.py         # API serializers
│   │   │   ├── views.py               # Login, Register, Profile
│   │   │   ├── urls.py
│   │   │   ├── permissions.py         # Custom permissions
│   │   │   ├── tokens.py              # JWT tokens
│   │   │   ├── admin.py
│   │   │   └── tests/
│   │   │
│   │   ├── routes/                    # Fixed routes & distance pricing
│   │   │   ├── migrations/            # Django migrations
│   │   │   ├── fixtures/              # Initial data (JSON)
│   │   │   │   └── sardinia_routes.json
│   │   │   ├── management/
│   │   │   │   └── commands/
│   │   │   │       └── seed_routes.py
│   │   │   ├── __init__.py
│   │   │   ├── models.py              # FixedRoute, DistancePricingRule
│   │   │   ├── serializers.py
│   │   │   ├── views.py               # CRUD routes, route matching
│   │   │   ├── urls.py
│   │   │   ├── services.py            # RouteMatchingService, DistanceCalculator
│   │   │   ├── admin.py
│   │   │   └── tests/
│   │   │
│   │   ├── vehicles/                  # Vehicle classes & requirements
│   │   │   ├── migrations/
│   │   │   ├── fixtures/
│   │   │   │   └── vehicle_classes.json
│   │   │   ├── management/
│   │   │   │   └── commands/
│   │   │   │       └── seed_vehicle_classes.py
│   │   │   ├── __init__.py
│   │   │   ├── models.py              # VehicleClass, VehicleClassRequirement
│   │   │   ├── serializers.py
│   │   │   ├── views.py               # Available vehicles API
│   │   │   ├── urls.py
│   │   │   ├── services.py            # VehicleSelectionService
│   │   │   ├── admin.py
│   │   │   └── tests/
│   │   │
│   │   ├── pricing/                   # Pricing engine
│   │   │   ├── migrations/
│   │   │   ├── fixtures/
│   │   │   │   ├── seasonal_multipliers.json
│   │   │   │   ├── passenger_multipliers.json
│   │   │   │   └── time_multipliers.json
│   │   │   ├── management/
│   │   │   │   └── commands/
│   │   │   │       └── seed_pricing_multipliers.py
│   │   │   ├── __init__.py
│   │   │   ├── models.py              # SeasonalMultiplier, PassengerMultiplier, TimeMultiplier, ExtraFee
│   │   │   ├── serializers.py
│   │   │   ├── views.py               # Price calculation API
│   │   │   ├── urls.py
│   │   │   ├── calculator.py          # PriceCalculator (main logic)
│   │   │   ├── services.py            # MultiplierService
│   │   │   ├── admin.py
│   │   │   └── tests/
│   │   │
│   │   ├── bookings/                  # Booking management
│   │   │   ├── migrations/
│   │   │   ├── __init__.py
│   │   │   ├── models.py              # Booking, BookingStatus
│   │   │   ├── serializers.py
│   │   │   ├── views.py               # Create, List, Detail, Update, Cancel
│   │   │   ├── urls.py
│   │   │   ├── services.py            # BookingService, ConfirmationService
│   │   │   ├── signals.py             # Email notifications
│   │   │   ├── tasks.py               # Celery tasks (future)
│   │   │   ├── admin.py
│   │   │   └── tests/
│   │   │
│   │   ├── payments/                  # Payment integrations (Phase 2)
│   │   │   ├── migrations/
│   │   │   ├── __init__.py
│   │   │   ├── models.py              # Payment, Transaction
│   │   │   ├── serializers.py
│   │   │   ├── views.py
│   │   │   ├── urls.py
│   │   │   ├── stripe_service.py      # Stripe integration
│   │   │   ├── paypal_service.py      # PayPal integration
│   │   │   └── tests/
│   │   │
│   │   └── notifications/             # Email & SMS notifications
│   │       ├── migrations/
│   │       ├── __init__.py
│   │       ├── models.py              # EmailTemplate, NotificationLog
│   │       ├── services.py            # EmailService, SMSService
│   │       ├── templates/             # Email templates (HTML)
│   │       └── tests/
│   │
│   ├── config/                        # Django settings
│   │   ├── __init__.py
│   │   ├── settings/
│   │   │   ├── __init__.py
│   │   │   ├── base.py                # Base settings
│   │   │   ├── development.py         # Local dev settings
│   │   │   ├── production.py          # Production settings
│   │   │   └── test.py                # Test settings
│   │   ├── urls.py                    # Root URLconf
│   │   ├── wsgi.py
│   │   └── asgi.py
│   │
│   ├── templates/                     # Global Django templates
│   │   ├── base.html
│   │   ├── emails/
│   │   │   ├── booking_confirmation.html
│   │   │   ├── booking_reminder.html
│   │   │   └── password_reset.html
│   │   └── admin/                     # Custom admin templates
│   │
│   ├── static/                        # Static files
│   │   ├── css/
│   │   ├── js/
│   │   └── images/
│   │
│   ├── locale/                        # Translations (i18n)
│   │   ├── en/                        # English
│   │   ├── it/                        # Italian
│   │   ├── de/                        # German
│   │   ├── fr/                        # French
│   │   └── ar/                        # Arabic (RTL)
│   │
│   ├── requirements/                  # Python dependencies
│   │   ├── base.txt                   # Common requirements
│   │   ├── development.txt            # Dev tools (pytest, black, etc.)
│   │   └── production.txt             # Production deps (gunicorn, etc.)
│   │
│   ├── scripts/                       # Utility scripts
│   │   ├── backup_db.sh               # PostgreSQL backup script
│   │   └── restore_db.sh              # PostgreSQL restore script
│   │
│   ├── manage.py                      # Django management script
│   ├── docker-compose.yml             # Docker services (PostgreSQL, Redis)
│   ├── requirements.txt               # Main requirements file
│   ├── pytest.ini                     # Pytest configuration
│   ├── .env.example                   # Environment variables template
│   ├── .gitignore
│   └── README.md
│
├── frontend/                          # Flutter Web
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── core/                      # Core utilities
│   │   │   ├── constants.dart
│   │   │   ├── theme.dart
│   │   │   ├── api_client.dart
│   │   │   └── utils.dart
│   │   ├── models/                    # Data models
│   │   │   ├── booking.dart
│   │   │   ├── route.dart
│   │   │   ├── vehicle.dart
│   │   │   └── price_calculation.dart
│   │   ├── services/                  # API services
│   │   │   ├── booking_service.dart
│   │   │   ├── route_service.dart
│   │   │   ├── pricing_service.dart
│   │   │   └── auth_service.dart
│   │   ├── screens/                   # UI screens
│   │   │   ├── home_screen.dart
│   │   │   ├── booking/
│   │   │   │   ├── booking_form_screen.dart
│   │   │   │   ├── vehicle_selection_screen.dart
│   │   │   │   ├── booking_summary_screen.dart
│   │   │   │   └── booking_confirmation_screen.dart
│   │   │   ├── admin/
│   │   │   │   ├── dashboard_screen.dart
│   │   │   │   ├── routes_management_screen.dart
│   │   │   │   ├── pricing_management_screen.dart
│   │   │   │   └── bookings_list_screen.dart
│   │   │   └── auth/
│   │   │       ├── login_screen.dart
│   │   │       └── register_screen.dart
│   │   ├── widgets/                   # Reusable widgets
│   │   │   ├── location_autocomplete.dart
│   │   │   ├── date_time_picker.dart
│   │   │   ├── vehicle_card.dart
│   │   │   ├── price_breakdown.dart
│   │   │   └── loading_indicator.dart
│   │   └── providers/                 # State management (Provider/Riverpod)
│   │       ├── booking_provider.dart
│   │       ├── auth_provider.dart
│   │       └── pricing_provider.dart
│   ├── assets/
│   │   ├── images/
│   │   │   ├── vehicles/
│   │   │   └── logos/
│   │   └── fonts/
│   ├── test/
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   └── README.md
│
├── docs/                              # Documentation & project management
│   ├── initial_requirements/          # Initial specs from client
│   │   ├── marco_original_request.md
│   │   ├── business_logic.md
│   │   └── clarification_questions_answered.md
│   ├── current_tasks/                 # Active tasks (Kanban style)
│   │   ├── sprint_1_setup.md
│   │   ├── sprint_2_core_features.md
│   │   └── sprint_3_frontend.md
│   ├── completed_tasks/               # Done tasks (archive)
│   │   └── .gitkeep
│   ├── architecture/                  # Technical docs
│   │   ├── api_design.md              # API endpoints
│   │   ├── database_schema.md         # Full DB schema (from v2.1)
│   │   ├── pricing_algorithm.md       # Price calculation logic
│   │   └── deployment.md              # Deployment guide
│   ├── user_guides/                   # End-user documentation
│   │   ├── admin_manual.md
│   │   └── customer_guide.md
│   └── meeting_notes/                 # Client meeting notes
│       └── 2026-01-15_kickoff.md
│
└── deploy/                            # Deployment configurations
    ├── docker/
    │   ├── Dockerfile.backend
    │   ├── Dockerfile.frontend
    │   └── docker-compose.production.yml
    ├── nginx/
    │   ├── nginx.conf
    │   └── ssl/
    ├── infomaniak/                    # Infomaniak-specific configs
    │   ├── deployment_guide.md
    │   └── env_vars.md
    ├── scripts/
    │   ├── deploy.sh
    │   ├── backup.sh
    │   └── restore.sh
    └── README.md

# Additional files in project root:
│
├── venv/                              # Python virtual environment (git-ignored)
├── start.sh                           # Development startup script
├── .gitignore
└── README.md                          # Project overview
```

**Key Notes:**
- `venv/` is created by `start.sh` and should be in `.gitignore`
- `start.sh` handles: Docker startup, venv creation, dependencies, migrations, and server launch
- `backend/docker-compose.yml` contains PostgreSQL and Redis services
- Initial data loaded via Django fixtures or management commands (not SQL files)

---

## 📦 DJANGO APPS BREAKDOWN

### 1. **apps/core** - Base utilities

**Purpose:** Shared functionality across all apps

**Models:**
- `TimeStampedModel` (abstract) - created_at, updated_at
- `UUIDModel` (abstract) - UUID primary key
- `SoftDeleteModel` (abstract) - is_deleted, deleted_at

**Key Files:**
```python
# models.py
class TimeStampedModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    class Meta:
        abstract = True

# managers.py
class SoftDeleteManager(models.Manager):
    def get_queryset(self):
        return super().get_queryset().filter(is_deleted=False)

# validators.py
def validate_phone_number(value):
    # International phone validation
    pass

# utils.py
def haversine_distance(lat1, lng1, lat2, lng2):
    # Calculate distance between coordinates
    pass
```

---

### 2. **apps/accounts** - User management

**Purpose:** Authentication, user profiles, permissions

**Models:**
- `User` (CustomUser) - email as username, first_name, last_name, phone, language
- `UserProfile` - additional user data, preferences

**Key Endpoints:**
```
POST   /api/v1/auth/register/
POST   /api/v1/auth/login/
POST   /api/v1/auth/logout/
POST   /api/v1/auth/refresh/
GET    /api/v1/auth/me/
PUT    /api/v1/auth/me/
POST   /api/v1/auth/password/reset/
POST   /api/v1/auth/password/reset/confirm/
```

**Key Files:**
```python
# models.py
from django.contrib.auth.models import AbstractBaseUser
class User(AbstractBaseUser, TimeStampedModel):
    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=150)
    language = models.CharField(max_length=2, choices=LANGUAGES)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    
# serializers.py
class UserRegistrationSerializer(serializers.ModelSerializer):
    # Registration logic
    
# views.py
class RegisterView(APIView):
    # Handle registration
```

---

### 3. **apps/routes** - Route management

**Purpose:** Fixed routes, distance pricing rules, route matching

**Models:**
- `FixedRoute` - Popular routes with fixed prices
- `DistancePricingRule` - Distance-based pricing tiers
- `LocationZone` (Phase 2) - Geofencing polygons

**Key Endpoints:**
```
GET    /api/v1/routes/fixed/                    # List fixed routes
POST   /api/v1/routes/fixed/                    # Create fixed route (admin)
GET    /api/v1/routes/fixed/{id}/               # Route detail
PUT    /api/v1/routes/fixed/{id}/               # Update route (admin)
DELETE /api/v1/routes/fixed/{id}/               # Delete route (admin)
POST   /api/v1/routes/match/                    # Match user coordinates to fixed route
POST   /api/v1/routes/calculate-distance/       # Calculate driving distance
GET    /api/v1/routes/distance-rules/           # Distance pricing rules
```

**Key Files:**
```python
# models.py
class FixedRoute(TimeStampedModel):
    route_name = models.CharField(max_length=255)
    pickup_address = models.CharField(max_length=500)
    pickup_lat = models.DecimalField(max_digits=10, decimal_places=8)
    pickup_lng = models.DecimalField(max_digits=11, decimal_places=8)
    pickup_radius_km = models.DecimalField(max_digits=5, decimal_places=2)
    # ... dropoff fields
    base_price = models.DecimalField(max_digits=10, decimal_places=2)
    distance_km = models.DecimalField(max_digits=10, decimal_places=2)
    is_active = models.BooleanField(default=True)

# services.py
class RouteMatchingService:
    @staticmethod
    def find_matching_route(pickup_coords, dropoff_coords):
        # Haversine distance calculation
        # Return matching FixedRoute or None
        
class DistanceCalculator:
    @staticmethod
    def calculate_driving_distance(origin, destination):
        # Google Distance Matrix API
        # Return distance in km
```

---

### 4. **apps/vehicles** - Vehicle management

**Purpose:** Vehicle classes, capacity requirements, availability

**Models:**
- `VehicleClass` - Economy, Business, Minivan, etc.
- `VehicleClassRequirement` - Min passenger/luggage requirements
- `Vehicle` (Phase 2) - Actual fleet management

**Key Endpoints:**
```
GET    /api/v1/vehicles/classes/                # List all vehicle classes
GET    /api/v1/vehicles/classes/{id}/           # Vehicle class detail
POST   /api/v1/vehicles/available/              # Get available vehicles for booking
POST   /api/v1/vehicles/validate-selection/     # Validate vehicle class for pax/luggage
```

**Key Files:**
```python
# models.py
class VehicleClass(TimeStampedModel):
    class_name = models.CharField(max_length=100)
    class_code = models.CharField(max_length=50, unique=True)
    tier_level = models.IntegerField()  # 1-7
    price_multiplier = models.DecimalField(max_digits=5, decimal_places=2)
    max_passengers = models.IntegerField()
    max_large_luggage = models.IntegerField()
    is_active = models.BooleanField(default=True)
    display_order = models.IntegerField()

class VehicleClassRequirement(models.Model):
    min_passengers = models.IntegerField()
    max_passengers = models.IntegerField()
    min_vehicle_tier = models.IntegerField()
    
# services.py
class VehicleSelectionService:
    @staticmethod
    def get_available_vehicles(num_passengers, num_luggage):
        # Return list of suitable VehicleClass objects
        # Mark minimum required tier
```

---

### 5. **apps/pricing** - Pricing engine

**Purpose:** Price calculation, multipliers, extra fees

**Models:**
- `SeasonalMultiplier` - Season-based pricing
- `PassengerMultiplier` - Group size pricing
- `TimeMultiplier` - Time-of-day pricing
- `ExtraFee` - Additional services (child seats, etc.)

**Key Endpoints:**
```
POST   /api/v1/pricing/calculate/               # Calculate price for booking
GET    /api/v1/pricing/seasonal/                # List seasonal multipliers
GET    /api/v1/pricing/passenger/               # List passenger multipliers
GET    /api/v1/pricing/time/                    # List time multipliers
GET    /api/v1/pricing/extra-fees/              # List extra fees
```

**Key Files:**
```python
# calculator.py (MAIN LOGIC)
class PriceCalculator:
    def calculate(self, booking_data):
        """
        Main price calculation algorithm
        Returns: {
            'pricing_type': 'fixed_route' | 'distance_based',
            'base_price': Decimal,
            'seasonal_multiplier': Decimal,
            'vehicle_class_multiplier': Decimal,
            'passenger_multiplier': Decimal,
            'time_multiplier': Decimal,
            'subtotal': Decimal,
            'extra_fees': [...],
            'extra_fees_total': Decimal,
            'final_price': Decimal,
            'breakdown': [...]
        }
        """
        
# models.py
class SeasonalMultiplier(TimeStampedModel):
    season_name = models.CharField(max_length=100)
    start_date = models.DateField()
    end_date = models.DateField()
    multiplier = models.DecimalField(max_digits=5, decimal_places=2)
    is_active = models.BooleanField(default=True)
    year_recurring = models.BooleanField(default=True)
```

---

### 6. **apps/bookings** - Booking management

**Purpose:** Create, manage, track bookings

**Models:**
- `Booking` - Main booking model (all fields from schema v2.1)
- `BookingStatusHistory` - Track status changes
- `BookingExtraFee` - Many-to-many for applied fees

**Key Endpoints:**
```
POST   /api/v1/bookings/                        # Create booking
GET    /api/v1/bookings/                        # List bookings (admin/user)
GET    /api/v1/bookings/{reference}/            # Booking detail
PUT    /api/v1/bookings/{reference}/            # Update booking
DELETE /api/v1/bookings/{reference}/            # Cancel booking
POST   /api/v1/bookings/{reference}/confirm/    # Confirm booking
GET    /api/v1/bookings/{reference}/receipt/    # Download receipt PDF
```

**Key Files:**
```python
# models.py
class Booking(TimeStampedModel):
    booking_reference = models.CharField(max_length=50, unique=True)
    # All fields from database schema v2.1
    status = models.CharField(max_length=20, choices=STATUS_CHOICES)
    
    def generate_reference(self):
        # Generate unique ref like "SAT-2026-001234"
        
# services.py
class BookingService:
    @staticmethod
    def create_booking(data):
        # Validate, calculate price, create booking
        # Send confirmation email
        # Return booking object
        
# signals.py
@receiver(post_save, sender=Booking)
def send_confirmation_email(sender, instance, created, **kwargs):
    if created:
        EmailService.send_booking_confirmation(instance)
```

---

### 7. **apps/payments** - Payment processing (Phase 2)

**Purpose:** Stripe & PayPal integration

**Models:**
- `Payment` - Payment records
- `Transaction` - Payment transactions

**Key Endpoints:**
```
POST   /api/v1/payments/create-intent/          # Create Stripe PaymentIntent
POST   /api/v1/payments/confirm/                # Confirm payment
POST   /api/v1/payments/refund/                 # Process refund
GET    /api/v1/payments/{id}/                   # Payment status
```

---

### 8. **apps/notifications** - Notifications

**Purpose:** Email, SMS notifications

**Models:**
- `EmailTemplate` - Customizable email templates
- `NotificationLog` - Track sent notifications

**Key Services:**
```python
# services.py
class EmailService:
    @staticmethod
    def send_booking_confirmation(booking):
        # Send confirmation email in customer's language
        
    @staticmethod
    def send_reminder(booking):
        # Send 24h reminder
```

---

## 🔌 API DESIGN

### Base URL
```
Development:  http://localhost:8000/api/v1/
Production:   https://api.sardiniaairporttransfer.com/api/v1/
```

### Authentication
```
JWT Tokens (Bearer authentication)
Header: Authorization: Bearer <token>
```

### API Versioning
- URL-based: `/api/v1/`, `/api/v2/`
- Backwards compatible for at least 6 months

### Response Format
```json
{
  "success": true,
  "data": { ... },
  "message": "Success",
  "errors": null
}
```

### Error Handling
```json
{
  "success": false,
  "data": null,
  "message": "Validation error",
  "errors": {
    "email": ["This field is required."]
  }
}
```

### Full API Specification
See: `docs/architecture/api_design.md` (to be created)

---

## 🗄️ DATABASE APPROACH

Following **qr-move** pattern:

```
database/
├── migrations/            # Manual SQL migrations (if needed beyond Django)
├── seeds/                # Initial data (SQL or Django fixtures)
│   ├── 01_vehicle_classes.sql
│   ├── 02_seasonal_multipliers.sql
│   └── 03_fixed_routes_sardinia.sql
├── backups/              # Automated backups
└── init.sql             # Initial setup script
```

**Django migrations** handle schema changes automatically.  
**Seeds** provide initial production data (vehicle classes, Marco's routes, etc.)

---

## 📅 DEVELOPMENT ROADMAP

### **SPRINT 1: Foundation Setup** (Week 1-2)

**Goals:** Project skeleton, basic models, authentication

**Backend:**
- [ ] Django project setup with folder structure
- [ ] PostgreSQL connection
- [ ] apps/core: TimeStampedModel, utils
- [ ] apps/accounts: User model, JWT auth
- [ ] Basic admin panel customization
- [ ] Docker setup (PostgreSQL, Redis)

**Frontend:**
- [ ] Flutter Web project setup
- [ ] Routing structure
- [ ] API client with interceptors
- [ ] Basic UI theme (Material Design 3)

**Database:**
- [ ] Initial migrations
- [ ] Seed data for development

**Deliverable:** Working auth system (login/register), basic project structure

---

### **SPRINT 2: Core Models & Pricing Engine** (Week 3-4)

**Goals:** Implement pricing logic, routes, vehicles

**Backend:**
- [ ] apps/routes: FixedRoute, DistancePricingRule models
- [ ] apps/vehicles: VehicleClass, VehicleClassRequirement models
- [ ] apps/pricing: All multiplier models, PriceCalculator
- [ ] Route matching service (Haversine)
- [ ] Google Maps Distance Matrix API integration
- [ ] Price calculation endpoint with full breakdown

**Frontend:**
- [ ] Location autocomplete widget (Google Places)
- [ ] Date/Time picker widgets
- [ ] Passenger/luggage counter

**Testing:**
- [ ] Unit tests for PriceCalculator
- [ ] Integration tests for route matching

**Deliverable:** Working price calculation API

---

### **SPRINT 3: Booking System** (Week 5-6)

**Goals:** Complete booking flow (without payment)

**Backend:**
- [ ] apps/bookings: Booking model with all fields
- [ ] Create booking endpoint
- [ ] List/detail/cancel endpoints
- [ ] Email notification system
- [ ] Booking reference generation
- [ ] Admin panel for booking management

**Frontend:**
- [ ] Multi-step booking form
- [ ] Vehicle selection screen
- [ ] Price breakdown display
- [ ] Booking summary & confirmation
- [ ] Booking history (user view)

**Deliverable:** End-to-end booking flow (no payment)

---

### **SPRINT 4: Admin Panel & Management** (Week 7-8)

**Goals:** Admin tools for Marco

**Backend:**
- [ ] Custom admin views for routes
- [ ] Pricing rules management UI
- [ ] Booking dashboard with filters
- [ ] Reports API (revenue, popular routes)
- [ ] CSV export for bookings

**Frontend:**
- [ ] Admin dashboard (Flutter Web)
- [ ] Routes management screen
- [ ] Pricing configuration screen
- [ ] Bookings list with search/filters
- [ ] Analytics charts

**Deliverable:** Complete admin system

---

### **SPRINT 5: Multi-Language & Polish** (Week 9)

**Goals:** Internationalization, testing, refinement

**Backend:**
- [ ] Django i18n setup (EN, IT, DE, FR, AR)
- [ ] Translated error messages
- [ ] Email templates in multiple languages

**Frontend:**
- [ ] Flutter localization (EN, IT, DE, FR, AR with RTL support)
- [ ] Language switcher
- [ ] All UI text translated

**Testing:**
- [ ] E2E tests (Selenium/Playwright)
- [ ] Load testing
- [ ] Security audit

**Deliverable:** Production-ready MVP

---

### **SPRINT 6: Deployment** (Week 10)

**Goals:** Deploy to Infomaniak, go live

- [ ] Infomaniak server setup
- [ ] Domain configuration
- [ ] SSL certificates
- [ ] Nginx configuration
- [ ] Environment variables setup
- [ ] Database migration to production
- [ ] Seed production data (Marco's routes)
- [ ] Monitoring setup (Sentry for errors)
- [ ] Backup automation
- [ ] Final testing on production

**Deliverable:** Live system at production URL

---

### **PHASE 2: Post-MVP** (Weeks 11+)

**Mobile Apps (Flutter iOS/Android):**
- [ ] iOS app from shared codebase
- [ ] Android app from shared codebase

**Payment Integration:**
- [ ] Stripe integration
- [ ] PayPal integration
- [ ] Refund functionality

**Advanced Features:**
- [ ] SMS notifications (Twilio)
- [ ] Driver assignment (if needed)
- [ ] Real-time booking updates (WebSockets)
- [ ] Customer rating system
- [ ] Promo codes / discounts
- [ ] Polygon geomatching for zones

---

### **PHASE 3: Mobile Release** (Future)

**App Store Deployment:**
- [ ] Push notifications (Firebase Cloud Messaging)
- [ ] App Store deployment (iOS)
- [ ] Google Play deployment (Android)
- [ ] App review & approval process

---

## 🚀 DEPLOYMENT STRATEGY

### Target Platform: **Infomaniak**

**Server Requirements:**
- **OS:** Ubuntu 22.04 LTS
- **CPU:** 2 vCPU minimum
- **RAM:** 4 GB minimum
- **Storage:** 50 GB SSD

### Architecture

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  Infomaniak Cloud Server (Ubuntu 22.04)        │
│                                                 │
│  ┌────────────┐  ┌──────────────┐             │
│  │   Nginx    │  │  PostgreSQL  │             │
│  │ (Port 80)  │  │  (Port 5432) │             │
│  └─────┬──────┘  └──────────────┘             │
│        │                                       │
│  ┌─────▼──────┐  ┌──────────────┐             │
│  │  Gunicorn  │  │    Redis     │             │
│  │  (Django)  │  │  (Cache)     │             │
│  └────────────┘  └──────────────┘             │
│                                                 │
│  ┌─────────────────────────────┐               │
│  │   Flutter Web (Static)      │               │
│  │   Served by Nginx           │               │
│  └─────────────────────────────┘               │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Deployment Process

**1. Initial Server Setup:**
```bash
# SSH into Infomaniak server
ssh user@server-ip

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install python3.12 python3-pip postgresql nginx redis-server git -y

# Install Docker (optional, for containerized deployment)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

**2. Database Setup:**
```bash
# Create PostgreSQL database
sudo -u postgres createdb transfer_booking
sudo -u postgres createuser transfer_user -P
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE transfer_booking TO transfer_user;"
```

**3. Django Deployment:**
```bash
# Clone repository
git clone https://github.com/your-repo/transfer-booking-module.git
cd transfer-booking-module/backend

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements/production.txt

# Environment variables
cp .env.example .env
nano .env  # Configure production settings

# Run migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput

# Load seed data
python manage.py loaddata database/seeds/vehicle_classes.json
python manage.py loaddata database/seeds/seasonal_multipliers.json
```

**4. Gunicorn Setup:**
```bash
# Create systemd service
sudo nano /etc/systemd/system/transfer-booking.service

# Start service
sudo systemctl start transfer-booking
sudo systemctl enable transfer-booking
```

**5. Nginx Configuration:**
```nginx
server {
    listen 80;
    server_name sardiniaairporttransfer.com;
    
    location /api/ {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    location / {
        root /var/www/transfer-booking/frontend/build/web;
        try_files $uri /index.html;
    }
    
    location /static/ {
        alias /var/www/transfer-booking/backend/staticfiles/;
    }
}
```

**6. SSL Certificate (Let's Encrypt):**
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d sardiniaairporttransfer.com
```

**7. Automated Backups:**
```bash
# Create backup script (deploy/scripts/backup.sh)
# Setup cron job
crontab -e
# Add: 0 2 * * * /path/to/backup.sh
```

### Monitoring & Maintenance

**Error Tracking:**
- Sentry integration for real-time error reporting

**Logging:**
- Django logs → `/var/log/transfer-booking/`
- Nginx logs → `/var/log/nginx/`

**Performance Monitoring:**
- Django Debug Toolbar (dev only)
- New Relic or similar (production)

**Backups:**
- Daily PostgreSQL backups
- Weekly full server backups
- Off-site backup storage

---

## 🔐 SECURITY CHECKLIST

- [ ] SECRET_KEY in environment variable (not in code)
- [ ] DEBUG=False in production
- [ ] ALLOWED_HOSTS configured
- [ ] HTTPS/SSL enabled
- [ ] CSRF protection enabled
- [ ] SQL injection prevention (Django ORM)
- [ ] XSS prevention (Django templates auto-escape)
- [ ] Rate limiting on API endpoints
- [ ] Strong password validation
- [ ] JWT token expiration
- [ ] CORS properly configured
- [ ] Database credentials secured
- [ ] API keys in .env (Google Maps, Stripe)
- [ ] Regular security updates

---

## 📊 SUCCESS METRICS

**Development Phase:**
- [ ] All unit tests passing (>90% coverage)
- [ ] API response time <200ms (95th percentile)
- [ ] Zero critical security vulnerabilities

**Launch Phase:**
- [ ] Successfully process 10 test bookings
- [ ] Marco can manage routes/pricing independently
- [ ] Email notifications working in all 4 languages
- [ ] Mobile-responsive on all devices

**Post-Launch:**
- [ ] 99.9% uptime
- [ ] <1s page load time
- [ ] User satisfaction: Marco's feedback
- [ ] Booking conversion rate tracking

---

## 📚 NEXT STEPS

1. **Review & Approve Architecture** - Maksym reviews this document
2. **Initialize Git Repository** - Create repo, setup branches
3. **Setup Development Environment** - Django + PostgreSQL + Flutter
4. **Sprint 1 Kickoff** - Start coding!

---

**Questions? Ready to start coding?** 🚀

# Transfer Pricing System - Database Schema
**Project:** Sardinia Airport Transfer - Custom WordPress Plugin  
**Client:** Marco Cutolo  
**Date:** January 15, 2026  
**Version:** 1.0

---

## 🎯 System Overview

Hybrid pricing approach combining:
1. **Fixed Routes** - Pre-defined popular routes with set prices
2. **Distance-Based** - Dynamic calculation for non-standard routes
3. **Dynamic Multipliers** - Season, passengers, time of day adjustments

---

## 📊 Database Tables

### 1️⃣ FIXED_ROUTES (Популярные маршруты с фиксированной ценой)

**Purpose:** Store frequently requested routes with fixed base prices and geolocation matching

```sql
Table: fixed_routes
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
route_name          | VARCHAR(255)           -- "Cagliari Airport → Olbia"

-- Pickup Location (with geomatching)
pickup_address      | VARCHAR(500)           -- "Cagliari Elmas Airport (CAG)"
pickup_lat          | DECIMAL(10,8)          -- 39.25146900
pickup_lng          | DECIMAL(11,8)          -- 9.05438300
pickup_type         | ENUM('airport', 'city_center', 'hotel_zone', 'resort', 'exact_address')
pickup_radius_km    | DECIMAL(5,2)           -- 5.00 (tolerance for matching)
pickup_zone_polygon | GEOMETRY               -- Optional: for advanced polygon matching

-- Dropoff Location (with geomatching)
dropoff_address     | VARCHAR(500)           -- "Villasimius Town Center"
dropoff_lat         | DECIMAL(10,8)          -- 39.13700000
dropoff_lng         | DECIMAL(11,8)          -- 9.51200000
dropoff_type        | ENUM('airport', 'city_center', 'hotel_zone', 'resort', 'exact_address')
dropoff_radius_km   | DECIMAL(5,2)           -- 2.00
dropoff_zone_polygon| GEOMETRY               -- Optional

-- Pricing & Metadata
base_price          | DECIMAL(10,2)          -- €250.00
currency            | VARCHAR(3)             -- EUR
distance_km         | DECIMAL(10,2)          -- Pre-calculated distance (for reference)
is_active           | BOOLEAN                -- true/false
notes               | TEXT                   -- Internal notes for admin
created_at          | TIMESTAMP
updated_at          | TIMESTAMP
```

**Geolocation Matching Logic:**
- When user enters address → system gets lat/lng via Google Places API
- System checks if user coordinates are within `pickup_radius_km` and `dropoff_radius_km`
- If BOTH match → use fixed route pricing
- If NO match → fallback to distance-based pricing

**Recommended Radius Values:**
```
Airport:       5 km  (covers terminals, parking, cargo areas)
City Center:   2 km  (main downtown area)
Hotel Zone:    3 km  (resort/hotel clusters)
Resort:        5 km  (large resort complexes like Costa Smeralda)
Exact Address: 0.5 km (specific venues)
```

**Example Data:**
```json
{
  "route_name": "Cagliari Airport → Costa Smeralda",
  "pickup_address": "Cagliari Elmas Airport (CAG)",
  "pickup_lat": 39.251469,
  "pickup_lng": 9.054383,
  "pickup_type": "airport",
  "pickup_radius_km": 5.00,
  "dropoff_address": "Porto Cervo, Costa Smeralda",
  "dropoff_lat": 41.138000,
  "dropoff_lng": 9.535000,
  "dropoff_type": "resort",
  "dropoff_radius_km": 5.00,
  "base_price": 450.00,
  "distance_km": 305.5
}
```

**Typical Routes for Sardinia:**
```
Cagliari Airport → Cagliari City Center:  €35   (10 km)
Cagliari Airport → Villasimius:           €80   (55 km)
Cagliari Airport → Costa Smeralda:        €450  (305 km)
Olbia Airport → Porto Cervo:              €65   (30 km)
Olbia Airport → Palau (ferry):            €55   (40 km)
Alghero Airport → Alghero City:           €25   (10 km)
Alghero Airport → Stintino:               €75   (55 km)
```

---

### 2️⃣ DISTANCE_PRICING_RULES (Правила для distance-based расчета)

**Purpose:** Define pricing tiers based on distance ranges

```sql
Table: distance_pricing_rules
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
rule_name           | VARCHAR(255)           -- "Standard Sardinia Pricing"
base_rate           | DECIMAL(10,2)          -- €50.00 (минимум за поездку)
price_per_km        | DECIMAL(10,2)          -- €1.50
price_per_minute    | DECIMAL(10,2)          -- €0.50 (опционально, для traffic)
min_distance_km     | INT                    -- 0
max_distance_km     | INT                    -- 9999 (или NULL для unlimited)
is_active           | BOOLEAN
priority            | INT                    -- для сортировки правил (lower = higher priority)
created_at          | TIMESTAMP
updated_at          | TIMESTAMP
```

**Example Pricing Tiers:**
```
Priority 1: Short trips (0-30km)     → Base €40 + €2.00/km
Priority 2: Medium trips (30-100km)  → Base €50 + €1.50/km
Priority 3: Long trips (100-200km)   → Base €60 + €1.20/km
Priority 4: Extra long (200+km)      → Base €80 + €1.00/km
```

**Note:** System selects the rule where `distance_km BETWEEN min_distance_km AND max_distance_km` with lowest priority number.

---

### 3️⃣ SEASONAL_MULTIPLIERS (Сезонные коэффициенты)

**Purpose:** Apply seasonal pricing adjustments

```sql
Table: seasonal_multipliers
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
season_name         | VARCHAR(100)           -- "High Summer Season"
start_date          | DATE                   -- 2026-06-15 (или MM-DD для ежегодного)
end_date            | DATE                   -- 2026-09-15
multiplier          | DECIMAL(5,2)           -- 1.30 (130% от базовой цены)
is_active           | BOOLEAN
year_recurring      | BOOLEAN                -- true = повторяется каждый год
priority            | INT                    -- если overlap сезонов (lower = higher)
description         | TEXT                   -- "Peak tourist season in Sardinia"
created_at          | TIMESTAMP
updated_at          | TIMESTAMP
```

**Sardinia Seasonal Strategy:**
```
High Summer (June 15 - Sept 15)         → 1.30  (peak tourist season)
Shoulder Season (Apr 1 - June 14)       → 1.15  (good weather, fewer tourists)
Shoulder Season (Sept 16 - Oct 31)      → 1.15  
Low Season (Nov 1 - March 31)           → 1.00  (base pricing)
Christmas/New Year (Dec 20 - Jan 5)     → 1.25  (holiday premium)
Easter Week (varies yearly)             → 1.20  (spring break)
Ferragosto (Aug 10-20)                  → 1.40  (Italian holiday peak)
```

**Overlap Handling:** If multiple seasons overlap (e.g., Ferragosto within High Summer), system uses the one with higher multiplier OR lower priority number.

---

### 4️⃣ VEHICLE_CLASSES (Классы автомобилей)

**Purpose:** Allow customers to SELECT their preferred vehicle class with pricing multipliers

**Important:** Customers choose their vehicle class, not the system. Upgrade allowed ✅ / Downgrade forbidden ❌

```sql
Table: vehicle_classes
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
class_name          | VARCHAR(100)           -- "Economy Sedan"
class_code          | VARCHAR(50)            -- "economy_sedan"
tier_level          | INT                    -- 1, 2, 3, 4, 5, 6, 7 (для upgrade/downgrade logic)
price_multiplier    | DECIMAL(5,2)           -- 1.00, 1.30, 1.80, 2.50
max_passengers      | INT                    -- 4
max_large_luggage   | INT                    -- 2
max_small_luggage   | INT                    -- 2
description         | TEXT                   -- "Comfortable sedan for up to 4 passengers"
example_vehicles    | VARCHAR(255)           -- "VW Passat, Toyota Camry, Ford Mondeo"
is_active           | BOOLEAN
display_order       | INT                    -- Order in booking form
icon_url            | VARCHAR(255)           -- URL to vehicle icon/image
created_at          | TIMESTAMP
updated_at          | TIMESTAMP
```

**Standard Vehicle Classes for Sardinia Transfer:**
```
Tier 1: Economy Sedan
  - Multiplier: 1.00 (base price)
  - Capacity: 4 passengers, 2 large + 2 small luggage
  - Examples: VW Passat, Ford Mondeo, Skoda Superb

Tier 2: Business Sedan  
  - Multiplier: 1.30 (+30%)
  - Capacity: 4 passengers, 3 large + 2 small luggage
  - Examples: Mercedes E-Class, BMW 5 Series, Audi A6

Tier 3: Luxury Sedan
  - Multiplier: 1.80 (+80%)
  - Capacity: 3 passengers, 2 large + 2 small luggage (premium comfort)
  - Examples: Mercedes S-Class, BMW 7 Series, Tesla Model S

Tier 4: Minivan / MPV
  - Multiplier: 1.40 (+40%)
  - Capacity: 7 passengers, 5 large + 4 small luggage
  - Examples: Mercedes V-Class, VW Multivan, Ford Transit Custom

Tier 5: Luxury Minivan
  - Multiplier: 2.20 (+120%)
  - Capacity: 7 passengers, 5 large + 4 small luggage (VIP)
  - Examples: Mercedes V-Class VIP, VW Multivan Premium

Tier 6: Minibus
  - Multiplier: 2.50 (+150%)
  - Capacity: 16 passengers, 12 large luggage
  - Examples: Mercedes Sprinter, Ford Transit

Tier 7: Large Minibus
  - Multiplier: 3.50 (+250%)
  - Capacity: 25 passengers, 20 large luggage
  - Examples: Mercedes Sprinter Extended, Iveco Daily
```

**Business Rules:**
- Customer SELECTS vehicle class in booking form
- Upgrade ✅ allowed (2 pax can book Minivan, pay +40%)
- Downgrade ❌ forbidden (5 pax CANNOT book Sedan)
- Driver can deliver HIGHER class (free upgrade) but never LOWER

---

### 4️⃣.1 VEHICLE_CLASS_REQUIREMENTS (Минимальные требования)

**Purpose:** Define minimum vehicle tier based on passengers/luggage

```sql
Table: vehicle_class_requirements
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
min_passengers      | INT                    -- 5
max_passengers      | INT                    -- 7
min_vehicle_tier    | INT                    -- 4 (Minivan required)
required_for        | ENUM('passengers', 'luggage', 'both')
is_strict           | BOOLEAN                -- true = cannot downgrade
validation_message  | VARCHAR(255)           -- "5-7 passengers require a Minivan or larger"
created_at          | TIMESTAMP
```

**Standard Requirements:**
```
Passenger-based:
  1-4 passengers   → Min Tier 1 (Economy Sedan OK)
  5-7 passengers   → Min Tier 4 (Minivan REQUIRED)
  8-16 passengers  → Min Tier 6 (Minibus REQUIRED)
  17-25 passengers → Min Tier 7 (Large Minibus REQUIRED)

Luggage-based:
  Large bags ≤ 2   → Min Tier 1 OK
  Large bags 3-5   → Min Tier 4 (Minivan for space)
  Large bags 6-12  → Min Tier 6 (Minibus)
  Large bags 13+   → Min Tier 7
```

**Validation Logic:** System takes the HIGHEST requirement (passengers OR luggage) as minimum tier.

---

### 4️⃣.2 PASSENGER_MULTIPLIERS (Множитель по количеству пассажиров)

**Purpose:** Apply additional pricing based on total number of passengers (independent of vehicle class)

**Business Logic:** More passengers = more coordination, luggage handling, fuel consumption

```sql
Table: passenger_multipliers
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
min_passengers      | INT                    -- 1
max_passengers      | INT                    -- 3
multiplier          | DECIMAL(5,2)           -- 1.00
description         | VARCHAR(255)           -- "Small group - base rate"
is_active           | BOOLEAN
display_order       | INT
created_at          | TIMESTAMP
```

**Standard Configuration:**
```
1-3 passengers    → 1.00 (Small group - base rate)
4-6 passengers    → 1.10 (Medium group - coordination, luggage)
7-10 passengers   → 1.15 (Large group)
11-16 passengers  → 1.20 (Very large group)
17-25 passengers  → 1.25 (Extra large group)
26+ passengers    → 1.30 (Requires multiple vehicles or custom quote)
```

**Important Notes:**
- This multiplier is SEPARATE from vehicle class multiplier
- Both multipliers are applied: `Price = Base × Vehicle_Class × Passenger_Count × Season × Time`
- **Example:** 7 passengers in Luxury Minivan = base × 1.40 (vehicle) × 1.15 (passengers) × season × time

**Why both multipliers?**
- **Vehicle Class:** Premium vehicle quality (Business vs Economy)
- **Passenger Count:** Operational complexity (1 person vs 7 people)
- **Real scenario:** 2 passengers in Minivan (×1.40 × 1.00) vs 7 passengers in Minivan (×1.40 × 1.15)

---

### 5️⃣ TIME_OF_DAY_MULTIPLIERS (Время суток - опционально)

**Purpose:** Premium pricing for inconvenient hours

```sql
Table: time_multipliers
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
time_name           | VARCHAR(100)           -- "Night Transfer"
start_time          | TIME                   -- 22:00:00
end_time            | TIME                   -- 06:00:00
multiplier          | DECIMAL(5,2)           -- 1.20
applies_to_weekends | BOOLEAN                -- false
applies_to_weekdays | BOOLEAN                -- true
is_active           | BOOLEAN
description         | TEXT
```

**Suggested Time Pricing:**
```
Late Night (22:00-06:00)           → 1.20  (driver availability)
Early Morning (04:00-06:00)        → 1.25  (early airport runs)
Standard Hours (06:00-22:00)       → 1.00  (no adjustment)
```

**Optional - Peak Hours for City Routes:**
```
Morning Rush (07:00-09:30, Mon-Fri) → 1.10
Evening Rush (17:00-19:30, Mon-Fri) → 1.10
```

---

### 6️⃣ EXTRA_FEES (Дополнительные сборы)

**Purpose:** One-time or per-item charges for special services

```sql
Table: extra_fees
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
fee_name            | VARCHAR(100)           -- "Extra Large Luggage"
fee_type            | ENUM('per_item', 'flat', 'percentage')
amount              | DECIMAL(10,2)          -- €15.00
applies_when        | TEXT                   -- JSON условие или описание
is_optional         | BOOLEAN                -- User can opt-in/out
is_active           | BOOLEAN
display_order       | INT                    -- Order in booking form
description         | TEXT                   -- Shown to customer
created_at          | TIMESTAMP
```

**Common Extra Fees:**
```
Child Seat (0-4 years)      → €10 flat (optional)
Booster Seat (4-12 years)   → €5 flat (optional)
Extra Large Luggage         → €15 per item (bags >30kg)
Surfboard/Bike Transport    → €25 per item
Pet Transport (small)       → €20 flat
Pet Transport (large)       → €35 flat
Meet & Greet Premium        → €20 flat (if not included)
Waiting Time                → €30 per hour (after free 15 min)
Additional Stop             → €15 per stop
```

**Note:** Some fees like "Meet & Greet" might be included by default for airport transfers.

---

### 7️⃣ BOOKINGS (Основная таблица бронирований)

**Purpose:** Store all booking data and pricing calculations

```sql
Table: bookings
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
booking_reference   | VARCHAR(50) UNIQUE     -- "SAT-2026-001234"

-- Route Information
pickup_address      | VARCHAR(500)           -- Full address as entered
pickup_lat          | DECIMAL(10,8)          -- From Google Places API
pickup_lng          | DECIMAL(11,8)
pickup_notes        | TEXT                   -- "Terminal 1, Gate 5"
dropoff_address     | VARCHAR(500)
dropoff_lat         | DECIMAL(10,8)
dropoff_lng         | DECIMAL(11,8)
dropoff_notes       | TEXT
service_date        | DATE
pickup_time         | TIME

-- Passenger & Luggage Details
num_passengers      | INT
num_large_luggage   | INT                    -- Standard suitcases
num_small_luggage   | INT                    -- Carry-on / backpacks
has_children        | BOOLEAN
children_ages       | TEXT                   -- JSON array [3, 7]

-- Vehicle Selection (NEW!)
selected_vehicle_class_id | INT              -- FK to vehicle_classes (what customer SELECTED)
actual_vehicle_class_id   | INT              -- FK to vehicle_classes (what was actually DELIVERED, may be upgrade)
vehicle_upgrade_reason    | TEXT             -- "Original vehicle unavailable, upgraded to Business Sedan"

-- Flight & Special Info
flight_number       | VARCHAR(20)            -- "FR4523" (optional)
special_requests    | TEXT                   -- Customer notes

-- Pricing Breakdown
pricing_type        | ENUM('fixed_route', 'distance_based')
fixed_route_id      | INT                    -- FK to fixed_routes (if applicable)
distance_km         | DECIMAL(10,2)          -- Calculated or pre-set
duration_minutes    | INT                    -- Estimated travel time
base_price          | DECIMAL(10,2)          -- €250.00 (before any multipliers)

-- Multipliers Applied
seasonal_multiplier | DECIMAL(5,2)           -- 1.30 (High Summer)
vehicle_class_multiplier | DECIMAL(5,2)      -- 1.40 (Minivan)
passenger_multiplier | DECIMAL(5,2)          -- 1.10 (4-6 passengers)
time_multiplier     | DECIMAL(5,2)           -- 1.00 (Standard hours)

-- Price Calculation
subtotal            | DECIMAL(10,2)          -- After all multipliers
extra_fees_json     | TEXT                   -- JSON array of applied fees
extra_fees_total    | DECIMAL(10,2)          -- €15.00
final_price         | DECIMAL(10,2)          -- €359.50
currency            | VARCHAR(3)             -- EUR

-- Customer Information
customer_name       | VARCHAR(255)
customer_phone      | VARCHAR(30)
customer_email      | VARCHAR(255)

-- Status & Payment
status              | ENUM('pending', 'confirmed', 'in_progress', 'completed', 'cancelled')
payment_status      | ENUM('unpaid', 'deposit_paid', 'fully_paid', 'refunded')
payment_method      | VARCHAR(50)            -- "stripe", "paypal", "cash"
payment_intent_id   | VARCHAR(255)           -- Stripe Payment Intent ID

-- Internal Management (Optional)
driver_id           | INT                    -- FK to drivers table (if fleet management enabled)
vehicle_id          | INT                    -- FK to vehicles table (if tracking specific cars)
internal_notes      | TEXT                   -- Admin-only notes
assigned_at         | TIMESTAMP              -- When driver was assigned
created_at          | TIMESTAMP
updated_at          | TIMESTAMP
confirmed_at        | TIMESTAMP
completed_at        | TIMESTAMP
```

**Example Booking Record:**
```json
{
  "booking_reference": "SAT-2026-001234",
  "pickup_address": "Cagliari Elmas Airport, Terminal Arrivals",
  "pickup_lat": 39.251469,
  "pickup_lng": 9.054383,
  "service_date": "2026-07-15",
  "pickup_time": "14:30:00",
  "num_passengers": 5,
  "num_large_luggage": 4,
  
  "selected_vehicle_class_id": 4,    // Customer selected Minivan
  "actual_vehicle_class_id": 5,      // Driver delivered Luxury Minivan (free upgrade)
  "vehicle_upgrade_reason": "Minivan unavailable, upgraded to VIP at no charge",
  
  "pricing_type": "fixed_route",
  "fixed_route_id": 12,
  "base_price": 250.00,
  "seasonal_multiplier": 1.30,       // High Summer
  "vehicle_class_multiplier": 1.40,  // Minivan
  "passenger_multiplier": 1.10,      // 4-6 passengers (medium group)
  "time_multiplier": 1.00,           // Standard hours
  "subtotal": 500.50,                // €250 × 1.30 × 1.40 × 1.10 × 1.00
  "extra_fees_total": 10.00,         // Child seat
  "final_price": 510.50
}
```

**Important Changes from v1.0:**
- ✅ ADDED: `selected_vehicle_class_id` - what customer chose
- ✅ ADDED: `actual_vehicle_class_id` - what was delivered (tracking upgrades)
- ✅ ADDED: `vehicle_class_multiplier` - pricing for vehicle class
- ✅ RETAINED: `passenger_multiplier` - pricing for passenger count
- 💡 Both vehicle class AND passenger multipliers are now applied

---

## 🧮 PRICING CALCULATION ALGORITHM

### Step-by-Step Price Calculation Logic

```javascript
function calculatePrice(booking) {
  let calculation = {
    pricing_type: null,
    base_price: 0,
    distance_km: 0,
    seasonal_multiplier: 1.00,
    vehicle_class_multiplier: 1.00,
    passenger_multiplier: 1.00,         // ← ADDED BACK!
    time_multiplier: 1.00,
    subtotal: 0,
    extra_fees: [],
    extra_fees_total: 0,
    final_price: 0,
    breakdown: []
  };
  
  // ============================================
  // STEP 1: Determine if Fixed Route or Distance-Based
  // ============================================
  const fixedRoute = findMatchingFixedRoute(
    booking.pickup_coordinates, 
    booking.dropoff_coordinates
  );
  
  if (fixedRoute && fixedRoute.is_active) {
    // Fixed Route Pricing
    calculation.pricing_type = 'fixed_route';
    calculation.base_price = fixedRoute.base_price;
    calculation.distance_km = fixedRoute.distance_km;
    calculation.breakdown.push(`Fixed Route: ${fixedRoute.route_name} = €${fixedRoute.base_price}`);
  } else {
    // Distance-Based Pricing
    calculation.pricing_type = 'distance_based';
    
    // Calculate distance using Google Distance Matrix API
    calculation.distance_km = calculateDistance(
      booking.pickup_coordinates, 
      booking.dropoff_coordinates
    );
    
    // Find applicable distance rule
    const distanceRule = findApplicableDistanceRule(calculation.distance_km);
    
    calculation.base_price = distanceRule.base_rate + 
                            (calculation.distance_km * distanceRule.price_per_km);
    
    calculation.breakdown.push(
      `Distance-Based: €${distanceRule.base_rate} + (${calculation.distance_km}km × €${distanceRule.price_per_km}) = €${calculation.base_price.toFixed(2)}`
    );
  }
  
  // ============================================
  // STEP 2: Vehicle Class Validation & Selection
  // ============================================
  const selectedClass = getVehicleClass(booking.selected_vehicle_class_id);
  const minRequiredTier = getMinimumVehicleTier(
    booking.num_passengers, 
    booking.num_large_luggage
  );
  
  // CRITICAL VALIDATION: Can this vehicle class handle the booking?
  if (selectedClass.tier_level < minRequiredTier.tier_level) {
    throw new ValidationError(
      `Vehicle class "${selectedClass.class_name}" cannot accommodate ${booking.num_passengers} passengers and ${booking.num_large_luggage} bags. ` +
      `Minimum required: ${minRequiredTier.class_name} (Tier ${minRequiredTier.tier_level})`
    );
  }
  
  // Apply vehicle class multiplier
  calculation.vehicle_class_multiplier = selectedClass.price_multiplier;
  calculation.breakdown.push(
    `Vehicle: ${selectedClass.class_name} (Tier ${selectedClass.tier_level}) ×${selectedClass.price_multiplier}`
  );
  
  // Note if customer is upgrading voluntarily
  if (selectedClass.tier_level > minRequiredTier.tier_level) {
    calculation.breakdown.push(
      `  ℹ️  Voluntary upgrade from ${minRequiredTier.class_name}`
    );
  }
  
  // ============================================
  // STEP 3: Apply Passenger Multiplier
  // ============================================
  const passengerMultiplier = getPassengerMultiplier(booking.num_passengers);
  calculation.passenger_multiplier = passengerMultiplier.multiplier;
  
  if (passengerMultiplier.multiplier != 1.00) {
    calculation.breakdown.push(
      `Passengers: ${booking.num_passengers} pax (${passengerMultiplier.description}) ×${passengerMultiplier.multiplier}`
    );
  }
  
  // ============================================
  // STEP 4: Apply Seasonal Multiplier
  // ============================================
  // ============================================
  // STEP 4: Apply Seasonal Multiplier
  // ============================================
  const seasonMultiplier = getSeasonalMultiplier(booking.service_date);
  calculation.seasonal_multiplier = seasonMultiplier.multiplier;
  
  if (seasonMultiplier.multiplier != 1.00) {
    calculation.breakdown.push(
      `Season: ${seasonMultiplier.season_name} ×${seasonMultiplier.multiplier}`
    );
  }
  
  // ============================================
  // STEP 5: Apply Time Multiplier
  // ============================================
  const timeMultiplier = getTimeMultiplier(booking.pickup_time, booking.service_date);
  calculation.time_multiplier = timeMultiplier.multiplier;
  
  if (timeMultiplier.multiplier != 1.00) {
    calculation.breakdown.push(
      `Time: ${timeMultiplier.time_name} ×${timeMultiplier.multiplier}`
    );
  }
  
  // ============================================
  // STEP 6: Calculate Subtotal
  // ============================================
  calculation.subtotal = calculation.base_price * 
                        calculation.seasonal_multiplier * 
                        calculation.vehicle_class_multiplier *
                        calculation.passenger_multiplier *    // ← ADDED BACK!
                        calculation.time_multiplier;
  
  calculation.breakdown.push(`Subtotal: €${calculation.subtotal.toFixed(2)}`);
  
  // ============================================
  // STEP 7: Add Extra Fees
  // ============================================
  // ============================================
  // STEP 7: Add Extra Fees
  // ============================================
  calculation.extra_fees = calculateExtraFees(booking);
  calculation.extra_fees_total = calculation.extra_fees.reduce(
    (sum, fee) => sum + fee.amount, 0
  );
  
  if (calculation.extra_fees.length > 0) {
    calculation.breakdown.push('Extra Fees:');
    calculation.extra_fees.forEach(fee => {
      calculation.breakdown.push(`  + ${fee.name}: €${fee.amount.toFixed(2)}`);
    });
  }
  
  // ============================================
  // STEP 8: Calculate Final Price
  // ============================================
  calculation.final_price = calculation.subtotal + calculation.extra_fees_total;
  
  // Round to 2 decimals (or nearest €1 if desired)
  calculation.final_price = Math.round(calculation.final_price * 100) / 100;
  
  calculation.breakdown.push(`═══════════════════════════`);
  calculation.breakdown.push(`FINAL PRICE: €${calculation.final_price.toFixed(2)}`);
  
  return calculation;
}

// ============================================
// Helper Functions
// ============================================

function findMatchingFixedRoute(pickup_coords, dropoff_coords) {
  // Using Haversine formula to calculate distance between coordinates
  // Check database for routes where BOTH pickup and dropoff are within radius
  
  const query = `
    SELECT 
      *,
      (6371 * acos(
        cos(radians(?)) * cos(radians(pickup_lat)) * 
        cos(radians(pickup_lng) - radians(?)) + 
        sin(radians(?)) * sin(radians(pickup_lat))
      )) AS pickup_distance_km,
      (6371 * acos(
        cos(radians(?)) * cos(radians(dropoff_lat)) * 
        cos(radians(dropoff_lng) - radians(?)) + 
        sin(radians(?)) * sin(radians(dropoff_lat))
      )) AS dropoff_distance_km
    FROM fixed_routes
    WHERE is_active = 1
    HAVING 
      pickup_distance_km <= pickup_radius_km AND
      dropoff_distance_km <= dropoff_radius_km
    ORDER BY 
      (pickup_distance_km + dropoff_distance_km) ASC
    LIMIT 1
  `;
  
  // Execute query with pickup_coords.lat, pickup_coords.lng, dropoff_coords.lat, dropoff_coords.lng
  // Returns matched route or null
}

function calculateDistance(pickup_coords, dropoff_coords) {
  // Use Google Distance Matrix API
  // Returns actual driving distance in kilometers
  // Example: https://maps.googleapis.com/maps/api/distancematrix/json?origins=39.251,9.054&destinations=39.137,9.512
}

function findApplicableDistanceRule(distance_km) {
  // Query distance_pricing_rules WHERE distance_km BETWEEN min_distance_km AND max_distance_km
  // ORDER BY priority ASC
  // Return first matching rule
}

function getVehicleClass(vehicle_class_id) {
  // Query vehicle_classes WHERE id = vehicle_class_id AND is_active = 1
  // Returns {id, class_name, tier_level, price_multiplier, max_passengers, ...}
}

function getMinimumVehicleTier(num_passengers, num_large_luggage) {
  // Check vehicle_class_requirements for minimum tier based on:
  // 1. Passenger count
  // 2. Luggage count
  // Return the HIGHER of the two requirements
  
  const passengerReq = getPassengerRequirement(num_passengers);
  const luggageReq = getLuggageRequirement(num_large_luggage);
  
  const minTier = Math.max(passengerReq.min_tier, luggageReq.min_tier);
  
  // Get the vehicle class at this tier level
  const minClass = getVehicleClassByTier(minTier);
  
  return minClass;
}

function getSeasonalMultiplier(service_date) {
  // Query seasonal_multipliers WHERE service_date BETWEEN start_date AND end_date
  // If multiple matches (overlap), return highest multiplier OR lowest priority
  // Return {season_name, multiplier} or {season_name: "Standard", multiplier: 1.00}
}

function getPassengerMultiplier(num_passengers) {
  // Query passenger_multipliers WHERE num_passengers BETWEEN min_passengers AND max_passengers
  // Return {multiplier, description}
  // Example: 7 passengers → {multiplier: 1.15, description: "Large group"}
}

function getTimeMultiplier(pickup_time, service_date) {
  // Query time_multipliers WHERE pickup_time BETWEEN start_time AND end_time
  // Check weekday/weekend logic
  // Return {time_name, multiplier} or {time_name: "Standard", multiplier: 1.00}
}

function calculateExtraFees(booking) {
  // Analyze booking details and apply relevant extra fees
  // Examples:
  // - if has_children && any child age < 4 → suggest child seat (€10)
  // - if num_large_luggage > standard for vehicle → extra luggage fee
  // Return array of {fee_id, name, amount, is_optional}
}
```

---

### Example Calculations

**Scenario 1: 3 passengers, Economy Sedan selected**
```javascript
Input:
- Route: Cagliari Airport → Villasimius (fixed route)
- Passengers: 3
- Vehicle: Economy Sedan (Tier 1, ×1.00)
- Date: July 15, 2026 (High Summer ×1.30)
- Time: 14:30 (Standard ×1.00)

Calculation:
Base Price:    €80.00  (fixed route)
× Vehicle:     1.00    (Economy Sedan)
× Passengers:  1.00    (1-3 pax - small group)
× Season:      1.30    (High Summer)
× Time:        1.00    (Standard)
─────────────────────
Subtotal:      €104.00
+ Extra Fees:  €0.00
═════════════════════
FINAL:         €104.00
```

**Scenario 2: 3 passengers, Business Sedan selected (voluntary upgrade)**
```javascript
Input:
- Route: Same as above
- Passengers: 3 (Economy OK, but customer wants Business)
- Vehicle: Business Sedan (Tier 2, ×1.30)
- Other: Same

Calculation:
Base Price:    €80.00
× Vehicle:     1.30    (Business Sedan - UPGRADE)
× Passengers:  1.00    (1-3 pax - small group)
× Season:      1.30    (High Summer)
× Time:        1.00
─────────────────────
Subtotal:      €135.20
+ Extra Fees:  €0.00
═════════════════════
FINAL:         €135.20

Customer pays €31.20 more for upgraded vehicle class.
```

**Scenario 3: 6 passengers, Minivan REQUIRED**
```javascript
Input:
- Route: Cagliari Airport → Costa Smeralda (distance-based, 305km)
- Passengers: 6
- Vehicle: Minivan (Tier 4, ×1.40) ← MINIMUM for 6 pax
- Date: March 10, 2026 (Low Season ×1.00)
- Time: 22:30 (Night ×1.20)
- Distance Rule: €60 base + €1.20/km for 200+km trips

Calculation:
Base Price:    €60 + (305 × €1.20) = €426.00
× Vehicle:     1.40    (Minivan - REQUIRED)
× Passengers:  1.10    (4-6 pax - medium group)
× Season:      1.00    (Low Season)
× Time:        1.20    (Night transfer)
─────────────────────
Subtotal:      €787.25
+ Extra Fees:  €10.00  (1× child seat)
═════════════════════
FINAL:         €797.25

Note: Customer CANNOT select Economy/Business - those options are DISABLED in UI.
```

**Scenario 4: 6 passengers, Luxury Minivan selected (voluntary upgrade)**
```javascript
Input:
- Same as Scenario 3, but customer chooses Luxury Minivan
- Vehicle: Luxury Minivan (Tier 5, ×2.20)

Calculation:
Base Price:    €426.00
× Vehicle:     2.20    (Luxury Minivan - UPGRADE from required Tier 4)
× Passengers:  1.10    (4-6 pax - medium group)
× Season:      1.00
× Time:        1.20
─────────────────────
Subtotal:      €1,237.23
+ Extra Fees:  €10.00
═════════════════════
FINAL:         €1,247.23

Customer pays €449.98 more for luxury upgrade (€1,247.23 - €797.25).
```

**Scenario 5: 2 passengers in Minivan (voluntary upgrade) vs 7 passengers in Minivan**
```javascript
CASE A: 2 passengers, Minivan (voluntary upgrade from Economy)
Base Price:    €80.00
× Vehicle:     1.40    (Minivan - customer chose upgrade)
× Passengers:  1.00    (1-3 pax - small group)
× Season:      1.30    (High Summer)
× Time:        1.00
─────────────────────
FINAL:         €145.60

CASE B: 7 passengers, Minivan (required minimum)
Base Price:    €80.00
× Vehicle:     1.40    (Minivan - required for 7 pax)
× Passengers:  1.15    (7-10 pax - large group) ← DIFFERENCE!
× Season:      1.30    (High Summer)
× Time:        1.00
─────────────────────
FINAL:         €167.44

Same vehicle class, but €21.84 more for 7 passengers due to group complexity.
This shows why BOTH multipliers are needed!
```

---

## 🎨 BOOKING FORM - Vehicle Selection UI

### User Experience Flow

**Step 1: User enters route and details**
```
Pickup:     [Cagliari Airport ▼]
Dropoff:    [Villasimius      ▼]
Date:       [July 15, 2026    📅]
Time:       [14:30            🕐]
Passengers: [5                ⬆️⬇️]
Large Bags: [4                ⬆️⬇️]
```

**Step 2: System shows available vehicle classes**

```html
<div class="vehicle-selection">
  <h3>Select Your Vehicle</h3>
  <p class="info">Based on 5 passengers and 4 large bags</p>
  
  <div class="vehicle-grid">
    
    <!-- UNAVAILABLE: Too small -->
    <div class="vehicle-card disabled">
      <div class="overlay">
        <span class="icon">❌</span>
        <p>Insufficient capacity</p>
      </div>
      <img src="/vehicles/sedan-economy.png" class="greyed" />
      <h4>Economy Sedan</h4>
      <p class="capacity">Up to 4 passengers • 2 large bags</p>
      <p class="examples">VW Passat, Toyota Camry</p>
      <div class="price disabled">
        <span class="amount">Not available</span>
      </div>
    </div>
    
    <!-- AVAILABLE BUT NOT RECOMMENDED: Luggage issue -->
    <div class="vehicle-card warning">
      <div class="badge warning">⚠️ Limited Space</div>
      <img src="/vehicles/sedan-business.png" />
      <h4>Business Sedan</h4>
      <p class="capacity">Up to 4 passengers • 3 large bags</p>
      <p class="examples">Mercedes E-Class, BMW 5 Series</p>
      <div class="price">
        <span class="amount">€104</span>
        <span class="multiplier">+30%</span>
      </div>
      <p class="warning-text">⚠️ May not fit all luggage comfortably</p>
      <button class="select-btn warning">Select Anyway</button>
    </div>
    
    <!-- MINIMUM REQUIRED -->
    <div class="vehicle-card recommended">
      <div class="badge recommended">✓ RECOMMENDED</div>
      <img src="/vehicles/minivan.png" />
      <h4>Minivan</h4>
      <p class="capacity">Up to 7 passengers • 5 large bags</p>
      <p class="examples">Mercedes V-Class, VW Multivan</p>
      <div class="price recommended">
        <span class="amount">€112</span>
        <span class="multiplier">+40%</span>
      </div>
      <p class="info-text">✓ Perfect fit for your group</p>
      <button class="select-btn primary">Select</button>
    </div>
    
    <!-- UPGRADE OPTION -->
    <div class="vehicle-card upgrade">
      <div class="badge upgrade">⭐ PREMIUM UPGRADE</div>
      <img src="/vehicles/minivan-luxury.png" />
      <h4>Luxury Minivan</h4>
      <p class="capacity">Up to 7 passengers • 5 large bags</p>
      <p class="examples">Mercedes V-Class VIP Edition</p>
      <div class="price upgrade">
        <span class="amount">€176</span>
        <span class="multiplier">+120%</span>
      </div>
      <p class="upgrade-text">Premium comfort & amenities</p>
      <button class="select-btn upgrade">Upgrade</button>
    </div>
    
  </div>
  
  <div class="price-breakdown">
    <h4>Price Breakdown (Minivan)</h4>
    <table>
      <tr>
        <td>Base Route Price</td>
        <td>€80.00</td>
      </tr>
      <tr>
        <td>Vehicle: Minivan (×1.40)</td>
        <td>€112.00</td>
      </tr>
      <tr>
        <td>Season: High Summer (×1.30)</td>
        <td>€145.60</td>
      </tr>
      <tr class="total">
        <td><strong>TOTAL</strong></td>
        <td><strong>€145.60</strong></td>
      </tr>
    </table>
  </div>
  
</div>
```

### CSS Styling Guidelines

```css
.vehicle-card.disabled {
  opacity: 0.4;
  pointer-events: none;
  filter: grayscale(100%);
}

.vehicle-card.recommended {
  border: 3px solid #4CAF50;
  box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
  position: relative;
}

.vehicle-card.upgrade {
  border: 2px solid #FFD700;
}

.badge.recommended {
  background: #4CAF50;
  color: white;
  padding: 6px 12px;
  border-radius: 4px;
  font-weight: bold;
  position: absolute;
  top: 12px;
  right: 12px;
}

.badge.upgrade {
  background: linear-gradient(135deg, #FFD700, #FFA500);
  color: #333;
}

.select-btn.primary {
  background: #4CAF50;
  color: white;
  font-size: 16px;
  padding: 12px 24px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}

.select-btn.upgrade {
  background: linear-gradient(135deg, #FFD700, #FFA500);
  color: #333;
}
```

### JavaScript Validation

```javascript
function validateVehicleSelection(passengers, luggage, selectedClassId) {
  // Get minimum required tier
  const minTier = getMinimumTier(passengers, luggage);
  
  // Get selected vehicle class
  const selectedClass = getVehicleClass(selectedClassId);
  
  // Validate
  if (selectedClass.tier_level < minTier.tier_level) {
    showError(
      `This vehicle cannot accommodate ${passengers} passengers and ${luggage} bags. ` +
      `Please select ${minTier.class_name} or higher.`
    );
    return false;
  }
  
  // If upgrade, confirm
  if (selectedClass.tier_level > minTier.tier_level) {
    const extraCost = calculateUpgradeCost(minTier, selectedClass);
    showConfirmation(
      `You're upgrading to ${selectedClass.class_name} for an additional €${extraCost.toFixed(2)}. ` +
      `Continue?`
    );
  }
  
  return true;
}
```

---

## 📋 ADMIN PANEL - Required Features

### Dashboard Sections

#### 1. **Vehicle Classes Management**

```
════════════════════════════════════════════════════════════════════
VEHICLE CLASSES CONFIGURATION
════════════════════════════════════════════════════════════════════

┌──────────────────────────────────────────────────────────────────────────┐
│ Class Name       │ Tier │ Multiplier │ Capacity          │ Status │ Edit │
├──────────────────────────────────────────────────────────────────────────┤
│ Economy Sedan    │  1   │  1.00      │ 4 pax, 2 lg bags │ ✅     │ ✏️   │
│ Business Sedan   │  2   │  1.30      │ 4 pax, 3 lg bags │ ✅     │ ✏️   │
│ Luxury Sedan     │  3   │  1.80      │ 3 pax, 2 lg bags │ ✅     │ ✏️   │
│ Minivan          │  4   │  1.40      │ 7 pax, 5 lg bags │ ✅     │ ✏️   │
│ Luxury Minivan   │  5   │  2.20      │ 7 pax, 5 lg bags │ ✅     │ ✏️   │
│ Minibus          │  6   │  2.50      │ 16 pax, 12 bags  │ ✅     │ ✏️   │
│ Large Minibus    │  7   │  3.50      │ 25 pax, 20 bags  │ ✅     │ ✏️   │
└──────────────────────────────────────────────────────────────────────────┘

[+ Add New Vehicle Class]  [⚙️ Configure Requirements]  [💾 Save All]

════════════════════════════════════════════════════════════════════
CAPACITY REQUIREMENTS
════════════════════════════════════════════════════════════════════

Passenger-Based Requirements:
┌─────────────────────────────────────────────────────────┐
│ Passengers  │ Minimum Tier │ Minimum Class Name        │
├─────────────────────────────────────────────────────────┤
│ 1-4         │ Tier 1       │ Economy Sedan             │
│ 5-7         │ Tier 4       │ Minivan                   │
│ 8-16        │ Tier 6       │ Minibus                   │
│ 17-25       │ Tier 7       │ Large Minibus             │
└─────────────────────────────────────────────────────────┘

Luggage-Based Requirements:
┌─────────────────────────────────────────────────────────┐
│ Large Bags  │ Minimum Tier │ Minimum Class Name        │
├─────────────────────────────────────────────────────────┤
│ 0-2         │ Tier 1       │ Economy Sedan             │
│ 3-5         │ Tier 4       │ Minivan                   │
│ 6-12        │ Tier 6       │ Minibus                   │
│ 13+         │ Tier 7       │ Large Minibus             │
└─────────────────────────────────────────────────────────┘

[Edit Requirements]
```

#### 2. **Fixed Routes Management**

```
════════════════════════════════════════════════════════════════════
FIXED ROUTES
════════════════════════════════════════════════════════════════════

[+ Add New Route]  [Import from CSV]  [Export]

┌────────────────────────────────────────────────────────────────────────┐
│ Route Name                    │ Price  │ Distance │ Status │ Actions   │
├────────────────────────────────────────────────────────────────────────┤
│ Cagliari Airport → Villasimius│ €80    │ 55 km    │ ✅     │ ✏️ 🗑️ 📋 │
│ Cagliari Airport → Costa Smer.│ €450   │ 305 km   │ ✅     │ ✏️ 🗑️ 📋 │
│ Olbia Airport → Porto Cervo   │ €65    │ 30 km    │ ✅     │ ✏️ 🗑️ 📋 │
│ Olbia Airport → Palau         │ €55    │ 40 km    │ ✅     │ ✏️ 🗑️ 📋 │
└────────────────────────────────────────────────────────────────────────┘

════════════════════════════════════════════════════════════════════
EDIT ROUTE: Cagliari Airport → Villasimius
════════════════════════════════════════════════════════════════════

Route Name: [Cagliari Airport → Villasimius        ]

PICKUP LOCATION
Address:    [Cagliari Elmas Airport (CAG)          ] [📍 Get Coords]
Latitude:   [39.251469  ]
Longitude:  [9.054383   ]
Type:       [Airport ▼]
Match Radius: [5.0] km

DROPOFF LOCATION  
Address:    [Villasimius Town Center               ] [📍 Get Coords]
Latitude:   [39.137000  ]
Longitude:  [9.512000   ]
Type:       [City Center ▼]
Match Radius: [2.0] km

PRICING
Base Price: [€80.00]
Currency:   [EUR]

[🧮 Calculate Distance] Distance: 55.3 km (auto-calculated)

[💾 Save Route]  [❌ Cancel]
```

**"Get Coords" Button Logic:**
- Uses Google Geocoding API
- Auto-fills lat/lng fields
- Marco doesn't manually enter coordinates

#### 3. **Distance Pricing Rules**

Visual table of distance tiers with quick edit

#### 4. **Multipliers Dashboard**

**Seasonal Calendar View:**
- Visual calendar showing active seasons
- Color-coded by multiplier level
- Click to edit season dates/multipliers
- Duplicate season for next year

**Time Multipliers:**
- Simple table view
- Quick edit multiplier values
- Enable/disable specific rules

#### 5. **Extra Fees Configuration**

- List of all extra fees
- Add/Edit/Delete fees
- Set optional vs mandatory
- Configure display order in booking form

#### 6. **Bookings Management**

```
════════════════════════════════════════════════════════════════════
BOOKINGS
════════════════════════════════════════════════════════════════════

Filters: 
[Date: This Month ▼] [Status: All ▼] [Vehicle: All ▼] [Search: ___________]

┌────────────────────────────────────────────────────────────────────────────┐
│ Ref      │Date      │Route           │Pax│Vehicle      │Price │Status     │
├────────────────────────────────────────────────────────────────────────────┤
│SAT-00123│2026-07-15│CAG→Villasimius │ 5 │Minivan      │€145  │✅Confirmed│
│SAT-00124│2026-07-16│OLB→Porto Cervo │ 3 │Business     │€107  │⏳Pending  │
│SAT-00125│2026-07-16│CAG→Costa Smer. │ 8 │Minibus      │€892  │✅Confirmed│
└────────────────────────────────────────────────────────────────────────────┘

[Export to CSV]

════════════════════════════════════════════════════════════════════
BOOKING DETAILS: SAT-00123
════════════════════════════════════════════════════════════════════

ROUTE INFORMATION
Pickup:     Cagliari Elmas Airport, Terminal 1
            📍 39.251469, 9.054383
            Date: July 15, 2026 at 14:30

Dropoff:    Villasimius, Via Roma 45
            📍 39.137000, 9.512000

PASSENGERS & VEHICLE
Passengers:        5 adults
Large Luggage:     4 bags
Small Luggage:     2 bags
Children:          1 child (age 3)

Selected Vehicle:  Minivan (Tier 4)
Actual Vehicle:    Minivan (same)

PRICING BREAKDOWN
─────────────────────────────────────────
Base Price (Fixed Route):      €80.00
× Vehicle Class (Minivan):     ×1.40
× Season (High Summer):        ×1.30
× Time (Standard):             ×1.00
─────────────────────────────────────────
Subtotal:                      €145.60
+ Child Seat:                  €10.00
═════════════════════════════════════════
TOTAL:                         €155.60

CUSTOMER
Name:   Marco Rossi
Email:  marco.rossi@email.it
Phone:  +39 333 123 4567
Flight: FR4523

STATUS
Booking Status:  ✅ Confirmed
Payment Status:  💳 Fully Paid (Stripe)
Driver Assigned: Giovanni B. (ID: 42)

[📧 Email Customer] [📱 SMS Customer] [✏️ Edit] [❌ Cancel Booking]
```

#### 7. **Reports & Analytics**

- Revenue by route (top performing routes)
- Revenue by season
- Revenue by vehicle class
- Average booking value
- Popular routes (most bookings)
- Conversion rate (quote views vs bookings)
- Customer repeat rate
- Vehicle class distribution

---

## 💡 ADDITIONAL FEATURES & TABLES (Optional)

### Route Zones (Geofencing)

```sql
Table: route_zones
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
zone_name           | VARCHAR(100)           -- "Olbia Airport Pickup Zone"
zone_polygon        | GEOMETRY               -- GIS polygon data
zone_type           | ENUM('pickup', 'dropoff', 'both')
price_adjustment    | DECIMAL(5,2)           -- 1.15 (15% increase)
fee_type            | ENUM('multiplier', 'flat_fee')
flat_fee_amount     | DECIMAL(10,2)          -- €10 (if fee_type = flat)
is_active           | BOOLEAN
```

**Use Cases:**
- Airport pickup zones: +€10 flat fee for parking
- City center zones: +15% for traffic/restricted access
- Resort areas: Premium pricing

### Promo Codes / Discount System

```sql
Table: promo_codes
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
code                | VARCHAR(50) UNIQUE     -- "SUMMER2026"
discount_type       | ENUM('percentage', 'fixed_amount')
discount_value      | DECIMAL(10,2)          -- 10.00 (10% or €10)
min_order_value     | DECIMAL(10,2)          -- €100 minimum booking
max_discount        | DECIMAL(10,2)          -- €50 max discount cap
valid_from          | DATETIME
valid_until         | DATETIME
max_uses            | INT                    -- NULL = unlimited
times_used          | INT DEFAULT 0
applies_to_routes   | TEXT                   -- JSON array of route IDs (optional)
is_active           | BOOLEAN
created_at          | TIMESTAMP
```

### Customer Database (for repeat customers)

```sql
Table: customers
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
email               | VARCHAR(255) UNIQUE
phone               | VARCHAR(30)
first_name          | VARCHAR(100)
last_name           | VARCHAR(100)
total_bookings      | INT DEFAULT 0
total_spent         | DECIMAL(10,2) DEFAULT 0
loyalty_tier        | ENUM('standard', 'silver', 'gold') -- For future loyalty program
notes               | TEXT
created_at          | TIMESTAMP
last_booking_at     | TIMESTAMP
```

### Drivers & Vehicles (if managing fleet)

```sql
Table: drivers
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
full_name           | VARCHAR(255)
phone               | VARCHAR(30)
email               | VARCHAR(255)
license_number      | VARCHAR(50)
is_active           | BOOLEAN
rating_avg          | DECIMAL(3,2)           -- 4.85
total_trips         | INT
```

```sql
Table: vehicles
-----------------------------------------
id                  | INT (PK, AUTO_INCREMENT)
vehicle_type        | VARCHAR(50)            -- "sedan", "minivan"
make_model          | VARCHAR(100)           -- "Mercedes E-Class"
license_plate       | VARCHAR(20)
passenger_capacity  | INT
luggage_capacity    | INT
is_active           | BOOLEAN
```

---

## 🔄 Future Enhancements

### Phase 2 Features
- [ ] Multi-language support (IT, EN, DE, FR)
- [ ] SMS notifications (Twilio integration)
- [ ] Driver mobile app
- [ ] Customer rating system
- [ ] Dynamic pricing based on demand (surge pricing)
- [ ] Integration with accounting software (QuickBooks/Xero)
- [ ] Affiliate system for hotels/tour operators
- [ ] API for third-party integrations

### Phase 3 Features
- [ ] AI-powered route optimization
- [ ] Real-time driver tracking
- [ ] In-app chat with driver
- [ ] Carbon offset calculation
- [ ] Corporate account management
- [ ] Subscription/package deals

---

## 📝 Notes & Decisions Log

**MAJOR CHANGES in v2.0:**
- ✅ **Vehicle class selection:** Customers now SELECT their vehicle class (not auto-assigned)
- ✅ **Geolocation matching:** Fixed routes use lat/lng + radius instead of text matching
- ✅ **Upgrade/downgrade rules:** Explicit tier-based validation
- ✅ **Dual multipliers:** BOTH vehicle_class_multiplier AND passenger_multiplier are applied

---

**Decision 1: Fixed Route Matching - Geolocation Approach**
- **Question:** How to match user-entered address with fixed routes?
- **Answer:** Use latitude/longitude coordinates + radius tolerance
- **Implementation:** 
  - Google Places Autocomplete provides lat/lng
  - Haversine formula calculates distance
  - Match if BOTH pickup and dropoff within radius
- **Tolerance Radius:**
  - Airport: 5 km
  - City Center: 2 km
  - Hotel Zone: 3 km
  - Resort: 5 km
  - Exact Address: 0.5 km

**Decision 2: Vehicle Class Selection vs Auto-Assignment**
- **Question:** Should system auto-select vehicle based on passengers, or let customer choose?
- **Answer:** Customer CHOOSES vehicle class (with validation)
- **Reasoning:** 
  - Better UX - customers have control
  - Enables premium upgrades (revenue opportunity)
  - Clear pricing transparency
- **Rules:**
  - Minimum tier enforced (5 pax = must select Minivan+)
  - Upgrades allowed and encouraged
  - Downgrades blocked with clear error messages

**Decision 3: Using BOTH Vehicle Class and Passenger Multipliers**
- **Question:** Should price depend only on vehicle class, or also on passenger count?
- **Answer:** Use BOTH multipliers
- **Formula:** `Price = Base × Vehicle_Class × Passenger_Count × Season × Time`
- **Reasoning:** 
  - **Vehicle Class:** Accounts for vehicle quality/premium (Economy vs Luxury)
  - **Passenger Count:** Accounts for operational complexity (1 pax vs 7 pax)
  - **Real example:** 2 pax in Minivan (×1.40 × 1.00) vs 7 pax in Minivan (×1.40 × 1.15)
  - More passengers = more luggage handling, coordination, fuel consumption
- **Industry practice:** Most premium transfer services charge more for larger groups

**Decision 4: Multiplier Application Order**
**Decision 4: Multiplier Application Order**
- Base Price × Vehicle Class × Passenger Count × Season × Time = Subtotal
- Extra fees added to subtotal (not multiplied)
- **Reason:** Extra fees like child seats are fixed costs, not variable

**Decision 5: Rounding Strategy**
- **Options Considered:**
  - Round to nearest €1
  - Round to nearest €5 (psychological pricing)
  - Exact to cents
- **Recommendation:** Round to nearest €0.05 (standard European pricing)
- **Example:** €145.63 → €145.65

**Decision 6: Tier Numbering System**
- Lower tier number = lower price
- Tier 1 (Economy) → Tier 7 (Large Minibus)
- Consistent with "upgrade" concept (higher tier = upgrade)

**Decision 7: Vehicle Delivery - Upgrade Policy**
**Decision 7: Vehicle Delivery - Upgrade Policy**
- Driver CAN deliver higher class (free upgrade to customer)
- Driver CANNOT deliver lower class (contract breach)
- Track both `selected_vehicle_class_id` and `actual_vehicle_class_id`
- **Use case:** Minivan booked but broken → deliver Luxury Minivan free

**Decision 8: Geofencing (Optional Future Feature)**
- For MVP: Use simple radius matching
- For v2.0+: Implement polygon-based zones for complex areas
- **Use case:** Large airports with multiple terminals, resorts with spread-out properties

---

**Question for Marco:**

1. **Seasonal Pricing Granularity:**
   - Should fixed routes have custom seasonal multipliers?
   - OR should all routes use the same global seasonal multipliers?
   - **Recommendation:** Global multipliers for simplicity (MVP)

2. **Vehicle Class Display:**
   - Show ALL classes (with disabled ones greyed out)?
   - OR hide unavailable classes entirely?
   - **Recommendation:** Show all but grey out unavailable (helps upselling)

3. **Price Breakdown Visibility:**
   - Show detailed breakdown to customer before booking?
   - OR just show final price with "See breakdown" link?
   - **Recommendation:** Show simple breakdown (transparency builds trust)

4. **Distance Calculation:**
   - Use straight-line distance (cheaper, less accurate)?
   - OR use Google Distance Matrix API (accurate driving distance, costs ~$5-10/1000 requests)?
   - **Recommendation:** Google API (accuracy worth the cost)

5. **Minimum Booking Restrictions:**
   - Prevent bookings >30 days in advance?
   - Prevent bookings <2 hours before pickup?
   - **Recommendation:** Max 180 days advance, min 3 hours notice

---

## 🚀 Implementation Priority

### MVP (Minimum Viable Product)
1. Fixed Routes table + management
2. Distance Pricing Rules (single tier to start)
3. Seasonal Multipliers
4. Passenger Multipliers
5. Basic booking form + calculation
6. Admin dashboard for routes & bookings

### Phase 1.5
1. Time multipliers
2. Extra fees system
3. Promo codes
4. Enhanced admin reports

### Phase 2
1. Customer database
2. Email notifications
3. Payment integration (Stripe/PayPal)
4. Multi-language

---

**Last Updated:** January 15, 2026  
**Status:** Draft v2.1 - Ready for Marco's Review  
**Major Changes:**
- Added vehicle class selection with tier-based validation
- Implemented geolocation matching for fixed routes
- Using BOTH vehicle_class_multiplier AND passenger_multiplier (dual multipliers)
- Added comprehensive UI/UX specifications
- Expanded admin panel functionality

**Pricing Formula:**
```
Final Price = (Base × Vehicle_Class × Passenger_Count × Season × Time) + Extra_Fees
```

**Next Steps:**
1. Review with Marco Cutolo
2. Gather answers to open questions
3. Finalize technical specifications
4. Begin development planning

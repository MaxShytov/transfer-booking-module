# Transfer Pricing System - Business Logic Overview
**For:** Sardinia Airport Transfer (Marco Cutolo)  
**Prepared by:** Trident Software Sàrl  
**Date:** January 15, 2026

---

## 🎯 System Overview

Based on your requirements, we propose a **hybrid pricing system** that combines:

1. ✅ **Fixed Routes** - Pre-defined prices for popular routes
2. ✅ **Dynamic Calculation** - Distance-based pricing for all other routes
3. ✅ **Real-time Price Display** - Instant pricing as user enters booking details
4. ✅ **Flexible Pricing Rules** - Seasonal rates, vehicle classes, time-based adjustments

This approach is similar to Connecto Transfers but with **full control over your pricing logic**.

---

## 💰 Pricing Formula

```
FINAL PRICE = (Base Route Price 
              × Vehicle Class 
              × Passenger Count 
              × Season 
              × Time of Day) 
              + Extra Services
```

### Step-by-Step Calculation

**Example: Cagliari Airport → Villasimius**

```
1. Base Route Price:        €80.00
   (Your pre-defined price for this popular route)

2. × Vehicle Class:         1.40
   Customer selected: Minivan
   (Economy 1.0, Business 1.3, Minivan 1.4, Luxury 2.2, etc.)

3. × Passenger Count:       1.10
   6 passengers = medium group surcharge
   (1-3 pax: 1.0, 4-6 pax: 1.1, 7-10 pax: 1.15, etc.)

4. × Season:                1.30
   July 15 = High Summer
   (Low: 1.0, Shoulder: 1.15, High Summer: 1.3, Ferragosto: 1.4)

5. × Time of Day:           1.00
   14:30 = Standard hours
   (Night 22:00-06:00: 1.2, Standard: 1.0)
   
   ────────────────────────────
   Subtotal:                €145.60

6. + Extra Services:        €10.00
   1× Child seat
   
   ════════════════════════════
   FINAL PRICE:             €155.60
```

---

## 🛣️ Route Types

### 1. Fixed Routes (Popular Destinations)

You define the most common routes with set base prices:

```
Cagliari Airport → Cagliari City:     €35
Cagliari Airport → Villasimius:       €80
Cagliari Airport → Costa Smeralda:    €450
Olbia Airport → Porto Cervo:          €65
Olbia Airport → Palau:                €55
Alghero Airport → Alghero City:       €25
... (you control the full list)
```

**How matching works:**
- System uses GPS coordinates + radius tolerance
- Example: User enters "Cagliari Elmas Airport Terminal 1" → matches "Cagliari Airport" (within 5km radius)
- If BOTH pickup and dropoff match a fixed route → use that price
- Otherwise → calculate based on distance

### 2. Distance-Based Routes (Everything Else)

For routes not in your fixed list:

```
Price = Base Rate + (Distance × Rate per KM)

Examples:
- Short (0-30km):     €40 + (distance × €2.00/km)
- Medium (30-100km):  €50 + (distance × €1.50/km)
- Long (100-200km):   €60 + (distance × €1.20/km)
- Extra long (200+km): €80 + (distance × €1.00/km)
```

Distance calculated via **Google Maps API** (actual driving distance, not straight line).

---

## 🚗 Vehicle Classes

Customers **SELECT** their preferred vehicle class from available options:

| Class             | Multiplier | Capacity              | Examples                        |
|-------------------|------------|-----------------------|---------------------------------|
| Economy Sedan     | ×1.00      | 4 pax, 2 large bags  | VW Passat, Ford Mondeo          |
| Business Sedan    | ×1.30      | 4 pax, 3 large bags  | Mercedes E-Class, BMW 5 Series  |
| Luxury Sedan      | ×1.80      | 3 pax, 2 large bags  | Mercedes S-Class, BMW 7 Series  |
| Minivan           | ×1.40      | 7 pax, 5 large bags  | Mercedes V-Class, VW Multivan   |
| Luxury Minivan    | ×2.20      | 7 pax, 5 large bags  | Mercedes V-Class VIP            |
| Minibus           | ×2.50      | 16 pax, 12 bags      | Mercedes Sprinter               |
| Large Minibus     | ×3.50      | 25 pax, 20 bags      | Mercedes Sprinter Extended      |

**Important Rules:**
- ✅ **Upgrade allowed:** 2 passengers can book a Minivan (they pay the premium)
- ❌ **Downgrade forbidden:** 6 passengers CANNOT book Economy Sedan (system blocks it)
- System automatically shows which vehicles are available based on passenger/luggage count

---

## 👥 Passenger Count Pricing

More passengers = additional operational complexity:

| Passengers | Multiplier | Description      |
|------------|------------|------------------|
| 1-3        | ×1.00      | Small group      |
| 4-6        | ×1.10      | Medium group     |
| 7-10       | ×1.15      | Large group      |
| 11-16      | ×1.20      | Very large group |
| 17-25      | ×1.25      | Extra large      |

**Why separate from vehicle class?**
- Same Minivan: 2 passengers (×1.0) vs 7 passengers (×1.15)
- Accounts for luggage handling, coordination, fuel consumption

---

## 📅 Seasonal Pricing

Adjust prices based on demand periods:

```
High Summer (June 15 - Sept 15):        ×1.30
Shoulder Season (Apr-May, Sept-Oct):    ×1.15
Low Season (Nov-March):                 ×1.00
Christmas/New Year (Dec 20 - Jan 5):    ×1.25
Easter Week:                            ×1.20
Ferragosto (Aug 10-20):                 ×1.40  (peak Italian holiday)
```

You have full control to add/modify/remove seasons and set any multiplier.

---

## 🕐 Time-Based Pricing (Optional)

Premium for inconvenient hours:

```
Late Night (22:00-06:00):               ×1.20
Early Morning Airport Runs (04:00-06:00): ×1.25
Standard Hours (06:00-22:00):           ×1.00
```

Optional: Rush hour surcharges for city transfers.

---

## 💼 Extra Services

One-time or per-item fees:

```
Child Seat (0-4 years):        €10 per seat
Booster Seat (4-12 years):     €5 per seat
Extra Large Luggage (>30kg):   €15 per item
Surfboard/Bike Transport:      €25 per item
Pet Transport (small):         €20 flat
Pet Transport (large):         €35 flat
Additional Stop en route:      €15 per stop
Waiting Time (after 15 min):   €30 per hour
```

All configurable - you decide what to offer and at what price.

---

## 🎨 Customer Booking Flow

### What the customer sees:

**Step 1: Enter Details**
```
Pickup:    [Cagliari Airport        ▼] (autocomplete)
Dropoff:   [Villasimius             ▼] (autocomplete)
Date:      [July 15, 2026           📅]
Time:      [14:30                   🕐]
Passengers: [6                      ⬆️⬇️]
Large Bags: [4                      ⬆️⬇️]
```

**Step 2: Select Vehicle**

System shows available vehicles with instant pricing:

```
┌─────────────────────────────────────────┐
│ ❌ Economy Sedan                        │
│    Too small for 6 passengers           │
│    Not available                        │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ ✓ RECOMMENDED                           │
│ Minivan                                 │
│ Up to 7 passengers • 5 large bags       │
│ Mercedes V-Class, VW Multivan           │
│                                         │
│ €145.60                                 │
│ [Select This Vehicle]                   │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ ⭐ PREMIUM UPGRADE                      │
│ Luxury Minivan VIP                      │
│ Up to 7 passengers • 5 large bags       │
│ Mercedes V-Class VIP Edition            │
│                                         │
│ €228.80  (+€83.20)                      │
│ [Upgrade to VIP]                        │
└─────────────────────────────────────────┘
```

**Step 3: Add Extras (Optional)**
```
☐ Child Seat (€10)
☐ Extra Luggage (€15)
☐ Pet Transport (€20)
```

**Step 4: See Final Price & Book**
```
Price Breakdown:
────────────────────────
Base Route:         €80.00
Vehicle (Minivan):  ×1.40
Passengers (6):     ×1.10
Season (Summer):    ×1.30
Time (Standard):    ×1.00
────────────────────────
Subtotal:          €145.60
+ Child Seat:       €10.00
════════════════════════
TOTAL:             €155.60

[Proceed to Payment]
```

Customer sees **exact price BEFORE booking** - no surprises!

---

## 🎛️ Admin Panel - What You Control

### 1. Fixed Routes Management
- Add/edit popular routes with set prices
- Example: "Cagliari Airport → Villasimius = €80"
- GPS-based matching (no manual coordinate entry needed)

### 2. Distance Pricing Rules
- Set base rates and per-km pricing for different distance ranges
- Example: "100-200km trips = €60 base + €1.20/km"

### 3. Vehicle Classes
- Define available vehicles and multipliers
- Enable/disable specific classes
- Upload vehicle photos

### 4. Seasonal Calendar
- Visual calendar showing all seasons
- Click to edit dates and multipliers
- Duplicate seasons year-over-year

### 5. Passenger Pricing
- Set multipliers for different group sizes
- Quick adjustment table

### 6. Extra Services
- Add/remove services
- Set prices
- Mark as optional or required

### 7. Bookings Dashboard
- View all bookings with filters
- See detailed price breakdown for each booking
- Export to CSV/Excel
- Assign drivers (if using fleet management)

### 8. Reports & Analytics
- Revenue by route
- Most popular destinations
- Booking conversion rates
- Seasonal performance
- Vehicle class distribution

---

## 🔧 Technical Features

### Real-Time Price Calculation
- JavaScript calculates price instantly as user types
- No page reload needed
- Works on mobile and desktop

### Google Maps Integration
- Address autocomplete (reduces typos)
- Automatic distance calculation
- GPS coordinate matching for fixed routes

### Payment Integration
- Stripe and PayPal ready
- Full payment or deposit options
- Automatic confirmation emails

### Multi-Language Support
- **Italian, English, German, French** included
- All interface text translatable via admin panel
- Customers select language preference
- Email notifications in customer's language
- SEO-optimized for each language

### Mobile-Responsive
- Works perfectly on phones and tablets
- Touch-friendly interface

---

## 📊 Sample Scenarios

### Scenario A: Popular Fixed Route
```
Route: Olbia Airport → Porto Cervo
Passengers: 3
Vehicle: Business Sedan
Date: August 5 (High Summer)
Time: 15:00 (Standard)

Calculation:
€65 (fixed) × 1.30 (Business) × 1.00 (3 pax) × 1.30 (Summer) × 1.00 = €109.85
```

### Scenario B: Custom Distance-Based Route
```
Route: Custom address → Custom address (120km)
Passengers: 8
Vehicle: Minibus (required)
Date: March 15 (Low Season)
Time: 23:00 (Night)

Calculation:
[€60 + (120 × €1.20)] = €204
€204 × 2.50 (Minibus) × 1.15 (8 pax) × 1.00 (Low) × 1.20 (Night) = €705.24
```

### Scenario C: Large Group Upgrade
```
Route: Cagliari Airport → Villasimius
Passengers: 12
Vehicle: Minibus (required minimum)
Date: December 25 (Christmas)
Time: 09:00 (Standard)
Extras: 2× Child Seats

Calculation:
€80 × 2.50 (Minibus) × 1.20 (12 pax) × 1.25 (Christmas) × 1.00 = €300
+ €20 (2 child seats) = €320 total
```

---

## ✅ Advantages Over Connecto

1. **Full Price Control** - You set every price point
2. **Better Calibration** - No "incorrectly calibrated" prices
3. **Transparent Pricing** - Customer sees exact breakdown
4. **Your Brand** - Not sending customers to third-party platform
5. **Data Ownership** - All customer data stays with you
6. **Custom Rules** - Add any pricing logic you need
7. **No Commission** - Keep 100% of revenue

---

## 🚀 Implementation Approach

**Option 1: WordPress Plugin** (Recommended)
- Integrates with your existing website
- Easy to manage from WordPress admin
- Works with WooCommerce for payments
- Estimated development: 6-8 weeks

**Option 2: Standalone Web Application**
- Independent booking platform
- Can integrate with any website via iframe
- More flexibility for future features
- Estimated development: 8-10 weeks

Both options include:
- Full admin panel
- Customer booking interface
- Payment processing
- Email notifications
- Mobile responsive design
- Initial setup and training

---

## 📝 Next Steps

After you review this logic and answer our clarification questions:

1. **Finalize Pricing Rules** - Confirm all multipliers and base prices
2. **Design Review** - Mock-ups of booking form and admin panel
3. **Technical Specification** - Detailed development plan
4. **Quote & Timeline** - Fixed price and delivery schedule
5. **Development Kickoff** - Begin building the system

---

**Questions?**

This document is meant to start the conversation. We're happy to adjust any part of this logic to match your specific business needs.

The key is that YOU maintain complete control over pricing while giving customers instant, transparent quotes - exactly what you're looking for.

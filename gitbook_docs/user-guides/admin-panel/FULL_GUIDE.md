# Full Admin Guide

This document provides comprehensive documentation for the Django Admin Panel of the Transfer Booking Module.

## Access

* **URL:** `/admin/`
* **Authentication:** Admin or staff user account required

***

## User Management

### User Administration

**Location:** Admin → Accounts → Users

Manage all system users including customers, drivers, managers, and administrators.

<figure><img src="../../.gitbook/assets/User Administration. List.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column     | Description                                  |
| ---------- | -------------------------------------------- |
| Email      | User's email (used as username)              |
| First Name | User's first name                            |
| Last Name  | User's last name                             |
| Role       | User role (Admin, Manager, Driver, Customer) |
| Language   | Preferred language                           |
| Is Active  | Account status                               |
| Is Staff   | Staff access permission                      |

**Filters:**

* Role (Admin, Manager, Driver, Customer)
* Language (English, Italian, German, French, Arabic)
* Is Active
* Is Staff
* Is Superuser

<figure><img src="../../.gitbook/assets/User Administration. Filters.png" alt="" width="261"><figcaption></figcaption></figure>

**Search:** Email, first name, last name, phone number

**Inline Editing:** Role, language, and active status can be edited directly from the list view.

**User Detail Sections:**

1. **Basic Information**
   * Email (used as username for authentication)
   * Password management
2. **Personal Information**
   * First name
   * Last name
   * Phone number
   * Language preference (EN, IT, DE, FR, AR)
3. **Role & Permissions**
   * **Role Types:**
     * `admin` — Full system access
     * `manager` — Booking and operations management
     * `driver` — Driver-specific functionality
     * `customer` — Standard customer account
   * Is Active — Enable/disable account
   * Is Staff — Allow admin panel access
   * Is Superuser — Full administrative privileges
   * Groups and permissions assignment
4. **Timestamps** (collapsed, read-only)
   * Last login
   * Created at
   * Updated at

***

## Booking Management

### Bookings

**Location:** Admin → Bookings → Bookings

Central management for all transfer bookings.

<figure><img src="../../.gitbook/assets/Booking Management.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column            | Description               |
| ----------------- | ------------------------- |
| Booking Reference | Unique booking identifier |
| Customer Name     | Customer's full name      |
| Service Date      | Date of transfer          |
| Pickup Time       | Scheduled pickup time     |
| Passengers        | Number of passengers      |
| Vehicle Class     | Selected vehicle tier     |
| Final Price       | Total booking price       |
| Status            | Booking status            |
| Payment Status    | Payment status            |

**Filters:**

* Status (Pending, Confirmed, In Progress, Completed, Cancelled)
* Payment Status (Pending, Paid, Refunded, Failed)
* Pricing Type (Fixed Route, Distance-based)
* Vehicle Class
* Service Date

**Search:** Booking reference, customer name, email, phone, pickup address, dropoff address

**Date Navigation:** Hierarchical date browser by year/month/day on service date

**Booking Detail Sections:**

1. **Booking Information**
   * Booking reference (auto-generated, read-only)
   * Status management
   * Payment status
2. **Route Details**
   * Pickup address with GPS coordinates
   * Dropoff address with GPS coordinates
   * Pickup notes
   * Dropoff notes
   * Service date
   * Pickup time
3. **Passengers & Vehicle**
   * Number of passengers
   * Large luggage count
   * Small luggage count
   * Number of children (0-4 years, requiring child seats)
   * Number of children (4-12 years, requiring booster seats)
   * Selected vehicle class
4. **Flight & Special Requests**
   * Flight number (for airport transfers)
   * Special requests/notes
5. **Pricing Breakdown**
   * Pricing type (Fixed Route or Distance-based)
   * Base price
   * Vehicle multiplier applied
   * Passenger multiplier applied
   * Seasonal multiplier applied
   * Time multiplier applied
   * Extra fees breakdown
   * **Final Price** = (Base × Vehicle × Passengers × Season × Time) + Extras
6. **Customer Information**
   * Customer name
   * Phone number
   * Email address
   * Linked user account (if registered)
7. **Payment Information**
   * Payment method
   * Payment intent ID (Stripe reference)
8. **Internal Notes** (collapsed)
   * Internal staff notes
   * Timestamps

***

## Vehicle Management

### Vehicle Classes

**Location:** Admin → Vehicles → Vehicle Classes

Configure available vehicle tiers and their properties.

<figure><img src="../../.gitbook/assets/Vehicle Management. LIst.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column            | Description                                 |
| ----------------- | ------------------------------------------- |
| Class Name        | Display name (e.g., "Economy", "Business")  |
| Class Code        | Internal code (e.g., "economy", "business") |
| Tier Level        | Hierarchy level (1-7, where 1 is lowest)    |
| Price Multiplier  | Price factor applied to base price          |
| Max Passengers    | Maximum passenger capacity                  |
| Max Large Luggage | Maximum large luggage capacity              |
| Is Active         | Availability status                         |
| Display Order     | Sort order in selection lists               |

**Inline Editing:** Price multiplier, active status, and display order can be edited from list view.

**Vehicle Class Detail Sections:**

1. **Vehicle Class Configuration**
   * Class name
   * Class code (used in API)
   * Tier level (1 = Economy, 7 = Large Minibus)
2. **Pricing**
   * Price multiplier (e.g., 1.0 for Economy, 1.5 for Business)
3. **Capacity**
   * Maximum passengers
   * Maximum large luggage pieces
   * Maximum small luggage pieces
4. **Display Settings**
   * Description text
   * Example vehicles (e.g., "Toyota Corolla, VW Golf")
   * Icon URL
   * Display order
5. **Status**
   * Is active

**Inline Editor: Passenger Multipliers**

Each vehicle class has passenger-based pricing tiers configured inline:

| Field          | Description                                               |
| -------------- | --------------------------------------------------------- |
| Min Passengers | Minimum passenger count for this tier                     |
| Max Passengers | Maximum passenger count for this tier                     |
| Multiplier     | Price multiplier (e.g., 1.0 for 1-5 pax, 1.1 for 6-7 pax) |
| Description    | Display text                                              |
| Is Active      | Enable/disable this tier                                  |

***

### Vehicle Class Requirements

**Location:** Admin → Vehicles → Vehicle Class Requirements

Define automatic vehicle tier requirements based on passenger/luggage counts.

<figure><img src="../../.gitbook/assets/Vehicle Class Requirements.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column           | Description                                          |
| ---------------- | ---------------------------------------------------- |
| Required For     | Criterion type (passengers, large luggage, children) |
| Min Value        | Minimum count that triggers requirement              |
| Max Value        | Maximum count (optional)                             |
| Min Vehicle Tier | Required minimum vehicle tier                        |
| Is Strict        | Whether requirement is mandatory                     |

**Configuration Fields:**

* Required for: What triggers this requirement
* Value range: Min and max counts
* Minimum vehicle tier: Required tier level (1-7)
* Is strict: If true, prevents booking lower-tier vehicles
* Validation message: Custom error message shown to users

***

## Pricing Configuration

### Seasonal Multipliers

**Location:** Admin → Pricing → Seasonal Multipliers

Configure dynamic pricing based on seasons and special periods.

<figure><img src="../../.gitbook/assets/Seasonal Multipliers.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column         | Description                                     |
| -------------- | ----------------------------------------------- |
| Season Name    | Display name (e.g., "High Summer", "Christmas") |
| Start Date     | Season start date                               |
| End Date       | Season end date                                 |
| Multiplier     | Price multiplier (e.g., 1.30 = +30%)            |
| Year Recurring | Applies every year                              |
| Priority       | Higher priority takes precedence                |
| Is Active      | Enable/disable                                  |

**Inline Editing:** Multiplier, priority, and active status

**Configuration Details:**

* **Multiplier Examples:**
  * 1.00 = Standard pricing
  * 1.20 = +20% premium
  * 1.40 = +40% premium (peak periods)
* **Priority:** When dates overlap, higher priority season applies
* **Year Recurring:** When enabled, season applies every year regardless of year in dates
* **Cross-Year Support:** Seasons can span year boundaries (e.g., Dec 20 - Jan 5)

***

### Passenger Multipliers

**Location:** Admin → Pricing → Passenger Multipliers

Configure price adjustments based on vehicle "fullness".

<figure><img src="../../.gitbook/assets/Passenger Multipliers.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column         | Description              |
| -------------- | ------------------------ |
| Vehicle Class  | Associated vehicle class |
| Min Passengers | Minimum passenger count  |
| Max Passengers | Maximum passenger count  |
| Multiplier     | Price multiplier         |
| Description    | Display text             |
| Is Active      | Enable/disable           |

**Example Configuration:**

| Vehicle | Passengers | Multiplier |
| ------- | ---------- | ---------- |
| Minivan | 1-5        | 1.00       |
| Minivan | 6-7        | 1.10       |
| Minibus | 1-8        | 1.00       |
| Minibus | 9-12       | 1.15       |

***

### Time Multipliers

**Location:** Admin → Pricing → Time Multipliers

Configure premium pricing for specific time periods.

<figure><img src="../../.gitbook/assets/Time Multipliers.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column              | Description                                        |
| ------------------- | -------------------------------------------------- |
| Time Name           | Display name (e.g., "Late Night", "Early Morning") |
| Start Time          | Period start time                                  |
| End Time            | Period end time                                    |
| Multiplier          | Price multiplier                                   |
| Applies to Weekdays | Active Monday-Friday                               |
| Applies to Weekends | Active Saturday-Sunday                             |
| Is Active           | Enable/disable                                     |

**Example Configuration:**

| Period     | Time          | Multiplier | Days     |
| ---------- | ------------- | ---------- | -------- |
| Late Night | 22:00 - 06:00 | 1.20       | All      |
| Rush Hour  | 07:00 - 09:00 | 1.10       | Weekdays |
| Rush Hour  | 17:00 - 19:00 | 1.10       | Weekdays |

***

### Extra Fees

**Location:** Admin → Pricing → Extra Fees

Configure additional services and fees.

<figure><img src="../../.gitbook/assets/Extra Fees.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column        | Description                   |
| ------------- | ----------------------------- |
| Fee Name      | Display name                  |
| Fee Code      | Internal identifier           |
| Fee Type      | Flat, Per Item, or Percentage |
| Amount        | Fee amount or percentage      |
| Is Optional   | Customer can opt-out          |
| Is Active     | Enable/disable                |
| Display Order | Sort order                    |

**Fee Types:**

* **Flat:** Fixed amount regardless of quantity
* **Per Item:** Multiplied by quantity selected
* **Percentage:** Percentage of subtotal

**Configuration Fields:**

* Fee name and code
* Fee type and amount
* Is optional (customer choice vs mandatory)
* Applies when conditions
* Display order and description

**Common Extra Fees:**

* Child seat rental
* Booster seat rental
* Extra luggage handling
* Meet & greet service
* Pet transport
* Waiting time

***

### Round Trip Discounts

**Location:** Admin → Pricing → Round Trip Discounts

Configure discounts for round-trip bookings.

<figure><img src="../../.gitbook/assets/Round Trip Discounts.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column           | Description                             |
| ---------------- | --------------------------------------- |
| Name             | Discount name                           |
| Multiplier       | Price multiplier (e.g., 0.90 = 10% off) |
| Discount Display | Calculated percentage off               |
| Is Active        | Enable/disable                          |

**Configuration:**

* Name: Display name for the discount
* Multiplier: Applied to total price (0.90 = 10% discount, 0.85 = 15% discount)
* Description: Internal notes
* Is Active: Enable/disable discount

***

## Route Management

### Fixed Routes

**Location:** Admin → Routes → Fixed Routes

Configure popular routes with predefined pricing.

<figure><img src="../../.gitbook/assets/Fixed Routes.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column        | Description                         |
| ------------- | ----------------------------------- |
| Route Name    | Display name                        |
| Base Price    | Fixed price for this route          |
| Distance (km) | Reference distance                  |
| Pickup Type   | Location type (airport, city, etc.) |
| Dropoff Type  | Location type                       |
| Is Active     | Enable/disable                      |

**Inline Editing:** Base price and active status

**Configuration Sections:**

1. **Fixed Route Configuration**
   * Route name (e.g., "Cagliari Airport → Villasimius")
2. **Pickup Location**
   * Address
   * GPS coordinates (latitude, longitude)
   * Location type (Airport, City Center, Hotel, Resort, Other)
   * Radius (km) for geomatching tolerance
3. **Dropoff Location**
   * Same fields as pickup
4. **Pricing**
   * Base price
   * Currency
   * Distance (for reference only)
5. **Status**
   * Is active
   * Internal notes

**Geomatching:** The system uses Haversine formula to match customer-selected locations to fixed routes within the configured radius tolerance.

***

### Distance Pricing Rules

**Location:** Admin → Routes → Distance Pricing Rules

Configure fallback pricing when no fixed route matches.

<figure><img src="../../.gitbook/assets/Distance Pricing Rules.png" alt=""><figcaption></figcaption></figure>

**List View Columns:**

| Column       | Description                    |
| ------------ | ------------------------------ |
| Rule Name    | Display name                   |
| Base Rate    | Starting price                 |
| Price per km | Per-kilometer rate             |
| Min Distance | Minimum distance for this rule |
| Max Distance | Maximum distance for this rule |
| Priority     | Rule selection priority        |
| Is Active    | Enable/disable                 |

**Inline Editing:** Base rate, price per km, priority, and active status

**Pricing Formula:**

```
Price = Base Rate + (Distance × Price per km) + (Duration × Price per minute)
```

**Configuration:**

* Rule name and priority (higher priority checked first)
* Distance range (min/max kilometers)
* Base rate (flat starting fee)
* Price per kilometer
* Price per minute (optional, for time-based adjustment)

**Example Rules:**

| Rule         | Distance | Base | Per km |
| ------------ | -------- | ---- | ------ |
| Short trips  | 0-20 km  | €15  | €2.00  |
| Medium trips | 20-50 km | €25  | €1.80  |
| Long trips   | 50+ km   | €40  | €1.50  |

***

## Pricing Formula Summary

The final booking price is calculated as follows:

```
Subtotal = Base Price × Vehicle Multiplier × Passenger Multiplier × Seasonal Multiplier × Time Multiplier

Extra Fees = Sum of (Fee Amount × Quantity) for each selected extra

Final Price = (Subtotal + Extra Fees) × Round Trip Multiplier (if applicable)
```

**Where:**

* **Base Price:** From fixed route or distance calculation
* **Vehicle Multiplier:** Based on selected vehicle class
* **Passenger Multiplier:** Based on passenger count and vehicle class
* **Seasonal Multiplier:** Based on service date
* **Time Multiplier:** Based on pickup time and day of week
* **Extra Fees:** Sum of all selected additional services
* **Round Trip Multiplier:** Discount applied if round trip booked

***

## Analytics Dashboard

<figure><img src="../../.gitbook/assets/Sales report.png" alt=""><figcaption></figcaption></figure>

**Key Metrics:**

* Total Revenue
* Total Bookings
* Average Booking Value
* Completion Rate



**Visualizations:**

* Monthly Revenue & Booking Trends
* Booking Status Distribution
* Payment Status Distribution
* Vehicle Class Analysis
* Top 10 Routes by Revenue
* Day-of-Week Analysis

**Filters:**

* Date range
* Booking status
* Payment status
* Vehicle class

**Features:**

* CSV export
* Period comparison (delta calculations)
* 5-minute data caching

***

## Best Practices

### User Management

1. Assign appropriate roles based on job function
2. Keep customer accounts active; deactivate only for policy violations
3. Use staff status sparingly for admin access

### Pricing Configuration

1. Test pricing changes with sample bookings before going live
2. Use priority levels to handle overlapping seasonal periods
3. Review multipliers regularly to stay competitive

### Route Management

1. Set appropriate radius tolerances for geomatching
2. Keep fixed routes updated with current prices
3. Use distance rules as fallback for uncommon routes

### Booking Management

1. Monitor pending bookings daily
2. Update statuses promptly
3. Use internal notes for staff communication

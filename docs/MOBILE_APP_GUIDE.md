# Mobile Application User Guide

This document provides comprehensive documentation for the Transfer Booking mobile application.

---

## Application Overview

The Transfer Booking mobile app allows customers to book private transfer services. The app supports multiple languages and provides a streamlined booking experience with transparent pricing.

**Supported Languages:**
- English
- Italian (Italiano)
- German (Deutsch)
- French (Français)
- Arabic (العربية)

---

## Authentication

### Login Screen

Access your existing account:

1. Enter your email address
2. Enter your password
3. Tap **Sign In**

If you don't have an account, tap **Don't have an account? Register** to create one.

---

### Registration Screen

Create a new account:

**Required Fields:**
- First Name
- Last Name
- Email Address
- Password
- Confirm Password

**Optional Fields:**
- Phone Number

After registration, you will be automatically logged in.

---

## Home Screen

The home screen has three main tabs accessible via the bottom navigation bar.

### Tab 1: Book a Transfer

The main booking tab displays:

**Quick Booking Card:**
- Welcome message
- "Book Your Transfer" call-to-action button
- Tap to start the booking wizard

**Popular Routes:**
- List of frequently booked routes
- Each route shows:
  - Origin location
  - Destination location
  - Starting price
- Tap a route to auto-populate pickup and dropoff in the booking wizard

---

### Tab 2: My Bookings

View and manage your bookings:

**Booking List:**
- Booking reference number
- Route (pickup → dropoff)
- Service date and time
- Return date/time (for round trips)
- Final price
- Status badge

**Booking Statuses:**
| Status | Color | Description |
|--------|-------|-------------|
| Pending | Yellow | Awaiting confirmation |
| Confirmed | Blue | Booking confirmed |
| In Progress | Purple | Transfer in progress |
| Completed | Green | Transfer completed |
| Cancelled | Red | Booking cancelled |

**Features:**
- Pull down to refresh the list
- Tap any booking to view full details
- Round-trip bookings show a special badge

**Note:** You must be logged in to view your bookings.

---

### Tab 3: More

Additional app features and settings:

**Menu Items:**
- **Profile** — View and edit your profile
- **Help & Support** — Contact support (coming soon)
- **About** — App version and information
- **Dispatcher** — Admin dashboard (admin/manager users only)

**Language Selection:**
- Tap to change app language
- Options: System Default, English, Italian, German, French, Arabic

---

## User Profile

Access from More tab → Profile

**Profile Information:**
- Profile avatar (shows initial)
- Full name
- Email address
- Role badge (Customer, Driver, Manager, Admin)
- Phone number
- Language preference

**Actions:**
- **Change Language** — Select preferred language
- **Logout** — Sign out of the app (requires confirmation)

---

## Booking Wizard

The booking process consists of 5 steps. Progress is shown at the top of each screen.

---

### Step 1: Route Selection

Configure your transfer route and details.

#### Your Route Card

**Pickup Location:**
- Tap to select from predefined locations
- Search or browse available locations
- Location types: Airport, City Center, Hotel, Resort

**Dropoff Location:**
- Same selection process as pickup
- Tap the swap button (↕) to reverse pickup and dropoff

**Coming Soon:**
- Current location (GPS)
- Map picker for custom locations

---

#### Travel Dates Card

**Trip Type:**
- **Single Trip** — One-way transfer
- **Round Trip** — Outbound and return transfers

**Outbound Trip:**
- Select date
- Select time
- Choose mode:
  - **Departure Time** — When you want to be picked up
  - **Arrival Time** — When you need to arrive (driver adjusts pickup accordingly)
- Tap **Now** for immediate pickup

**Return Trip** (Round Trip only):
- Select return date
- Select return time
- Same departure/arrival mode options

---

#### Trip Info Card

Displays calculated route information:
- **Distance** — Total kilometers
- **Duration** — Estimated travel time

Tap to scroll to the map preview below.

---

#### Passengers Card

**Adults:**
- Use +/- buttons to adjust count

**Child Seats (0-4 years):**
- For infants and toddlers
- Meets Swiss child safety regulations
- Automatically adds child seat extras

**Booster Seats (4-12 years):**
- For older children
- Meets Swiss child safety regulations
- Automatically adds booster seat extras

---

#### Luggage Card

**Standard Luggage:**
- Large luggage (suitcases)
- Small luggage (carry-on bags)

**Sports Equipment:**
- Surfboards / Bikes / Golf bags
- Ski / Snowboard equipment
- Other sports equipment (with details field)

---

#### Map Preview

Interactive map showing:
- Pickup location marker
- Dropoff location marker
- Route path between locations

Features:
- Zoom and pan
- Tap to expand full-screen
- Updates dynamically when locations change

---

### Step 2: Vehicle Selection

Choose your vehicle class.

**Information Banner:**
- Shows your passenger count
- Shows your luggage requirements
- Indicates minimum vehicle tier needed

**Vehicle List:**
Each vehicle card displays:
- Vehicle class name (e.g., Economy, Business, Minivan)
- Description
- Example vehicles
- Passenger capacity icon
- Luggage capacity icon
- Price multiplier indicator

**Vehicle Filtering:**
- Vehicles not meeting your requirements are disabled
- Disabled vehicles show the reason (e.g., "Not enough seats")
- Some vehicles may require higher tier based on:
  - Passenger count
  - Luggage count
  - Number of children

**Selection:**
- Tap a vehicle card to select it
- Selected vehicle shows a checkmark
- Tap **Continue** to proceed

---

### Step 3: Extras Selection

Add optional services to your booking.

#### Optional Services

List of available extras:
- Child seats
- Booster seats
- Additional services

**For Each Extra:**
- Toggle on/off
- Adjust quantity with +/- buttons
- View individual fee amount

**Automatic Additions:**
- Child seats are auto-added based on children (0-4 years) count
- Booster seats are auto-added based on children (4-12 years) count
- Required seats cannot be removed

**Extras Total:**
- Running total of all selected extras displayed

---

#### Included Services

Mandatory services included in all bookings:
- Displayed for information only
- Cannot be removed
- Already included in base price calculation

**Actions:**
- **Skip** — Continue without optional extras
- **Continue** — Proceed with selected extras

---

### Step 4: Passenger Details

Enter contact and trip information.

#### Contact Information (Required)

| Field | Description |
|-------|-------------|
| First Name | Passenger's first name |
| Last Name | Passenger's last name |
| Phone | Contact phone number |
| Email | Contact email address |

**Note:** If logged in, fields are pre-filled from your profile.

---

#### Trip Details (Optional)

**Flight Number:**
- For single trips: Enter your flight number
- For round trips: Enter outbound flight number

**Return Flight Number** (Round Trip only):
- Enter return flight number

**Special Requests:**
- Multi-line text field
- Enter any special requirements
- Examples: wheelchair assistance, specific route preferences, waiting instructions

**Flight Information Note:**
The system monitors flight arrivals to adjust pickup times automatically.

---

### Step 5: Review & Confirm

Review your complete booking before confirmation.

#### Booking Summary

**Route Section:**
- Pickup location
- Dropoff location
- Edit button to return to Step 1

**Vehicle Section:**
- Selected vehicle class
- Edit button to return to Step 2

**Extras Section:**
- List of selected extras with quantities
- Edit button to return to Step 3

**Passenger Section:**
- Contact name
- Phone and email
- Flight number(s)
- Special requests
- Edit button to return to Step 4

---

#### Price Breakdown

**Transparent Pricing:**

| Item | Description |
|------|-------------|
| Pricing Type | Fixed Route or Distance-based |
| Route/Distance | Route name or calculated distance |
| Base Price | Starting price |
| Vehicle Multiplier | Selected vehicle adjustment |
| Passenger Multiplier | Based on passenger count |
| Seasonal Multiplier | Based on travel date |
| Time Multiplier | Based on pickup time |
| **Subtotal** | Sum of above |
| Extra Services | Itemized list with quantities |
| **Extras Total** | Sum of extras |
| Round Trip Discount | Applied discount (if applicable) |
| **Final Total** | Complete booking price |

**Note:** Detailed pricing breakdown is visible to admin/manager users. Regular customers see simplified pricing.

---

#### Terms & Conditions

Before confirming, you must accept:
- ☐ Terms & Conditions
- ☐ Privacy Policy

Both checkboxes are required to proceed.

---

#### Confirmation

1. Review all details
2. Check both agreement boxes
3. Tap **Confirm Booking**
4. Wait for confirmation
5. Success dialog shows your **Booking Reference**
6. Booking appears in "My Bookings" tab

---

## Booking Detail Screen

View complete information about a specific booking.

**Header:**
- Status badge with color
- Booking reference number
- Final price

**Sections:**

**Route:**
- Pickup address with icon
- Dropoff address with icon

**Date & Time:**
- Outbound date and time
- Return date and time (if round trip)
- Flight number(s)

**Vehicle:**
- Vehicle class name
- Passenger count badge
- Luggage count badge

**Flight Number:**
- Displayed if provided

**Special Requests:**
- Displayed if provided

**Passenger Information:**
- Full name
- Email address
- Phone number

**Price Breakdown:**
- Itemized fees
- Final total

---

## Features by User Role

### Customer
- Book transfers
- View own bookings
- Edit profile
- Change language

### Driver
- Same as Customer
- (Driver-specific features in separate driver app)

### Manager
- All Customer features
- Access Dispatcher dashboard
- View detailed pricing breakdowns

### Admin
- All Manager features
- Full system access

---

## Technical Information

### State Management
The app uses Riverpod for reactive state management, ensuring:
- Real-time price updates
- Persistent booking wizard state
- Automatic data synchronization

### Navigation
GoRouter provides:
- Deep linking support
- Authentication-based redirects
- Smooth screen transitions

### Offline Support
- Cached location data
- Cached vehicle information
- Cached extra fees

---

## Troubleshooting

### Login Issues
- Verify email and password
- Check internet connection
- Try "Forgot Password" if available

### Booking Not Appearing
- Pull down to refresh the list
- Check you're logged in
- Verify booking was confirmed (not just reviewed)

### Price Calculation
- Prices update automatically
- Ensure all required fields are filled
- Try re-selecting vehicle if prices seem incorrect

### Map Not Loading
- Check internet connection
- Allow location permissions if requested
- Try scrolling the page

### Language Not Changing
- Close and reopen the app
- Check language setting in Profile

---

## Support

For assistance:
1. Check Help & Support in the More tab
2. Contact support via the provided channels
3. Include your booking reference when reporting issues

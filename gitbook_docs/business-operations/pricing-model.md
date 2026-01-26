# Pricing Model

Understanding the 8Move Transfer pricing engine and how final prices are calculated.

## Overview

8Move Transfer uses a sophisticated multi-factor pricing model that combines base pricing with dynamic multipliers to calculate fair, transparent prices for every transfer.

### Pricing Philosophy

**Transparent & Fair:**
- All factors shown to customers
- No hidden charges
- Predictable pricing rules
- Seasonal and demand-based adjustments

**Flexible & Dynamic:**
- Responds to market conditions
- Accommodates peak periods
- Rewards round-trip bookings
- Scales with vehicle capacity

---

## Pricing Formula

The complete pricing formula:

```
Step 1: Calculate Subtotal
Subtotal = Base Price × Vehicle Multiplier × Passenger Multiplier × Seasonal Multiplier × Time Multiplier

Step 2: Add Extra Fees
With Extras = Subtotal + Sum(Extra Fees)

Step 3: Apply Round Trip Discount (if applicable)
Final Price = With Extras × Round Trip Multiplier
```

---

## Step 1: Base Price

The foundation of all pricing calculations.

### Two Methods

#### Fixed Route Pricing

**For Popular Routes:**
- Pre-configured base prices
- Examples: Airport to City Center
- Consistent pricing
- Fast calculation

**Configuration:**
Admin → Routes → Fixed Routes

**Example:**
```
Route: Cagliari Airport → Villasimius
Base Price: CHF 85.00
```

#### Distance-Based Pricing

**For Custom Routes:**
- Calculated from distance and duration
- Formula: `Base Rate + (Distance × Price/km) + (Duration × Price/min)`
- Fallback when no fixed route matches
- Flexible for any destination

**Configuration:**
Admin → Routes → Distance Pricing Rules

**Example:**
```
Rule: Medium Distance (20-50 km)
Base Rate: CHF 25.00
Price per km: CHF 1.80
Price per minute: CHF 0.50

For 35 km route (40 min):
Base = 25 + (35 × 1.80) + (40 × 0.50) = CHF 108.00
```

---

## Step 2: Vehicle Multiplier

Adjusts price based on selected vehicle class.

### Vehicle Tiers

| Tier | Class | Typical Multiplier | Examples |
|------|-------|-------------------|----------|
| 1 | Economy | 1.00 (base) | Toyota Corolla, VW Golf |
| 2 | Comfort | 1.20 (+20%) | Toyota Camry, BMW 3 Series |
| 3 | Business | 1.50 (+50%) | Mercedes E-Class, BMW 5 Series |
| 4 | Minivan 5 | 1.40 (+40%) | VW Touran, Ford Transit Custom |
| 5 | Minivan 7 | 1.60 (+60%) | Mercedes V-Class, VW Caravelle |
| 6 | Minibus Small | 2.00 (+100%) | Mercedes Sprinter (8-12 pax) |
| 7 | Minibus Large | 2.50 (+150%) | Mercedes Sprinter (13-19 pax) |

### Example Calculation

```
Base Price: CHF 85.00
Vehicle: Business Class (1.50)

With Vehicle = 85 × 1.50 = CHF 127.50
```

**Configuration:**
Admin → Vehicles → Vehicle Classes

---

## Step 3: Passenger Multiplier

Adjusts for vehicle capacity utilization.

### Rationale

- Fuller vehicles cost more to operate
- Wear and tear increases
- Fuel consumption rises
- Comfort considerations

### Example Configuration

**Minivan (7-seater):**
| Passengers | Multiplier | Reasoning |
|-----------|------------|-----------|
| 1-5 | 1.00 | Standard capacity |
| 6-7 | 1.10 (+10%) | Near full capacity |

**Minibus (12-seater):**
| Passengers | Multiplier | Reasoning |
|-----------|------------|-----------|
| 1-8 | 1.00 | Standard capacity |
| 9-12 | 1.15 (+15%) | High capacity |

### Example Calculation

```
Current: CHF 127.50
Passengers: 6 (in Minivan 7-seater)
Multiplier: 1.10

With Passengers = 127.50 × 1.10 = CHF 140.25
```

**Configuration:**
Admin → Pricing → Passenger Multipliers
Admin → Vehicles → Vehicle Classes → Passenger Multipliers (inline)

---

## Step 4: Seasonal Multiplier

Adjusts for demand periods and seasonality.

### Common Seasons

**High Summer (June-August):**
- Tourist season
- High demand
- Multiplier: 1.30 (+30%)

**Christmas/New Year (Dec 20 - Jan 5):**
- Holiday period
- Premium rates
- Multiplier: 1.40 (+40%)

**Shoulder Season (Apr-May, Sep-Oct):**
- Moderate demand
- Standard rates
- Multiplier: 1.10 (+10%)

**Low Season (Nov-Mar, excluding holidays):**
- Low demand
- Base rates
- Multiplier: 1.00 (no adjustment)

### Priority System

When dates overlap:
- Higher priority multiplier applies
- Example: Christmas (priority 10) overrides Low Season (priority 1)

### Year Recurring

- Seasons can repeat annually
- Useful for annual events
- Check "Year Recurring" option

### Example Calculation

```
Current: CHF 140.25
Date: July 15 (High Summer)
Multiplier: 1.30

With Season = 140.25 × 1.30 = CHF 182.33
```

**Configuration:**
Admin → Pricing → Seasonal Multipliers

---

## Step 5: Time Multiplier

Adjusts for time-of-day and day-of-week.

### Common Time Periods

**Late Night (22:00 - 06:00):**
- Difficult hours
- Driver premium
- All days
- Multiplier: 1.20 (+20%)

**Rush Hour Morning (07:00 - 09:00):**
- Traffic congestion
- Longer duration
- Weekdays only
- Multiplier: 1.10 (+10%)

**Rush Hour Evening (17:00 - 19:00):**
- Peak traffic
- Higher demand
- Weekdays only
- Multiplier: 1.10 (+10%)

**Weekend Premium:**
- Saturday/Sunday
- Specific hours
- Multiplier: 1.05 (+5%)

### Weekday vs Weekend

Configure separately:
- "Applies to Weekdays" checkbox
- "Applies to Weekends" checkbox
- Can apply to both

### Example Calculation

```
Current: CHF 182.33
Time: 23:00 (Late Night)
Multiplier: 1.20

Subtotal = 182.33 × 1.20 = CHF 218.80
```

**Configuration:**
Admin → Pricing → Time Multipliers

---

## Step 6: Extra Fees

Additional services and requirements.

### Fee Types

#### Flat Fee
- Fixed amount regardless of quantity
- Example: Meet & Greet service
- Amount: CHF 20.00

#### Per Item Fee
- Multiplied by quantity selected
- Example: Child seat
- Amount: CHF 12.00 per seat
- Quantity: 2
- Total: CHF 24.00

#### Percentage Fee
- Percentage of subtotal
- Example: Service fee
- Rate: 3%
- Based on: CHF 218.80
- Amount: CHF 6.56

### Common Extras

| Service | Type | Typical Fee |
|---------|------|-------------|
| Child Seat (0-4 years) | Per Item | CHF 12.00 |
| Booster Seat (4-12 years) | Per Item | CHF 10.00 |
| Meet & Greet | Flat | CHF 20.00 |
| Extra Waiting Time | Per Hour | CHF 25.00 |
| Pet Transport | Flat | CHF 15.00 |
| Ski Equipment | Per Set | CHF 10.00 |
| Golf Bags | Per Item | CHF 8.00 |
| Extra Luggage | Per Item | CHF 5.00 |

### Optional vs Mandatory

**Optional:**
- Customer can choose
- Not required for booking
- Toggle on/off

**Mandatory:**
- Automatically added
- Child seats (safety requirement)
- Cannot be removed
- Quantity matches children count

### Example Calculation

```
Subtotal: CHF 218.80
Extras:
  - 2× Child Seat: CHF 24.00
  - Meet & Greet: CHF 20.00
  
With Extras = 218.80 + 24.00 + 20.00 = CHF 262.80
```

**Configuration:**
Admin → Pricing → Extra Fees

---

## Step 7: Round Trip Discount

Incentive for booking return transfers.

### Discount Structure

**Typical Discount:**
- 10% off total price
- Multiplier: 0.90
- Applied to complete booking (outbound + return)

**Higher Discounts:**
- For longer trips
- Loyalty customers
- Special promotions
- Multiplier: 0.85 (15% off)

### When Applied

- Only for round trip bookings
- Both legs must be confirmed
- Single discounted rate
- Calculated on total with extras

### Example Calculation

```
With Extras: CHF 262.80
Round Trip Discount: 10% (multiplier 0.90)

Final Price = 262.80 × 0.90 = CHF 236.52
```

**Configuration:**
Admin → Pricing → Round Trip Discounts

---

## Complete Example

### Scenario
- **Route:** Cagliari Airport → Villasimius (Fixed route)
- **Date:** July 20, 2024 (High Summer)
- **Time:** 14:30 (Standard hours)
- **Vehicle:** Business Class
- **Passengers:** 6
- **Extras:** 2 child seats, meet & greet
- **Type:** Round trip

### Calculation

```
1. Base Price (Fixed Route)
   = CHF 85.00

2. Vehicle Multiplier (Business 1.50)
   = 85.00 × 1.50
   = CHF 127.50

3. Passenger Multiplier (6 pax, Minivan tier: 1.10)
   = 127.50 × 1.10
   = CHF 140.25

4. Seasonal Multiplier (High Summer: 1.30)
   = 140.25 × 1.30
   = CHF 182.33

5. Time Multiplier (14:30, standard: 1.00)
   = 182.33 × 1.00
   = CHF 182.33

   SUBTOTAL = CHF 182.33

6. Extra Fees
   - 2× Child Seat @ CHF 12.00 = CHF 24.00
   - Meet & Greet = CHF 20.00
   Total Extras = CHF 44.00
   
   WITH EXTRAS = 182.33 + 44.00 = CHF 226.33

7. Round Trip Discount (10%, multiplier 0.90)
   = 226.33 × 0.90
   = CHF 203.70

FINAL PRICE = CHF 203.70 per direction
TOTAL BOOKING = CHF 407.40 (round trip)
```

---

## Price Display

### For Customers (Mobile App)

**Simplified Display:**
- Base price
- Vehicle selection impact
- Selected extras
- Round trip discount
- **Final Total**

Detailed multipliers hidden for simplicity.

### For Admins/Managers

**Detailed Breakdown:**
- All multipliers shown
- Each calculation step
- Reasoning for each factor
- Complete transparency

---

## Pricing Strategy Tips

### Optimize for Revenue

**Peak Period Pricing:**
- Identify high-demand periods
- Set appropriate seasonal multipliers
- Monitor booking patterns
- Adjust based on capacity

**Vehicle Mix:**
- Ensure profitable vehicle multipliers
- Consider operating costs
- Balance premium vs standard options

**Extra Services:**
- Price competitively
- Cover actual costs
- Add reasonable margin
- Review regularly

### Stay Competitive

**Market Research:**
- Monitor competitor pricing
- Adjust base prices as needed
- Offer competitive round-trip discounts
- Balance value and profitability

**Promotional Pricing:**
- Off-season discounts
- First-time customer offers
- Loyalty rewards
- Temporary seasonal multipliers

---

## Configuration Best Practices

### Testing Changes

**Before Going Live:**
1. Configure in test environment
2. Run sample calculations
3. Verify all scenarios
4. Get stakeholder approval
5. Deploy during low-traffic period

### Monitoring

**After Changes:**
- Track booking conversion rates
- Monitor customer feedback
- Compare revenue metrics
- Adjust if needed

### Documentation

**Keep Records:**
- Document all pricing rules
- Note change reasons
- Track historical multipliers
- Maintain pricing strategy document

---

## Common Pricing Scenarios

### Scenario 1: Airport Transfer
- Fixed route pricing (most common)
- Standard vehicle (Economy/Comfort)
- Possible flight tracking
- Meet & greet common extra

### Scenario 2: Long Distance
- Distance-based pricing
- Larger vehicle often needed
- Higher base rate tier
- Possible fuel surcharge

### Scenario 3: Group Transfer
- Minibus required
- Higher vehicle multiplier
- High passenger multiplier
- Multiple luggage handling

### Scenario 4: Premium Service
- Business class vehicle
- Off-peak discount opportunity
- Add-on services (meet & greet)
- Corporate client rates

---

## Related Sections

**Configure Pricing:**
- [Pricing Setup](../user-guides/admin-panel/pricing-setup.md) - Admin panel guide

**Configure Routes:**
- [Route Management](../user-guides/admin-panel/route-management.md) - Route configuration

**Configure Vehicles:**
- [Vehicle Configuration](../user-guides/admin-panel/vehicle-configuration.md) - Fleet setup

**View Results:**
- [Analytics Dashboard](analytics-dashboard.md) - Performance metrics

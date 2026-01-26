# Frequently Asked Questions (FAQ)

Common questions about 8Move Transfer system and operations.

## General Questions

### What is 8Move Transfer?

8Move Transfer is a complete platform for managing private transfer services. It includes a customer mobile app, admin management panel, and analytics dashboard.

### Who can use 8Move Transfer?

**Customers** - Book transfers via mobile app
**Drivers** - Receive and complete bookings
**Operations Managers** - Manage bookings and fleet
**Administrators** - Configure system and pricing

### What platforms are supported?

**Mobile App:**
- iOS 12.0 or later
- Android 6.0 or later

**Admin Panel:**
- Any modern web browser
- Desktop recommended for best experience

### What languages are available?

Five languages fully supported:
- English
- Italian (Italiano)
- German (Deutsch)
- French (Français)
- Arabic (العربية) with RTL support

---

## Booking Questions

### How do I book a transfer?

1. Open mobile app
2. Tap "Book Your Transfer"
3. Follow 5-step wizard
4. Review and confirm
5. Receive booking reference

Detailed guide: [Booking Wizard](../user-guides/mobile-app/booking-wizard.md)

### Can I book for someone else?

Yes! Enter their contact information in Step 4 of the booking wizard. The confirmation will be sent to the provided email.

### What's a round trip booking?

A round trip includes both outbound and return transfers:
- One booking reference
- Discount applied (usually 10%)
- Both legs tracked together
- Can specify different dates/times

### How far in advance should I book?

**Recommended:**
- Domestic transfers: 24-48 hours
- Airport transfers: 48-72 hours
- Long distance: 72+ hours
- Peak season: As early as possible

**Last minute:**
- Use "Book Now" option
- Subject to availability
- May have limited vehicle selection

### Can I modify or cancel a booking?

**Modifications:**
- Contact operator with booking reference
- Changes subject to availability
- May affect price

**Cancellations:**
- Contact operator
- Cancellation policy applies
- Refund depends on timing and policy

### What if my flight is delayed?

Provide your flight number when booking:
- System tracks flight automatically
- Pickup time adjusts for delays
- Driver notified of changes
- No action needed from you

### How many people and bags can I bring?

Depends on vehicle class:

| Vehicle | Passengers | Large Luggage |
|---------|-----------|---------------|
| Economy | 4 | 2-3 |
| Business | 4 | 3-4 |
| Minivan 5 | 5 | 4-5 |
| Minivan 7 | 7 | 5-7 |
| Minibus 8-12 | 8-12 | 8-12 |

System automatically filters vehicles based on your requirements.

---

## Pricing Questions

### How is the price calculated?

Multi-factor formula:
```
Base Price × Vehicle × Passengers × Season × Time + Extras × RoundTrip
```

Detailed explanation: [Pricing Model](../business-operations/pricing-model.md)

### Why did the price change?

Price updates when you change:
- Vehicle class
- Number of passengers
- Travel date (seasonal pricing)
- Pickup time (time multipliers)
- Extra services

This is normal and ensures accurate pricing.

### Are there hidden fees?

No! All fees are shown before confirmation:
- Complete price breakdown visible
- Extras itemized
- All multipliers disclosed (admin view)
- No surprises at checkout

### Do you offer discounts?

**Round Trip Discount:**
- Automatic 10-15% off
- Applied when booking return
- Shown in price breakdown

**Seasonal Discounts:**
- Off-peak periods
- Lower seasonal multipliers
- Check pricing calendar

**Special Offers:**
- Promotional codes (coming soon)
- Corporate rates (contact sales)
- Loyalty programs (planned)

### When do I pay?

Payment methods depend on operator configuration:
- Currently handled offline
- Stripe integration coming soon
- Payment terms set by operator

---

## Child Safety Questions

### Do I need child seats?

**Required by Swiss Law:**
- Children 0-4 years: Child seat mandatory
- Children 4-12 years: Booster seat mandatory
- System automatically adds required seats
- Cannot proceed without them

### Are child seats included?

Typically charged as extras:
- Child seat (0-4): ~CHF 10-15
- Booster seat (4-12): ~CHF 8-12
- Price varies by operator
- Must comply with safety standards

### What if I'm bringing my own seat?

Contact operator before booking:
- Specify in "Special Requests"
- Must meet Swiss standards
- Operator may waive fee
- Confirm before travel day

---

## Vehicle Questions

### What vehicles do you use?

Varies by operator, typical examples:

**Economy:** Toyota Corolla, VW Golf
**Business:** Mercedes E-Class, BMW 5 Series
**Minivan:** Mercedes V-Class, VW Caravelle
**Minibus:** Mercedes Sprinter

Actual vehicle may vary based on availability.

### Can I request a specific car?

Not guaranteed but:
- Select appropriate vehicle class
- Mention preference in "Special Requests"
- Operator will accommodate if possible
- No guarantees on specific model

### Are vehicles accessible?

**Standard Vehicles:**
- Not wheelchair accessible

**Accessibility Needs:**
- Mention in "Special Requests"
- Contact operator in advance
- Special vehicles may be available
- May incur additional costs

### Can I bring my pet?

Usually allowed with notice:
- Select "Pet Transport" extra
- Mention in "Special Requests"
- Small fee typically applies
- Confirm pet policy with operator

---

## Technical Questions

### Do I need internet to use the app?

**Required For:**
- Login/registration
- Creating bookings
- Viewing booking list
- Updating profile
- Price calculations

**Offline Capability:**
- View previously loaded bookings
- Access basic booking details
- Limited functionality

### How do I update the app?

**iOS:**
1. Open App Store
2. Tap profile icon
3. Scroll to available updates
4. Tap "Update" for 8Move Transfer

**Android:**
1. Open Google Play Store
2. Tap menu → My apps & games
3. Find 8Move Transfer
4. Tap "Update"

### Is my data secure?

Yes! Security measures include:
- HTTPS encryption
- GDPR compliant
- Swiss FADP compliant
- Secure authentication
- No credit card storage
- Regular security audits

### Can I use the app in multiple countries?

Yes, but:
- Operator availability varies by region
- Pricing in local currency
- Adjust language as needed
- Check supported countries

---

## Admin Panel Questions

### How do I access the admin panel?

1. Navigate to `yoursite.com/admin/`
2. Login with staff/admin account
3. Must have appropriate permissions

Detailed guide: [Admin Panel](../user-guides/admin-panel/)

### Who can access the admin panel?

**Required:**
- Staff or admin user account
- `is_staff` flag enabled
- Appropriate role assigned

**Roles:**
- Admin: Full access
- Manager: Operations and pricing
- Staff: Limited booking access

### How do I confirm a booking?

1. Admin → Bookings → Bookings
2. Find pending booking
3. Click to open
4. Change status to "Confirmed"
5. Save

### How do I add a new vehicle class?

1. Admin → Vehicles → Vehicle Classes
2. Click "Add Vehicle Class"
3. Fill required fields
4. Set pricing multiplier
5. Configure capacity
6. Save

### Can I export data?

Yes:
- **CSV Export** - Available in list views
- **Analytics Dashboard** - Export reports
- **Database Dumps** - Contact support
- **API Access** - For integrations

---

## Account Questions

### I forgot my password. How do I reset it?

**Coming Soon:**
Password reset functionality is in development.

**Current Workaround:**
Contact support with your registered email.

### Can I change my email address?

Not currently through the app.

**To Change:**
Contact support with:
- Current email
- Desired new email
- Account verification info

### How do I delete my account?

1. Contact support
2. Request account deletion
3. Confirm via email
4. Account deactivated within 7 days
5. Data deleted per retention policy

Important: Cannot be undone!

### Can I have multiple accounts?

Yes, but:
- Use different email addresses
- Each account separate
- No cross-account booking view
- Not recommended for same person

---

## Driver Questions

### Is there a driver app?

**Coming Soon:**
Dedicated driver mobile app in development.

**Current:**
Drivers access bookings via admin panel or receive assignments via other means.

### How are drivers assigned to bookings?

Depends on operator workflow:
- Manual assignment by manager
- Automatic assignment (coming)
- Driver app integration (planned)
- External dispatch system

### Can drivers see customer details?

Yes, drivers need access to:
- Pickup location and time
- Dropoff location
- Passenger name and phone
- Special requests
- Luggage count

### How do drivers update booking status?

**Current:**
- Via admin panel
- Manager updates status
- Phone/radio to dispatch

**Future (Driver App):**
- One-tap status updates
- GPS tracking
- Direct customer communication

---

## Business Operations

### How do I set up seasonal pricing?

1. Admin → Pricing → Seasonal Multipliers
2. Add seasonal multiplier
3. Set date range
4. Choose multiplier value
5. Set priority
6. Enable year-recurring if needed

Guide: [Pricing Setup](../user-guides/admin-panel/pricing-setup.md)

### Can I have different prices for different routes?

Yes! Two approaches:

**Fixed Routes:**
- Set specific price per route
- Common airport/hotel routes
- Fast, consistent pricing

**Distance-Based:**
- Calculate from distance
- Any route covered
- Flexible pricing tiers

### How do I view revenue reports?

**Analytics Dashboard:**
1. Launch Streamlit dashboard
2. Select date range
3. View key metrics
4. Export to CSV

Available metrics:
- Total revenue
- Booking count
- Average value
- Completion rate
- Vehicle class performance
- Route analysis

### Can I integrate with other systems?

**Current:**
- RESTful API available
- Token authentication
- Standard endpoints

**Planned:**
- Webhook notifications
- Payment gateway integration
- Accounting software integration
- Calendar sync

---

## Troubleshooting

### The app crashes when I try to book

See [Troubleshooting Guide](../user-guides/mobile-app/troubleshooting.md)

**Quick fixes:**
1. Update app to latest version
2. Restart device
3. Clear app cache
4. Reinstall if needed

### Booking not showing in My Bookings

**Solutions:**
- Pull down to refresh
- Check you're logged in
- Verify booking was confirmed
- Check confirmation email

### Price seems wrong

**Verify:**
- Check all selected options
- Review price breakdown
- Confirm date and time
- Check for seasonal multipliers

Still incorrect? Contact support with booking reference.

### Can't log in to admin panel

**Check:**
- Correct email and password
- Account has staff/admin role
- Account is active
- Browser cookies enabled

---

## Feature Requests & Feedback

### How do I suggest a new feature?

**Feedback Channels:**
- In-app feedback (coming soon)
- Email: support@trident-software.ch
- Feature request form (planned)

### When will [feature] be available?

**Planned Features:**
- Driver mobile app - Q2 2025
- Payment integration (Stripe) - Q2 2025
- In-app messaging - Q3 2025
- Real-time GPS tracking - Q3 2025
- Corporate portal - Q4 2025

Timeline subject to change.

### Can I customize the app for my business?

Yes! Contact Trident Software about:
- White-label options
- Custom branding
- Feature customization
- Self-hosted deployment
- Integration services

---

## Contact & Support

### How do I contact support?

**Email:** support@trident-software.ch

**Response Time:**
- Standard: 24-48 hours
- Urgent: Mark as high priority
- Business hours: Faster response

**Include:**
- Booking reference (if applicable)
- Screenshots of issue
- Device and app version
- Detailed description

### Where can I find training materials?

**Available Resources:**
- This documentation
- Video tutorials (coming soon)
- On-site training (contact sales)
- Webinars (planned)

### Is technical support included?

**Included:**
- Bug fixes
- System updates
- Email support
- Documentation updates

**Additional Services:**
- Custom development
- On-site training
- Priority support
- System integration

Contact sales for enterprise support packages.

---

## Still Have Questions?

**Documentation:**
- [Mobile App Guide](../user-guides/mobile-app/)
- [Admin Panel Guide](../user-guides/admin-panel/)
- [Business Operations](../business-operations/)

**Contact:**
- Support: support@trident-software.ch
- Sales: sales@trident-software.ch
- Technical: tech@trident-software.ch

**Company:**
Trident Software Sàrl
Sion, Valais, Switzerland
Website: trident-software.ch

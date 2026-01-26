# Home Screen

The home screen is your central hub for accessing all app features. It consists of three main tabs accessible via the bottom navigation bar.

## Navigation Tabs

The bottom navigation bar provides quick access to:

| Tab | Icon | Purpose |
|-----|------|---------|
| **Book** | <svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 -960 960 960" width="20" fill="#3e99d4" style="vertical-align: middle;"><path d="M440-280h80v-160h160v-80H520v-160h-80v160H280v80h160v160Zm40 200q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Zm0-320Z"/></svg> | Start new transfer bookings |
| **My Bookings** | <svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 -960 960 960" width="20" fill="#3e99d4" style="vertical-align: middle;"><path d="M280-600h80v-80h-80v80Zm0 160h80v-80h-80v80Zm0 160h80v-80h-80v80Zm160-160h240v-80H440v80Zm0 160h240v-80H440v80Zm0-320h240v-80H440v80ZM200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h560q33 0 56.5 23.5T840-760v560q0 33-23.5 56.5T760-120H200Zm0-80h560v-560H200v560Zm0-560v560-560Z"/></svg> | View and manage existing bookings |
| **More** | <svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 -960 960 960" width="20" fill="#3e99d4" style="vertical-align: middle;"><path d="M240-400q-33 0-56.5-23.5T160-480q0-33 23.5-56.5T240-560q33 0 56.5 23.5T320-480q0 33-23.5 56.5T240-400Zm240 0q-33 0-56.5-23.5T400-480q0-33 23.5-56.5T480-560q33 0 56.5 23.5T560-480q0 33-23.5 56.5T480-400Zm240 0q-33 0-56.5-23.5T640-480q0-33 23.5-56.5T720-560q33 0 56.5 23.5T800-480q0 33-23.5 56.5T720-400Z"/></svg> | Profile, settings, and additional features |


***

## Tab 1: Book a Transfer

The main booking tab is your starting point for creating new transfers.

### Quick Booking Card

Prominent card at the top featuring:

* **Welcome Message** - Personalized greeting
* **"Book Your Transfer" Button** - Large call-to-action
* Tap to launch the [Booking Wizard](booking-wizard.md)

### Popular Routes Section

Browse frequently booked routes for quick access:

<figure><img src="../../.gitbook/assets/Mobile App. List of popular routes with pricing.png" alt="" width="375"><figcaption><p>List of popular routes with pricing</p></figcaption></figure>

**Each Route Card Shows:**

* 📍 **Origin Location** - Pickup point
* 📍 **Destination Location** - Dropoff point
* 💰 **Starting Price** - Base price "from CHF X"

**How to Use:**

1. Scroll through the list of popular routes
2. Tap any route card
3. Booking wizard opens with pickup and dropoff pre-filled
4. Continue with date selection and other details

**Benefits:**

* Faster booking for common routes
* Transparent pricing upfront
* Skip manual location entry

***

## Tab 2: My Bookings

View and manage all your transfer bookings in one place.

<figure><img src="../../.gitbook/assets/Mobile App. My Bookings tab showing list of bookings with status badges.png" alt="" width="375"><figcaption><p>My Bookings tab showing list of bookings with status badges</p></figcaption></figure>

### Booking List

Displays all your bookings in reverse chronological order (newest first).

**Each Booking Card Shows:**

* 🔖 **Booking Reference** - Unique identifier (e.g., BK-2024-0123)
* 📍 **Route** - Pickup → Dropoff
* 📅 **Service Date** - Date of transfer
* 🕐 **Pickup Time** - Scheduled pickup time
* 🔄 **Return Date/Time** - For round trips only
* 💰 **Final Price** - Total amount
* 🏷️ **Status Badge** - Current booking status (color-coded)

### Status Indicators

Bookings are color-coded for easy identification:

| Status          | Badge Color | Meaning                             |
| --------------- | ----------- | ----------------------------------- |
| **Pending**     | 🟡 Yellow   | Awaiting confirmation from operator |
| **Confirmed**   | 🔵 Blue     | Booking approved and confirmed      |
| **In Progress** | 🟣 Purple   | Transfer currently underway         |
| **Completed**   | 🟢 Green    | Service successfully completed      |
| **Cancelled**   | 🔴 Red      | Booking has been cancelled          |

### Features & Actions

**Refresh List**

* Pull down from the top to refresh
* Fetches latest booking updates
* Shows loading indicator

**View Details**

* Tap any booking card
* Opens full booking details
* See complete information and price breakdown

<figure><img src="../../.gitbook/assets/Mobile App. Order Details.png" alt="" width="375"><figcaption><p>Order Details</p></figcaption></figure>

**Round Trip Badge**

* Special indicator for round trips
* Shows both outbound and return dates
* Easier identification in list

### When You Must Be Logged In

⚠️ **Important:** You must be logged in to view your bookings. If you're logged out:

* Tab will show login prompt
* Tap to navigate to login screen
* After logging in, bookings load automatically

### Empty State

If you have no bookings yet:

* Friendly message displayed
* Prompt to book your first transfer
* Button to go to booking tab

***

## Tab 3: More

Additional features and settings for personalization and system access.

### Menu Items

**Profile** 👤

* View and edit your personal information
* Update contact details
* See your role badge
* [Learn more →](user-profile.md)

**Help & Support** 🆘

* Contact customer support
* _Coming soon_

**About** ℹ️

* App version information
* Credits and acknowledgments
* Terms of service
* Privacy policy

**Dispatcher** 🖥️ _(Admin/Manager only)_

* Admin dashboard access
* Only visible to admin and manager roles
* Launches admin panel interface

### Language Selector

Choose your preferred language:

**Options:**

* 🌐 **System Default** - Uses device language
* 🇬🇧 **English**
* 🇮🇹 **Italiano** (Italian)
* 🇩🇪 **Deutsch** (German)
* 🇫🇷 **Français** (French)
* 🇸🇦 **العربية** (Arabic)

**How to Change:**

1. Tap on current language
2. Select new language from list
3. App immediately updates interface
4. Preference saved for future sessions

**Note:** Arabic includes full RTL (right-to-left) layout support.

***

## Navigation Tips

### Quick Access

**Shortcuts:**

* Tap tab icons to switch instantly
* Currently active tab is highlighted
* Tab state persists when switching

### Gestures

**Supported Actions:**

* Pull down to refresh (My Bookings tab)
* Tap cards to view details
* Swipe to scroll through lists

### Visual Indicators

**Active Tab:**

* Highlighted icon color
* Label shown below icon
* Visual feedback

**Notification Badges:** _(Coming soon)_

* New booking updates
* Important messages
* Action required indicators

***

## Best Practices

### Efficient Booking

1. Check **Popular Routes** first
2. Use them when available
3. Saves time on location entry

### Staying Updated

1. Check **My Bookings** regularly
2. Pull to refresh before travel
3. Monitor status changes

### Profile Management

1. Keep contact info current
2. Set preferred language
3. Review account details periodically

***

## Next Steps

Ready to book a transfer? Head to the [Booking Wizard](booking-wizard.md) guide.

Want to understand your bookings better? Check [My Bookings](my-bookings.md) for detailed information.

Need to update your profile? See [User Profile](user-profile.md).

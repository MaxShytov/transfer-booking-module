# Admin Panel User Guide

Comprehensive guide to the 8Move Transfer Django Admin Panel for operations management and system configuration.

## Overview

The Admin Panel is the central management system for 8Move Transfer operations. Built on Django Admin, it provides a powerful interface for:

- Managing users and permissions
- Processing and tracking bookings
- Configuring vehicle classes
- Setting up pricing rules
- Managing routes
- Monitoring system performance

## Access Requirements

### URL Access

**Admin Panel URL:** `yourdomain.com/admin/`

Example:
- Production: `https://8move-transfer.com/admin/`
- Development: `http://localhost:8000/admin/`

### Authentication

**Required Permissions:**
- Admin or staff user account
- `is_staff` flag enabled
- Appropriate role assigned

**Login Process:**
1. Navigate to `/admin/` URL
2. Enter email (used as username)
3. Enter password
4. Click "Log in"

---

## Who Should Use This Guide?

### Operations Managers
- Process bookings
- Assign drivers
- Manage daily operations
- Monitor booking status

### System Administrators
- Configure pricing rules
- Set up routes and vehicles
- Manage user accounts
- System configuration

### Business Owners
- Review performance metrics
- Configure pricing strategies
- Monitor revenue
- Strategic decisions

---

## Main Admin Sections

The admin panel is organized into logical sections:

### 1. [User Management](user-management.md)
**Admin → Accounts → Users**
- Create and manage user accounts
- Assign roles and permissions
- Configure language preferences
- Track user activity

### 2. [Booking Management](booking-management.md)
**Admin → Bookings → Bookings**
- View all bookings
- Update booking status
- Process payment information
- Track service delivery

### 3. [Vehicle Configuration](vehicle-configuration.md)
**Admin → Vehicles**
- Vehicle Classes
- Vehicle Class Requirements
- Capacity management

### 4. [Pricing Setup](pricing-setup.md)
**Admin → Pricing**
- Seasonal Multipliers
- Passenger Multipliers
- Time Multipliers
- Extra Fees
- Round Trip Discounts

### 5. [Route Management](route-management.md)
**Admin → Routes**
- Fixed Routes
- Distance Pricing Rules

---

## Quick Navigation

### Admin Home Dashboard

When you first log in, you see:

**Main Sections:**
- Recent Actions
- Available Models (organized by app)
- Search functionality
- Filters sidebar

**Quick Actions:**
- Add new items (+ Add buttons)
- Change existing items (Change links)
- View lists (section names)

### Breadcrumb Navigation

Always visible at top:
- `Home > Section > Model > Item`
- Click any level to navigate back
- Maintains context

### Search & Filters

**Global Search:**
- Top right corner
- Search across models
- Quick access to items

**List Filters:**
- Right sidebar on list views
- Filter by status, date, type
- Multiple filters combinable

---

## User Interface Elements

### List Views

Standard features on all list views:

**Action Selector:**
- Checkbox selection
- Bulk actions dropdown
- "Go" button to execute

**Column Headers:**
- Click to sort
- Ascending/descending toggle
- Multi-column sort capability

**Pagination:**
- Items per page selector
- Page navigation
- Total count display

**Search Box:**
- Model-specific search
- Multiple field search
- Real-time filtering

---

### Detail Views

When editing individual items:

**Form Sections:**
- Collapsible fieldsets
- Required field indicators (*)
- Help text below fields
- Validation messages

**Action Buttons:**
- Save and continue editing
- Save and add another
- Save (return to list)
- Delete (with confirmation)

**Related Objects:**
- Inline editors
- Foreign key selectors
- Many-to-many widgets

---

### Inline Editors

Edit related objects without leaving page:

**Features:**
- Add rows dynamically
- Delete with confirmation
- Reorder (if sortable)
- Validation on save

**Common Uses:**
- Passenger multipliers in vehicle classes
- Multiple seasonal periods
- Time multiplier ranges

---

## Common Actions

### Creating New Items

1. Navigate to model list
2. Click **"Add [Model]"** button
3. Fill required fields (marked with *)
4. Optional: Fill additional fields
5. Click **"Save"** or **"Save and add another"**

### Editing Existing Items

1. Navigate to model list
2. Click item name or "Edit" link
3. Modify fields as needed
4. Click appropriate save button

### Bulk Actions

1. Select items using checkboxes
2. Choose action from dropdown
3. Click "Go"
4. Confirm if prompted
5. View success message

### Filtering Lists

1. Use sidebar filters
2. Click desired filter value
3. Multiple filters combine (AND logic)
4. Clear by clicking "Remove" or breadcrumb

### Searching

1. Enter term in search box
2. Press Enter or click search icon
3. Results filter instantly
4. Clear to view all items

---

## Permissions & Roles

### Role-Based Access

Different roles see different options:

**Admin (Superuser):**
- ✅ All sections
- ✅ All actions
- ✅ User management
- ✅ System configuration

**Manager:**
- ✅ Bookings (full access)
- ✅ Pricing configuration
- ✅ Reports and analytics
- ❌ User management (limited)
- ❌ System settings

**Staff:**
- ✅ Bookings (view/edit)
- ✅ Basic operations
- ❌ Configuration changes
- ❌ User management

### Permission Levels

**Model Permissions:**
- **View** - Can see list and details
- **Add** - Can create new items
- **Change** - Can edit existing items
- **Delete** - Can remove items

---

## Best Practices

### Data Entry

**Required Fields:**
- Always fill required fields first
- Look for asterisk (*) indicators
- Validation errors highlight missing fields

**Data Format:**
- Follow format examples
- Use proper date/time formats
- Enter prices without currency symbols

**Saving:**
- Save frequently
- Use "Save and continue" for complex forms
- Review before final save

### Bulk Operations

**Be Careful With:**
- Bulk delete actions
- Status changes affecting many bookings
- Price updates during peak season

**Always:**
- Double-check selections
- Read confirmation prompts
- Have backups before major changes

### Search & Filter

**Efficient Filtering:**
- Use specific filters first
- Combine multiple filters
- Save common filter combinations (browser bookmark)

**Search Tips:**
- Use partial matches
- Try different spellings
- Check multiple fields

---

## Security Considerations

### Account Security

**Password Requirements:**
- Minimum 8 characters
- Mix of letters and numbers
- Regular password changes
- No password sharing

### Access Control

**Best Practices:**
- Logout when leaving desk
- Don't share login credentials
- Use appropriate role levels
- Report suspicious activity

### Data Protection

**GDPR/FADP Compliance:**
- Access only necessary data
- Don't export customer data unnecessarily
- Follow data retention policies
- Secure handling of personal information

---

## System Notifications

### Success Messages

Green banner at top:
- "Saved successfully"
- "Added successfully"
- "[Number] items updated"

### Error Messages

Red banner at top:
- Validation errors
- Permission denied
- Database errors
- Required field messages

### Warning Messages

Yellow banner:
- Potential issues
- Confirmation prompts
- Important notices

---

## Getting Started Checklist

**Initial Setup:**
- [ ] Log in with admin credentials
- [ ] Familiarize with dashboard
- [ ] Review user management section
- [ ] Check existing bookings
- [ ] Verify vehicle configuration
- [ ] Review pricing rules
- [ ] Test creating a booking

**Daily Operations:**
- [ ] Review pending bookings
- [ ] Update booking statuses
- [ ] Check for payment confirmations
- [ ] Monitor system notifications
- [ ] Respond to customer queries

---

## Navigation Guide

### From Dashboard to Common Tasks

**Create New Booking:**
`Home → Bookings → Bookings → Add Booking`

**Confirm Booking:**
`Home → Bookings → Bookings → [Select Booking] → Change Status`

**Add Vehicle Class:**
`Home → Vehicles → Vehicle Classes → Add Vehicle Class`

**Set Seasonal Pricing:**
`Home → Pricing → Seasonal Multipliers → Add Seasonal Multiplier`

**Create Fixed Route:**
`Home → Routes → Fixed Routes → Add Fixed Route`

---

## Detailed Sections

This guide is organized into the following detailed sections:

### Core Operations
- [User Management](user-management.md) - Managing accounts and roles
- [Booking Management](booking-management.md) - Processing transfers
- [Vehicle Configuration](vehicle-configuration.md) - Fleet setup
- [Pricing Setup](pricing-setup.md) - Configure pricing rules
- [Route Management](route-management.md) - Route configuration

### Additional Resources
- [Analytics Dashboard](analytics-dashboard.md) - Business intelligence
- [Best Practices](best-practices.md) - Tips and guidelines
- [Troubleshooting](troubleshooting.md) - Common issues

---

## Support & Resources

### Need Help?

**Documentation:**
- This user guide (comprehensive)
- In-system help text (field-level)
- Django documentation (technical)

**Technical Support:**
- Email: support@trident-software.ch
- Response time: 24-48 hours
- Include screenshots and details

**Training:**
- Available on request
- On-site or remote options
- Role-specific training modules

---

Ready to dive in? Start with [User Management](user-management.md) or [Booking Management](booking-management.md).

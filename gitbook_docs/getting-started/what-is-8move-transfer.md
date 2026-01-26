---
cover: ../.gitbook/assets/banner-background.jpg
coverY: 0
layout: landing
---

# Purpose-Built for Luxury Transport Operators

**Mobile App** • **Admin Panel** • **Analytics Dashboard**

{% hint style="success" %}
✓ Transparent Multi-Factor Pricing Engine

✓ Swiss GDPR/FADP Compliant Engineering

✓ Multi-Language Support (EN/FR/DE/IT/AR + more)
{% endhint %}

[**Contact Sales →**](https://8move.com/contacts/)

---

# What is 8Move Transfer?

8Move Transfer is a comprehensive private transfer booking platform designed to connect customers with professional transfer services. The system handles the complete booking lifecycle from initial reservation to service completion.

## Overview

8Move Transfer provides a modern, user-friendly solution for booking private transfers with transparent pricing and real-time availability. The platform consists of three main components working together seamlessly:

### Mobile Application

A Flutter-based mobile app available for iOS and Android, providing customers with:

- Intuitive booking wizard with 5-step process
- Real-time price calculations
- Multi-language interface (5 languages)
- Booking history and management
- Profile customization
- Flight tracking integration

### Admin Panel

A Django-based management system for operations teams:

- User and role management
- Booking lifecycle management
- Vehicle fleet configuration
- Dynamic pricing engine
- Route management (fixed and distance-based)
- Analytics and reporting

### Analytics Dashboard

A Streamlit-powered business intelligence tool:

- Revenue tracking and trends
- Booking performance metrics
- Vehicle utilization analysis
- Route profitability insights
- Period comparisons

## How It Works

### For Customers

1. **Browse** - Explore popular routes or create custom transfers
2. **Configure** - Select dates, passengers, luggage, and vehicle class
3. **Review** - See transparent pricing breakdown
4. **Book** - Confirm and receive booking reference
5. **Track** - Monitor booking status in real-time

### For Operators

1. **Configure** - Set up routes, vehicles, and pricing rules
2. **Receive** - Get notified of new bookings
3. **Confirm** - Review and approve reservations
4. **Assign** - Allocate drivers and vehicles
5. **Complete** - Mark transfers as completed
6. **Analyze** - Review performance and revenue

## Core Capabilities

### Intelligent Pricing Engine

The system uses a sophisticated multi-factor pricing model:

```
Final Price = (Base × Vehicle × Passengers × Season × Time) + Extras
```

Factors include:
- **Base Price** - Route or distance-based
- **Vehicle Multiplier** - Based on selected vehicle class
- **Passenger Multiplier** - Based on vehicle capacity utilization
- **Seasonal Multiplier** - Peak/off-peak pricing
- **Time Multiplier** - Early morning, late night, rush hour
- **Extra Fees** - Child seats, luggage, special services
- **Round Trip Discount** - Savings for return bookings

### Geospatial Route Matching

Uses PostGIS and Haversine formula to:
- Match customer locations to fixed routes within radius tolerance
- Calculate accurate distances for distance-based pricing
- Provide visual route previews on interactive maps
- Optimize pickup and dropoff locations

### Multi-tier Vehicle System

Supports flexible vehicle classification:
- Economy, Comfort, Business tiers
- Minivan and Minibus options
- Automatic capacity-based filtering
- Per-class pricing multipliers
- Passenger and luggage capacity rules

### Flight Integration

Monitors flight arrivals to automatically adjust pickup times for:
- Airport transfers
- Flight delays
- Early arrivals
- Optimal timing

## Target Markets

8Move Transfer is designed for:

### Transfer Service Operators
- Private taxi companies
- Limousine services
- Airport shuttle operators
- Hotel transfer services
- Tour operators

### Geographic Focus
- Tourist destinations
- Airport transfer corridors
- Urban to resort routes
- Intercity connections

### Customer Segments
- Business travelers
- Tourists and vacationers
- Airport passengers
- Hotel guests
- Event attendees

## Technical Architecture

### Frontend
- **Framework**: Flutter
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Maps**: Flutter Map with OpenStreetMap
- **Localization**: 5 languages

### Backend
- **Framework**: Django 4.x
- **API**: Django REST Framework
- **Database**: PostgreSQL 14+
- **Geospatial**: PostGIS extension
- **Admin**: Django Admin (customized)

### Infrastructure
- **Deployment**: Azure Cloud / Docker
- **Storage**: MinIO / Azure Blob
- **Analytics**: Streamlit
- **Monitoring**: Built-in Django logging

## Compliance & Standards

### Data Protection
- GDPR compliant
- Swiss FADP compliant
- Secure data storage
- Privacy by design

### Child Safety
- Swiss child seat regulations
- Automatic seat requirement detection
- Age-appropriate safety measures

### Accessibility
- Multi-language support
- Clear visual hierarchy
- Intuitive navigation
- RTL support for Arabic

## Deployment Options

8Move Transfer can be deployed in several configurations:

### Cloud-hosted SaaS
- Fully managed by Trident Software
- Regular updates and maintenance
- Scalable infrastructure
- Multi-tenant architecture

### Self-hosted
- Deploy on your infrastructure
- Full control and customization
- On-premise or private cloud
- White-label options

### Hybrid
- Mobile app as SaaS
- Backend self-hosted
- Integration flexibility

## What Makes 8Move Transfer Different?

### Transparent Pricing
Unlike competitors with hidden fees, 8Move shows complete price breakdown before booking confirmation.

### Swiss Engineering
Built with Swiss precision, focusing on reliability, security, and data protection compliance.

### Operator-Friendly
Designed by industry professionals who understand transfer service operations.

### Flexible Pricing Model
Hybrid approach supports both fixed popular routes and dynamic distance-based pricing.

### Multi-language Native
Not just translated UI, but culturally adapted experience for each language.

## Use Cases

### Airport Transfers
- Flight tracking integration
- Meet & greet services
- Luggage assistance
- Early/late flight handling

### Hotel Shuttles
- Guest booking integration
- Recurring routes
- Batch bookings
- Corporate accounts

### Event Transportation
- Conference shuttles
- Wedding transfers
- Group bookings
- Multiple stops

### Tourism
- Resort transfers
- Sightseeing trips
- Multi-day packages
- Special requests

## Roadmap

Future enhancements planned:

- Driver mobile application
- Real-time GPS tracking
- In-app messaging
- Payment gateway integration (Stripe)
- Corporate booking portal
- Loyalty programs
- Affiliate system
- Advanced reporting

---

Ready to explore the system? Continue with [Key Features](key-features.md) or jump into the [Mobile App Guide](../user-guides/mobile-app/).

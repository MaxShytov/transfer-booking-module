# Demo Plan: 8move Transfer Booking System

**Client:** Marco Cutolo (Sardinia Airport Transfers)
**Date:** January 2026

---

## Opening Script

> "Marco, thank you for reaching out.
>
> We're a custom software development company, and we have a platform called **8move** — a logistics and transfer management system.
>
> You requested a WordPress plugin. We don't have a ready-made plugin, but we have something better — a complete system that we developed for a hotel chain client.
>
> Based on this system, we can either:
> 1. Create a plugin for your WordPress website, or
> 2. Build a full solution with a web platform and mobile apps for your customers.
>
> The mobile app option often provides additional advantages — you can send push notifications to customers, for example, when they're planning their next visit to your region. They can also make additional bookings while they're staying in Sardinia, directly from their phone.
>
> I've prepared test data for Sardinia to show you how the system works.
>
> Let me walk you through:
> - **Popular Routes** — your most frequently requested routes
> - **Live Pricing** — real-time price calculation based on your parameters
> - **Booking Flow** — streamlined process with only essential fields
> - **Admin Panel** — full control over pricing management
>
> Let me show you a demo today and discuss how we can adapt this solution to your specific needs."

---

## Part 1: Mobile App — Customer Booking Flow (7-10 min)

### 1.1 Home Screen — Popular Routes
- Open the Flutter app on device/emulator
- Show the **Home screen** with popular Sardinia routes:
  - Cagliari Airport → City Center
  - Cagliari Airport → Villasimius
  - Olbia Airport → Porto Cervo
  - Olbia Airport → Costa Smeralda
- Explain: *"These are your most requested routes. Customers tap once and go straight to booking."*

### 1.2 Booking Flow — Simple Transfer
**Scenario:** Tourist arriving at Cagliari Airport, going to Villasimius

1. **Select Route** — tap "Cagliari Airport → Villasimius"
2. **Enter Details:**
   - Date: July 15
   - Time: 14:30
   - Passengers: 3 adults
   - Luggage: 3 large bags
3. **Show Map Preview** — route visualization with distance and estimated time
4. **Select Vehicle:**
   - Show available vehicle classes (Economy Sedan, Business Sedan, Minivan)
   - Point out capacity indicators
   - Select "Economy Sedan"
5. **Show Price Calculation:**
   - Base price: €80
   - Summer season: +30%
   - **Total: €104**
6. **Contact Info** — simple form (name, phone, email)
7. **Confirmation Screen** — booking summary

### 1.3 Booking Flow — Group with Extras
**Scenario:** Family group, peak season, night arrival

1. **Same route** but change parameters:
   - Date: August 15 (Ferragosto!)
   - Time: 23:00 (night flight)
   - Passengers: 6 (2 adults + 4 children)
   - Add: Child seat
2. **Show automatic upgrade:**
   - *"System automatically suggests Minivan because 6 passengers don't fit in a sedan"*
3. **Select Luxury Minivan** — upgrade option
4. **Show price breakdown:**
   - Base: €80
   - Luxury Minivan: ×2.20
   - Passengers (6): ×1.10
   - Ferragosto peak: ×1.40
   - Night transfer: ×1.20
   - Child seat: +€10
   - **Total: ~€335**
5. Explain: *"All pricing rules are configurable from admin panel"*

### 1.4 Custom Address Booking
- Show how customer can enter any pickup/dropoff address
- Demonstrate address autocomplete (Google Places)
- Explain: *"For routes not in your popular list, we calculate by distance"*

---

## Part 2: Admin Panel — Business Management (7-10 min)

### 2.1 Login & Overview
- Open http://localhost:8000/admin/
- Login as admin
- Explain: *"This is where you manage everything — routes, prices, vehicles, bookings"*

### 2.2 Routes Management
**Show Fixed Routes section:**
- Display all 7 Sardinia routes
- Open one route (Cagliari → Villasimius):
  - Base price: €80
  - Distance: ~45km
  - Coordinates for automatic matching
- Explain: *"When customer selects addresses near these points, system automatically applies fixed pricing"*
- Demonstrate: *"You can easily add new routes or adjust prices"*

### 2.3 Vehicle Classes
**Show Vehicle Classes section:**
- 7 classes from Economy to Large Minibus
- For each class show:
  - Price multiplier (1.00 → 3.50)
  - Passenger capacity
  - Luggage capacity
- Explain: *"If you partner with a luxury car service, just add a new class"*

### 2.4 Dynamic Pricing Rules
**Show pricing flexibility:**

1. **Seasonal Multipliers:**
   - Low Season: ×1.00
   - Shoulder: ×1.10
   - High Summer: ×1.30
   - Ferragosto (Aug 10-20): ×1.40
   - Christmas: ×1.25
   - *"You control when peak pricing applies"*

2. **Time Multipliers:**
   - Standard (06:00-22:00): ×1.00
   - Night (22:00-06:00): ×1.20
   - *"Night transfers cost 20% more by default"*

3. **Extra Services:**
   - Child seat: €10
   - Pet transport: €20-35
   - Additional stop: €15
   - Meet & Greet: €15
   - *"Add any service your customers need"*

### 2.5 Bookings Management
- Show bookings list (if any test bookings exist)
- Demonstrate status workflow: Pending → Confirmed → Completed
- Explain: *"You see all bookings in real-time, can filter by date, status, route"*

---

## Part 3: Key Benefits Summary (2-3 min)

### For Your Customers:
- Book transfer in under 2 minutes
- See exact price before booking
- Push notifications for reminders
- Easy rebooking for return trips

### For Your Business:
- Full control over pricing
- No technical knowledge needed to adjust prices
- Real-time booking visibility
- Scalable — works for 10 or 10,000 bookings

### Options We Discussed:
1. **WordPress Plugin** — embed booking widget on your existing site
2. **Full Solution** — web platform + iOS/Android apps

---

## Questions for Marco

1. Are these route prices accurate for your business?
2. Any additional routes to add? (Alghero Airport?)
3. What extra services do your customers typically request?
4. Do you have existing driver management software, or should we include that?
5. Payment processing — do you need online payments or cash only?

---

## Technical Notes (don't show, just reference if asked)

### Demo Credentials
- Admin: `max@trident.software` / `Password123`
- Test Customer: `cartuzssc@gmail.com`

### Pre-Demo Checklist
- [ ] Backend running (`./start.sh`)
- [ ] Flutter app running on device/emulator
- [ ] Test data loaded (7 routes, 7 vehicle classes, pricing rules)
- [ ] Network connection stable

---

## 📊 Seed Data Summary

| Категория | Количество | Статус |
|-----------|------------|--------|
| Vehicle Classes | 7 | ✅ |
| Vehicle Requirements | 8 | ✅ |
| Fixed Routes (Sardinia) | 7 | ✅ |
| Distance Pricing Rules | 4 | ✅ |
| Seasonal Multipliers | 6 | ✅ |
| Passenger Multipliers | 16 (per vehicle class) | ✅ |
| Time Multipliers | 2 | ✅ |
| Extra Fees | 9 | ✅ |

---

## 🗄️ Описание таблиц базы данных

### Основные таблицы

#### 1. `vehicle_classes` - Классы автомобилей
**Назначение:** Хранит типы транспортных средств с ценовыми множителями и характеристиками вместимости.

| Поле | Описание |
|------|----------|
| `class_name` | Название класса (Economy Sedan, Business Sedan, etc.) |
| `class_code` | Уникальный код для API (economy_sedan, business_sedan) |
| `tier_level` | Уровень класса 1-7 (для валидации upgrade/downgrade) |
| `price_multiplier` | Множитель цены (1.00 - 3.50) |
| `max_passengers` | Максимум пассажиров |
| `max_large_luggage` | Максимум больших сумок |
| `max_small_luggage` | Максимум ручной клади |
| `example_vehicles` | Примеры авто (Mercedes E-Class, BMW 5 Series) |

**Бизнес-логика:** Клиент выбирает класс. Upgrade разрешён, downgrade запрещён.

---

#### 2. `vehicle_class_requirements` - Требования к классу
**Назначение:** Определяет минимальный класс авто на основе количества пассажиров или багажа.

| Поле | Описание |
|------|----------|
| `min_value` / `max_value` | Диапазон (пассажиров или багажа) |
| `min_vehicle_tier` | Минимальный требуемый tier |
| `required_for` | Тип: 'passengers' или 'luggage' |
| `validation_message` | Сообщение об ошибке для UI |

**Пример:** 5-7 пассажиров → минимум Tier 4 (Minivan)

---

#### 3. `fixed_routes` - Фиксированные маршруты
**Назначение:** Популярные маршруты с заранее установленными ценами и геолокацией для автоматического matching.

| Поле | Описание |
|------|----------|
| `route_name` | Название маршрута |
| `pickup_address` / `dropoff_address` | Адреса |
| `pickup_lat` / `pickup_lng` | Координаты точки отправления |
| `dropoff_lat` / `dropoff_lng` | Координаты точки назначения |
| `pickup_radius_km` / `dropoff_radius_km` | Радиус для геоматчинга |
| `pickup_type` / `dropoff_type` | Тип локации (airport, city_center, resort) |
| `base_price` | Базовая цена маршрута |
| `distance_km` | Расстояние в км |

**Бизнес-логика:** Система проверяет, попадают ли координаты клиента в радиус pickup И dropoff. Если да → используется фиксированная цена.

> 💡 **Возможная доработка (Phase 2):** Текущий подход с радиусом покрывает ~90% случаев. Для более точного определения сложных зон (например, нестандартные границы города или курорта) можно перейти на Polygon geomatching с использованием PostGIS/GeoDjango.

---

#### 4. `distance_pricing_rules` - Правила расчёта по дистанции
**Назначение:** Fallback pricing для маршрутов, не попадающих в fixed_routes.

| Поле | Описание |
|------|----------|
| `rule_name` | Название правила |
| `base_rate` | Базовая ставка (€) |
| `price_per_km` | Цена за км |
| `min_distance_km` / `max_distance_km` | Диапазон применения |
| `priority` | Приоритет (меньше = выше) |

**Формула:** `Цена = base_rate + (distance_km × price_per_km)`

---

#### 5. `seasonal_multipliers` - Сезонные коэффициенты
**Назначение:** Динамическое ценообразование в зависимости от сезона.

| Поле | Описание |
|------|----------|
| `season_name` | Название сезона (High Summer, Ferragosto) |
| `start_date` / `end_date` | Период действия |
| `multiplier` | Множитель (1.00 - 1.40) |
| `priority` | Приоритет при пересечении сезонов |
| `year_recurring` | Повторяется ежегодно |

**Пример:** Ferragosto (10-20 августа) → ×1.40

---

#### 6. `passenger_multipliers` - Множители по пассажирам
**Назначение:** Наценка за "заполненность" автомобиля. Привязана к конкретному классу авто.

| Поле | Описание |
|------|----------|
| `vehicle_class` | FK на класс автомобиля |
| `min_passengers` / `max_passengers` | Диапазон пассажиров для данного класса |
| `multiplier` | Множитель (1.00 - 1.15) |
| `description` | Описание (Comfortable, Full capacity) |

**Логика:** Множитель зависит от того, насколько "полон" автомобиль:
- Sedan (max 4): 1-3 pax = ×1.00, 4 pax = ×1.05
- Minivan (max 7): 1-5 pax = ×1.00, 6-7 pax = ×1.10
- Minibus (max 16): 1-10 pax = ×1.00, 11-14 = ×1.10, 15-16 = ×1.15

> 💡 **Inline редактор:** Множители редактируются прямо в форме Vehicle Class в Admin Panel.

---

#### 7. `time_multipliers` - Множители по времени
**Назначение:** Наценка за неудобное время (ночные трансферы).

| Поле | Описание |
|------|----------|
| `time_name` | Название периода (Late Night, Standard) |
| `start_time` / `end_time` | Временной диапазон |
| `multiplier` | Множитель (1.00 - 1.20) |

**Пример:** 22:00 - 06:00 → ×1.20

---

#### 8. `extra_fees` - Дополнительные услуги
**Назначение:** Опциональные платные услуги.

| Поле | Описание |
|------|----------|
| `fee_name` | Название услуги |
| `fee_code` | Код для API |
| `fee_type` | Тип: 'flat' или 'per_item' |
| `amount` | Сумма (€) |
| `is_optional` | Опциональная услуга |
| `display_order` | Порядок отображения |

**Примеры:** Child Seat (€10), Pet Transport (€20-35), Additional Stop (€15)

---

#### 9. `bookings` - Бронирования
**Назначение:** Основная таблица с данными о заказах и расчётом цены.

| Группа полей | Описание |
|--------------|----------|
| **Маршрут** | pickup/dropoff адреса, координаты, дата, время |
| **Пассажиры** | количество, багаж, дети |
| **Транспорт** | selected_vehicle_class, actual_vehicle_class (для upgrades) |
| **Цена** | base_price, все multipliers, subtotal, extra_fees, final_price |
| **Клиент** | имя, телефон, email |
| **Статус** | pending → confirmed → completed / cancelled |
| **Оплата** | payment_status, payment_method, stripe_id |

---

### 📐 Формула расчёта цены

```
Final Price = (Base × Vehicle_Class × Passengers × Season × Time) + Extra_Fees
```

**Пример:**
```
€80 (base) × 1.40 (Minivan) × 1.10 (6 pax) × 1.30 (Summer) × 1.20 (Night)
= €192.19 + €10 (child seat)
= €202.19
```

---

**Общее время демо: ~20 минут**

---

*Документ создан: January 19, 2026*
*Версия: 1.0*

# Transfer Booking Module

**Sardinia Airport Transfer** - Custom booking and pricing system for airport transfers in Sardinia, Italy.

## Quick Start

```bash
# Clone and enter directory
cd transfer-booking-module

# Run the startup script (handles everything)
./start.sh
```

The script will:
1. Create virtual environment (if needed)
2. Start Docker containers (PostgreSQL + Redis)
3. Install Python dependencies
4. Apply database migrations
5. Create superuser (if needed)
6. Start Django server at http://127.0.0.1:8000

## Access

| Service | URL | Credentials |
|---------|-----|-------------|
| Admin Panel | http://127.0.0.1:8000/admin | max@trident.software / Password123 |
| API | http://127.0.0.1:8000/api/ | - |
| API Docs | http://127.0.0.1:8000/api/docs/ | - |

## Project Structure

```
transfer-booking-module/
├── backend/                    # Django backend
│   ├── apps/
│   │   ├── core/              # Base models, utilities
│   │   ├── accounts/          # User authentication
│   │   ├── vehicles/          # Vehicle classes
│   │   ├── routes/            # Fixed routes, distance pricing
│   │   ├── pricing/           # Multipliers, extra fees
│   │   └── bookings/          # Booking management
│   ├── config/                # Django settings
│   ├── docker-compose.yml     # PostgreSQL + Redis
│   ├── requirements.txt       # Python dependencies
│   └── manage.py
├── docs/                       # Documentation
│   ├── initial_requirements/  # Business requirements, DB schema
│   ├── current_tasks/         # Active sprint tasks
│   ├── completed_tasks/       # Archived tasks
│   ├── architecture/          # System design docs
│   └── meeting_notes/         # Client meeting notes
├── frontend/                   # Flutter Web (Phase 2)
├── deploy/                     # Deployment configs
├── start.sh                    # One-command startup
└── README.md
```

## Tech Stack

**Backend:**
- Python 3.12
- Django 5.0.7
- Django REST Framework
- PostgreSQL 15.8
- Redis 7
- JWT Authentication

**Frontend (Phase 2):**
- Flutter Web
- Material Design 3

## Development Commands

```bash
# Activate virtual environment
source venv/bin/activate

# Run development server
cd backend && python manage.py runserver 0.0.0.0:8000

# Create migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Seed data
python manage.py seed_vehicles
python manage.py seed_routes
python manage.py seed_pricing

# Run tests
python manage.py test

# Django shell
python manage.py shell
```

## Docker Commands

```bash
cd backend

# Start services
docker compose up -d

# Stop services
docker compose down

# View logs
docker compose logs -f

# Connect to PostgreSQL
docker compose exec db psql -U transfer_user -d transfer_booking

# Connect to Redis
docker compose exec redis redis-cli
```

## Database

**PostgreSQL:**
- Host: localhost
- Port: 5433
- Database: transfer_booking
- User: transfer_user
- Password: transfer_dev_password

**Redis:**
- Host: localhost
- Port: 6380

## Environment Variables

Copy `.env.example` to `.env` in the backend directory:

```bash
cp backend/.env.example backend/.env
```

Key variables:
- `DEBUG` - Enable debug mode (True/False)
- `SECRET_KEY` - Django secret key
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection string

## API Endpoints (Coming Soon)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/auth/login/ | User login (JWT) |
| POST | /api/auth/register/ | User registration |
| GET | /api/vehicles/ | List vehicle classes |
| GET | /api/routes/ | List fixed routes |
| POST | /api/bookings/calculate/ | Calculate price |
| POST | /api/bookings/ | Create booking |
| GET | /api/bookings/{id}/ | Get booking details |

## Pricing Logic

**Formula:**
```
Final Price = (Base × Vehicle × Passengers × Season × Time) + Extra Fees
```

**Multipliers:**
- **Vehicle Class:** 1.00 (Economy) → 3.50 (Large Minibus)
- **Passengers:** 1.00 (1-3 pax) → 1.30 (26+ pax)
- **Season:** 1.00 (Low) → 1.40 (Ferragosto)
- **Time:** 1.00 (Day) → 1.20 (Night 22:00-06:00)

## Sales Dashboard (Streamlit)

Интерактивный дашборд для анализа продаж на базе Streamlit.

**Запуск:**
```bash
# Активировать виртуальное окружение
source venv/bin/activate

# Установить зависимости (если ещё не установлены)
pip install -r backend/requirements.txt

# Запустить дашборд
streamlit run backend/dashboard/sales_report.py
```

Дашборд откроется в браузере: http://localhost:8501

**Возможности:**
- Ключевые метрики: выручка, количество бронирований, средний чек
- Динамика выручки по месяцам
- Анализ по статусам бронирований и оплат
- Распределение по классам автомобилей и маршрутам
- Фильтрация по периоду, статусу, классу авто
- Экспорт данных в CSV

## Documentation

- [Database Schema](docs/initial_requirements/database_schema.md)
- [Business Logic](docs/initial_requirements/transfer-pricing-business-logic.md)
- [Architecture](docs/architecture/transfer-booking-module-architecture.md)
- [Sprint Tasks](docs/current_tasks/sprint_1_foundation_setup.md)

## Team

**Developer:** Maksym Shytov (Trident Software Sàrl)
**Client:** Marco Cutolo (Sardinia Airport Transfer)

## License

Proprietary - All rights reserved.

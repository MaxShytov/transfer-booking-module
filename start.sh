#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Transfer Booking Module - Development Startup Script
# ============================================================================

# 1) Project paths
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
VENV_DIR="$ROOT_DIR/venv"

echo "→ Project root: $ROOT_DIR"

# 2) Create virtual environment if it doesn't exist
if [[ ! -d "$VENV_DIR" ]]; then
    echo "→ Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# 3) Activate virtual environment
echo "→ Activating virtual environment..."
# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"

# 4) Check Docker daemon
echo "→ Checking Docker daemon..."
if ! command -v docker >/dev/null 2>&1; then
  echo "✖ Docker CLI not found. Install Docker Desktop: https://docs.docker.com/desktop/"
  exit 1
fi

# Wait for Docker daemon (up to 30 seconds)
tries=0
until docker info >/dev/null 2>&1; do
  tries=$((tries+1))
  if [ $tries -gt 30 ]; then
    echo "✖ Cannot connect to Docker. Start Docker Desktop and try again."
    echo "   macOS: open -a Docker"
    exit 1
  fi
  sleep 1
done

# 5) Start Docker containers (PostgreSQL, Redis)
echo "→ Starting Docker containers (PostgreSQL, Redis)..."
cd "$BACKEND_DIR"
docker compose up -d

# Wait for PostgreSQL to be ready
echo "→ Waiting for PostgreSQL to be ready..."
until docker compose exec -T db pg_isready -U transfer_user -d transfer_booking >/dev/null 2>&1; do
  echo "   PostgreSQL is starting up..."
  sleep 2
done
echo "✓ PostgreSQL is ready!"

# 6) Install Python dependencies
echo "→ Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# 7) Create .env file if it doesn't exist
if [[ ! -f "$BACKEND_DIR/.env" ]]; then
    echo "→ Creating .env file from .env.example..."
    cp "$BACKEND_DIR/.env.example" "$BACKEND_DIR/.env"
    echo "✓ .env file created. Please review and update if needed."
fi

# 8) Apply Django migrations
echo "→ Applying Django migrations..."
python manage.py makemigrations
python manage.py migrate

# 9) Create superuser if it doesn't exist
echo "→ Checking for superuser..."
SUPERUSER_EXISTS=$(python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); print(User.objects.filter(is_superuser=True).exists())" 2>/dev/null || echo "False")

if [[ "$SUPERUSER_EXISTS" == "False" ]]; then
    echo "→ Creating development superuser..."
    DJANGO_SUPERUSER_PASSWORD=admin123 python manage.py createsuperuser \
        --noinput \
        --username admin \
        --email admin@transfer-booking.dev 2>/dev/null || echo "   (superuser may already exist)"
    echo "✓ Superuser created: admin / admin123"
else
    echo "✓ Superuser already exists"
fi

# 11) Run tests if --test flag is provided
if [[ "${1:-}" == "--test" ]]; then
    echo ""
    echo "→ Running Django tests..."
    python manage.py test --verbosity=2
    
    echo ""
    echo "→ Running Flutter tests..."
    cd "$ROOT_DIR/frontend"
    flutter test --reporter=compact
    
    exit 0
fi

# 12) Collect static files (for production-like testing)
if [[ "${1:-}" == "--collectstatic" ]]; then
    echo "→ Collecting static files..."
    python manage.py collectstatic --noinput
fi

# 13) Print useful information
echo ""
echo "============================================================================"
echo "✓ Transfer Booking Module - Development Server Ready!"
echo "============================================================================"
echo ""
echo "  Backend API:     http://127.0.0.1:8000"
echo "  Admin Panel:     http://127.0.0.1:8000/admin"
echo "  API Docs:        http://127.0.0.1:8000/api/docs"
echo ""
echo "  Admin Login:     admin"
echo "  Admin Password:  admin123"
echo ""
echo "  PostgreSQL:      localhost:5433"
echo "  Database:        transfer_booking"
echo "  User:            transfer_user"
echo ""
echo "  Redis:           localhost:6380"
echo ""
echo "============================================================================"
echo ""

# 14) Start Django development server
echo "→ Starting Django development server..."
exec python manage.py runserver 0.0.0.0:8000

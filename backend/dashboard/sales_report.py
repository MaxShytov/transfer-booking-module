"""
Sales Report Dashboard for Transfer Booking Module
Run with: streamlit run backend/dashboard/sales_report.py
"""

import os
import sys
from datetime import datetime, timedelta
from pathlib import Path

import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

# Setup Django environment
backend_path = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(backend_path))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

import django
django.setup()

from django.db.models import Sum, Count, Avg, F
from django.db.models.functions import TruncMonth, TruncWeek
from apps.bookings.models import Booking


# Page configuration
st.set_page_config(
    page_title="Sales Report - Transfer Bookings",
    page_icon="📊",
    layout="wide",
)

st.title("📊 Отчёт о продажах")
st.markdown("Анализ бронирований трансферов за прошлый год")


@st.cache_data(ttl=300)  # Cache for 5 minutes
def load_bookings_data(start_date: datetime, end_date: datetime) -> pd.DataFrame:
    """Load bookings data from Django ORM into pandas DataFrame."""
    bookings = Booking.objects.filter(
        created_at__gte=start_date,
        created_at__lte=end_date,
    ).select_related(
        'selected_vehicle_class',
        'fixed_route',
    ).values(
        'id',
        'booking_reference',
        'created_at',
        'service_date',
        'status',
        'payment_status',
        'final_price',
        'base_price',
        'subtotal',
        'extra_fees_total',
        'currency',
        'num_passengers',
        'is_round_trip',
        'pricing_type',
        'selected_vehicle_class__class_name',
        'fixed_route__route_name',
        'customer_email',
    )

    df = pd.DataFrame(list(bookings))

    if df.empty:
        return df

    # Convert timestamps
    df['created_at'] = pd.to_datetime(df['created_at'])
    df['service_date'] = pd.to_datetime(df['service_date'])
    df['month'] = df['created_at'].dt.to_period('M').astype(str)
    df['week'] = df['created_at'].dt.to_period('W').astype(str)
    df['day_of_week'] = df['created_at'].dt.day_name()

    # Rename columns for readability
    df = df.rename(columns={
        'selected_vehicle_class__class_name': 'vehicle_class',
        'fixed_route__route_name': 'route_name',
    })

    return df


def get_status_color(status: str) -> str:
    """Return color for booking status."""
    colors = {
        'pending': '#FFA500',
        'confirmed': '#3498DB',
        'in_progress': '#9B59B6',
        'completed': '#2ECC71',
        'cancelled': '#E74C3C',
    }
    return colors.get(status, '#95A5A6')


def get_payment_status_color(status: str) -> str:
    """Return color for payment status."""
    colors = {
        'unpaid': '#E74C3C',
        'deposit_paid': '#F39C12',
        'fully_paid': '#2ECC71',
        'refunded': '#95A5A6',
    }
    return colors.get(status, '#95A5A6')


# Sidebar filters
st.sidebar.header("🔍 Фильтры")

# Date range - default to last year
today = datetime.now()
last_year_start = today.replace(year=today.year - 1, month=1, day=1)
last_year_end = today.replace(year=today.year - 1, month=12, day=31)

date_range = st.sidebar.date_input(
    "Период",
    value=(last_year_start.date(), last_year_end.date()),
    max_value=today.date(),
)

if len(date_range) == 2:
    start_date, end_date = date_range
    start_date = datetime.combine(start_date, datetime.min.time())
    end_date = datetime.combine(end_date, datetime.max.time())
else:
    start_date = datetime.combine(date_range[0], datetime.min.time())
    end_date = datetime.combine(date_range[0], datetime.max.time())

# Load data
df = load_bookings_data(start_date, end_date)

if df.empty:
    st.warning("⚠️ Нет данных за выбранный период")
    st.stop()

# Status filter
all_statuses = df['status'].unique().tolist()
selected_statuses = st.sidebar.multiselect(
    "Статус бронирования",
    options=all_statuses,
    default=all_statuses,
)

# Payment status filter
all_payment_statuses = df['payment_status'].unique().tolist()
selected_payment_statuses = st.sidebar.multiselect(
    "Статус оплаты",
    options=all_payment_statuses,
    default=all_payment_statuses,
)

# Vehicle class filter
all_vehicle_classes = df['vehicle_class'].dropna().unique().tolist()
selected_vehicle_classes = st.sidebar.multiselect(
    "Класс автомобиля",
    options=all_vehicle_classes,
    default=all_vehicle_classes,
)

# Apply filters
filtered_df = df[
    (df['status'].isin(selected_statuses)) &
    (df['payment_status'].isin(selected_payment_statuses)) &
    (df['vehicle_class'].isin(selected_vehicle_classes) | df['vehicle_class'].isna())
]

if filtered_df.empty:
    st.warning("⚠️ Нет данных по выбранным фильтрам")
    st.stop()


# === KPI METRICS ===
st.header("📈 Ключевые показатели")

# Calculate metrics
total_revenue = filtered_df['final_price'].sum()
total_bookings = len(filtered_df)
avg_check = filtered_df['final_price'].mean()
completed_bookings = len(filtered_df[filtered_df['status'] == 'completed'])
cancelled_bookings = len(filtered_df[filtered_df['status'] == 'cancelled'])
conversion_rate = (completed_bookings / total_bookings * 100) if total_bookings > 0 else 0

# Calculate previous period for comparison
period_days = (end_date - start_date).days
prev_start = start_date - timedelta(days=period_days)
prev_end = start_date - timedelta(days=1)
prev_df = load_bookings_data(prev_start, prev_end)

if not prev_df.empty:
    prev_revenue = prev_df['final_price'].sum()
    prev_bookings = len(prev_df)
    prev_avg_check = prev_df['final_price'].mean()

    revenue_delta = ((total_revenue - prev_revenue) / prev_revenue * 100) if prev_revenue > 0 else 0
    bookings_delta = ((total_bookings - prev_bookings) / prev_bookings * 100) if prev_bookings > 0 else 0
    avg_check_delta = ((avg_check - prev_avg_check) / prev_avg_check * 100) if prev_avg_check > 0 else 0
else:
    revenue_delta = bookings_delta = avg_check_delta = None

col1, col2, col3, col4 = st.columns(4)

with col1:
    st.metric(
        label="💰 Общая выручка",
        value=f"€{total_revenue:,.2f}",
        delta=f"{revenue_delta:+.1f}%" if revenue_delta is not None else None,
    )

with col2:
    st.metric(
        label="📋 Всего бронирований",
        value=f"{total_bookings:,}",
        delta=f"{bookings_delta:+.1f}%" if bookings_delta is not None else None,
    )

with col3:
    st.metric(
        label="🧾 Средний чек",
        value=f"€{avg_check:,.2f}",
        delta=f"{avg_check_delta:+.1f}%" if avg_check_delta is not None else None,
    )

with col4:
    st.metric(
        label="✅ Выполнено",
        value=f"{completed_bookings:,}",
        delta=f"{conversion_rate:.1f}% конверсия",
    )


# === REVENUE CHART ===
st.header("📅 Динамика выручки по месяцам")

monthly_data = filtered_df.groupby('month').agg({
    'final_price': 'sum',
    'id': 'count',
}).reset_index()
monthly_data.columns = ['Месяц', 'Выручка', 'Бронирований']

fig_revenue = go.Figure()
fig_revenue.add_trace(go.Bar(
    x=monthly_data['Месяц'],
    y=monthly_data['Выручка'],
    name='Выручка',
    marker_color='#3498DB',
    yaxis='y',
))
fig_revenue.add_trace(go.Scatter(
    x=monthly_data['Месяц'],
    y=monthly_data['Бронирований'],
    name='Кол-во бронирований',
    mode='lines+markers',
    marker_color='#E74C3C',
    yaxis='y2',
))

fig_revenue.update_layout(
    yaxis=dict(title='Выручка (€)', side='left'),
    yaxis2=dict(title='Бронирований', overlaying='y', side='right'),
    legend=dict(orientation='h', yanchor='bottom', y=1.02),
    height=400,
)

st.plotly_chart(fig_revenue, use_container_width=True)


# === TWO COLUMN CHARTS ===
col_left, col_right = st.columns(2)

with col_left:
    st.subheader("📊 Статусы бронирований")
    status_data = filtered_df['status'].value_counts().reset_index()
    status_data.columns = ['Статус', 'Количество']
    status_data['Цвет'] = status_data['Статус'].apply(get_status_color)

    fig_status = px.pie(
        status_data,
        values='Количество',
        names='Статус',
        color='Статус',
        color_discrete_map={row['Статус']: row['Цвет'] for _, row in status_data.iterrows()},
        hole=0.4,
    )
    fig_status.update_layout(height=350)
    st.plotly_chart(fig_status, use_container_width=True)

with col_right:
    st.subheader("💳 Статусы оплаты")
    payment_data = filtered_df['payment_status'].value_counts().reset_index()
    payment_data.columns = ['Статус', 'Количество']
    payment_data['Цвет'] = payment_data['Статус'].apply(get_payment_status_color)

    fig_payment = px.pie(
        payment_data,
        values='Количество',
        names='Статус',
        color='Статус',
        color_discrete_map={row['Статус']: row['Цвет'] for _, row in payment_data.iterrows()},
        hole=0.4,
    )
    fig_payment.update_layout(height=350)
    st.plotly_chart(fig_payment, use_container_width=True)


# === VEHICLE CLASS ANALYSIS ===
st.header("🚗 Анализ по классам автомобилей")

vehicle_data = filtered_df.groupby('vehicle_class').agg({
    'final_price': ['sum', 'mean'],
    'id': 'count',
}).reset_index()
vehicle_data.columns = ['Класс', 'Выручка', 'Средний чек', 'Бронирований']
vehicle_data = vehicle_data.sort_values('Выручка', ascending=True)

fig_vehicle = px.bar(
    vehicle_data,
    y='Класс',
    x='Выручка',
    orientation='h',
    text=vehicle_data['Выручка'].apply(lambda x: f'€{x:,.0f}'),
    color='Средний чек',
    color_continuous_scale='Blues',
)
fig_vehicle.update_layout(height=400)
fig_vehicle.update_traces(textposition='outside')
st.plotly_chart(fig_vehicle, use_container_width=True)


# === TOP ROUTES ===
st.header("🛣️ Топ маршрутов")

route_data = filtered_df[filtered_df['route_name'].notna()].groupby('route_name').agg({
    'final_price': 'sum',
    'id': 'count',
}).reset_index()
route_data.columns = ['Маршрут', 'Выручка', 'Бронирований']
route_data = route_data.sort_values('Выручка', ascending=False).head(10)

fig_routes = px.bar(
    route_data,
    x='Маршрут',
    y='Выручка',
    text=route_data['Выручка'].apply(lambda x: f'€{x:,.0f}'),
    color='Бронирований',
    color_continuous_scale='Greens',
)
fig_routes.update_layout(height=400, xaxis_tickangle=-45)
fig_routes.update_traces(textposition='outside')
st.plotly_chart(fig_routes, use_container_width=True)


# === DAY OF WEEK ANALYSIS ===
st.header("📆 Распределение по дням недели")

day_order = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
day_names_ru = {
    'Monday': 'Пн', 'Tuesday': 'Вт', 'Wednesday': 'Ср',
    'Thursday': 'Чт', 'Friday': 'Пт', 'Saturday': 'Сб', 'Sunday': 'Вс'
}

dow_data = filtered_df.groupby('day_of_week').agg({
    'final_price': 'sum',
    'id': 'count',
}).reindex(day_order).reset_index()
dow_data.columns = ['День', 'Выручка', 'Бронирований']
dow_data['День'] = dow_data['День'].map(day_names_ru)

col1, col2 = st.columns(2)

with col1:
    fig_dow_revenue = px.bar(
        dow_data,
        x='День',
        y='Выручка',
        title='Выручка по дням',
        color='Выручка',
        color_continuous_scale='Blues',
    )
    fig_dow_revenue.update_layout(height=300, showlegend=False)
    st.plotly_chart(fig_dow_revenue, use_container_width=True)

with col2:
    fig_dow_count = px.bar(
        dow_data,
        x='День',
        y='Бронирований',
        title='Бронирования по дням',
        color='Бронирований',
        color_continuous_scale='Greens',
    )
    fig_dow_count.update_layout(height=300, showlegend=False)
    st.plotly_chart(fig_dow_count, use_container_width=True)


# === DATA TABLE ===
st.header("📋 Детализация")

# Format for display
display_df = filtered_df[[
    'booking_reference', 'created_at', 'service_date', 'status',
    'payment_status', 'vehicle_class', 'num_passengers', 'final_price'
]].copy()

display_df.columns = [
    'Номер', 'Создано', 'Дата услуги', 'Статус',
    'Оплата', 'Класс авто', 'Пассажиров', 'Сумма (€)'
]

display_df['Создано'] = display_df['Создано'].dt.strftime('%Y-%m-%d %H:%M')
display_df['Дата услуги'] = display_df['Дата услуги'].dt.strftime('%Y-%m-%d')
display_df['Сумма (€)'] = display_df['Сумма (€)'].apply(lambda x: f'{x:,.2f}')

st.dataframe(
    display_df.sort_values('Создано', ascending=False),
    use_container_width=True,
    height=400,
)


# === EXPORT ===
st.sidebar.markdown("---")
st.sidebar.header("📥 Экспорт")

csv = filtered_df.to_csv(index=False).encode('utf-8')
st.sidebar.download_button(
    label="Скачать CSV",
    data=csv,
    file_name=f"sales_report_{start_date.date()}_{end_date.date()}.csv",
    mime="text/csv",
)


# Footer
st.markdown("---")
st.caption(f"Данные за период: {start_date.date()} — {end_date.date()} | "
           f"Последнее обновление: {datetime.now().strftime('%Y-%m-%d %H:%M')}")

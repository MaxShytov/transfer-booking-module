import React, { useState, useMemo } from 'react';
import { Calendar, Filter, Search, Plus, Users, TrendingUp, Clock, DollarSign, CheckCircle, XCircle, AlertCircle, Phone, Mail, MapPin, ChevronRight, Edit2, X, Save } from 'lucide-react';

// Моковые данные
const mockBookings = [
  {
    id: 1,
    reference: 'TRF-2026-001',
    customer: { name: 'Marco Rossi', phone: '+39 339 1234567', email: 'marco.rossi@email.com' },
    pickup: { address: 'Aeroporto Fiumicino, Terminal 3', time: '14:30', date: '2026-01-22' },
    dropoff: { address: 'Hotel Excelsior, Via Veneto 125, Roma', time: '15:45' },
    status: 'CONFIRMED',
    paymentTerms: 'DEPOSIT_50_50',
    paymentStatus: 'DEPOSIT_PAID',
    paymentMethod: 'CARD_ONLINE',
    depositAmount: 42.50,
    remainingAmount: 42.50,
    passengers: 2,
    luggage: 2,
    vehicleClass: 'Business Sedan',
    price: 85,
    driver: { id: 1, name: 'Giuseppe Verdi', phone: '+39 347 9876543' },
    notes: 'Cliente VIP, richiesta acqua frizzante'
  },
  {
    id: 2,
    reference: 'TRF-2026-002',
    customer: { name: 'Anna Schmidt', phone: '+49 170 1234567', email: 'anna.schmidt@email.com' },
    pickup: { address: 'Hotel Palazzo Naiadi, Piazza della Repubblica', time: '09:00', date: '2026-01-22' },
    dropoff: { address: 'Aeroporto Ciampino', time: '09:45' },
    status: 'PENDING',
    paymentTerms: 'FULL_PREPAYMENT',
    paymentStatus: 'FULLY_PAID',
    paymentMethod: 'CARD_ONLINE',
    depositAmount: 55,
    remainingAmount: 0,
    passengers: 1,
    luggage: 1,
    vehicleClass: 'Economy Sedan',
    price: 55,
    driver: null,
    notes: ''
  },
  {
    id: 3,
    reference: 'TRF-2026-003',
    customer: { name: 'John Smith', phone: '+1 555 1234567', email: 'john.smith@email.com' },
    pickup: { address: 'Stazione Termini', time: '16:00', date: '2026-01-22' },
    dropoff: { address: 'Porto di Civitavecchia', time: '17:30' },
    status: 'IN_PROGRESS',
    paymentTerms: 'FULL_PREPAYMENT',
    paymentStatus: 'FULLY_PAID',
    paymentMethod: 'CARD_ONLINE',
    depositAmount: 120,
    remainingAmount: 0,
    passengers: 4,
    luggage: 6,
    vehicleClass: 'Minivan',
    price: 120,
    driver: { id: 2, name: 'Marco Bianchi', phone: '+39 345 1234567' },
    notes: 'Crociera Costa alle 18:00'
  },
  {
    id: 4,
    reference: 'TRF-2026-004',
    customer: { name: 'Marie Dubois', phone: '+33 6 12345678', email: 'marie.dubois@email.com' },
    pickup: { address: 'Aeroporto Fiumicino, Terminal 1', time: '20:15', date: '2026-01-22' },
    dropoff: { address: 'Hotel Hassler, Piazza Trinità dei Monti', time: '21:30' },
    status: 'CONFIRMED',
    paymentTerms: 'DEPOSIT_30_70',
    paymentStatus: 'DEPOSIT_PAID',
    paymentMethod: 'CARD_ONLINE',
    depositAmount: 33,
    remainingAmount: 77,
    passengers: 2,
    luggage: 3,
    vehicleClass: 'Luxury Sedan',
    price: 110,
    driver: { id: 3, name: 'Alessandro Conti', phone: '+39 349 9876543' },
    notes: 'Late night pickup'
  },
  {
    id: 5,
    reference: 'TRF-2026-005',
    customer: { name: 'Carlos Rodriguez', phone: '+34 612 345678', email: 'carlos.rodriguez@email.com' },
    pickup: { address: 'Hotel NH Collection, Via Nazionale', time: '08:00', date: '2026-01-23' },
    dropoff: { address: 'Aeroporto Fiumicino, Terminal 3', time: '09:15' },
    status: 'CONFIRMED',
    paymentTerms: 'PAY_ON_COMPLETION',
    paymentStatus: 'UNPAID',
    paymentMethod: 'CASH_TO_DRIVER',
    depositAmount: 0,
    remainingAmount: 75,
    passengers: 3,
    luggage: 4,
    vehicleClass: 'Business Sedan',
    price: 75,
    driver: { id: 1, name: 'Giuseppe Verdi', phone: '+39 347 9876543' },
    notes: 'Early morning transfer - постоянный клиент'
  },
  {
    id: 6,
    reference: 'TRF-2026-006',
    customer: { name: 'Lisa Anderson', phone: '+44 7700 900000', email: 'lisa.anderson@email.com' },
    pickup: { address: 'Hotel Colosseum, Via Capo d\'Africa', time: '11:30', date: '2026-01-22' },
    dropoff: { address: 'Aeroporto Fiumicino, Terminal 3', time: '12:45' },
    status: 'CONFIRMED',
    paymentTerms: 'DEPOSIT_50_50',
    paymentStatus: 'BALANCE_DUE',
    paymentMethod: 'CARD_ONLINE',
    depositAmount: 40,
    remainingAmount: 40,
    passengers: 2,
    luggage: 2,
    vehicleClass: 'Business Sedan',
    price: 80,
    driver: { id: 4, name: 'Luca Ferrari', phone: '+39 348 7654321' },
    notes: '⚠️ Вторая часть оплаты должна быть внесена до 20.01'
  }
];

const mockDrivers = [
  { id: 1, name: 'Giuseppe Verdi', phone: '+39 347 9876543', vehicle: 'Mercedes E-Class', plate: 'AB123CD', available: true },
  { id: 2, name: 'Marco Bianchi', phone: '+39 345 1234567', vehicle: 'Mercedes Vito', plate: 'EF456GH', available: false },
  { id: 3, name: 'Alessandro Conti', phone: '+39 349 9876543', vehicle: 'BMW 5 Series', plate: 'IJ789KL', available: true },
  { id: 4, name: 'Luca Ferrari', phone: '+39 348 7654321', vehicle: 'Audi A6', plate: 'MN012OP', available: true },
  { id: 5, name: 'Paolo Romano', phone: '+39 346 1111111', vehicle: 'Mercedes S-Class', plate: 'QR345ST', available: true }
];

const statusConfig = {
  PENDING: { label: 'В ожидании', color: 'bg-amber-500', icon: AlertCircle },
  CONFIRMED: { label: 'Подтверждено', color: 'bg-blue-500', icon: CheckCircle },
  IN_PROGRESS: { label: 'В пути', color: 'bg-purple-500', icon: Clock },
  COMPLETED: { label: 'Завершено', color: 'bg-green-500', icon: CheckCircle },
  CANCELLED: { label: 'Отменено', color: 'bg-red-500', icon: XCircle }
};

const paymentTermsConfig = {
  FULL_PREPAYMENT: { label: 'Полная предоплата', shortLabel: '100%', icon: '💳', color: '#10b981' },
  DEPOSIT_50_50: { label: 'Депозит 50/50', shortLabel: '50/50', icon: '⚖️', color: '#3b82f6' },
  DEPOSIT_30_70: { label: 'Депозит 30%', shortLabel: '30/70', icon: '📊', color: '#8b5cf6' },
  PAY_ON_COMPLETION: { label: 'Оплата по факту', shortLabel: 'По факту', icon: '✋', color: '#f59e0b' }
};

const paymentStatusConfig = {
  UNPAID: { label: 'Не оплачено', color: 'bg-red-100 text-red-800', dotColor: '#ef4444' },
  DEPOSIT_PAID: { label: 'Депозит внесён', color: 'bg-yellow-100 text-yellow-800', dotColor: '#f59e0b' },
  BALANCE_DUE: { label: 'Ожидается остаток', color: 'bg-orange-100 text-orange-800', dotColor: '#f97316' },
  FULLY_PAID: { label: 'Оплачено полностью', color: 'bg-green-100 text-green-800', dotColor: '#10b981' },
  REFUNDED: { label: 'Возврат выполнен', color: 'bg-gray-100 text-gray-800', dotColor: '#6b7280' }
};

const paymentMethodConfig = {
  CARD_ONLINE: { label: 'Карта онлайн', icon: '💳' },
  CASH_TO_DRIVER: { label: 'Наличные водителю', icon: '💵' },
  BANK_TRANSFER: { label: 'Банковский перевод', icon: '🏦' },
  DIGITAL_WALLET: { label: 'Электронный кошелёк', icon: '📱' }
};

// Функция для определения критичности оплаты
const getPaymentAlert = (booking) => {
  const today = new Date('2026-01-22');
  const transferDate = new Date(booking.pickup.date);
  const hoursUntilTransfer = (transferDate - today) / (1000 * 60 * 60);
  
  // КРИТИЧНО: Остаток не оплачен и трансфер < 24 часа
  if (booking.paymentStatus === 'BALANCE_DUE' && hoursUntilTransfer < 24) {
    return { level: 'critical', message: '🔴 СРОЧНО! Остаток не оплачен, трансфер через ' + Math.round(hoursUntilTransfer) + 'ч' };
  }
  
  // ПРЕДУПРЕЖДЕНИЕ: Остаток не оплачен и трансфер < 48 часов
  if (booking.paymentStatus === 'BALANCE_DUE' && hoursUntilTransfer < 48) {
    return { level: 'warning', message: '⚠️ Требуется оплата остатка (трансфер через ' + Math.round(hoursUntilTransfer) + 'ч)' };
  }
  
  // ОЖИДАНИЕ: Оплата по факту - это нормально
  if (booking.paymentTerms === 'PAY_ON_COMPLETION' && booking.paymentStatus === 'UNPAID') {
    return { level: 'info', message: 'ℹ️ Оплата будет после завершения' };
  }
  
  // НЕ ОПЛАЧЕНО: Любой другой вариант с UNPAID
  if (booking.paymentStatus === 'UNPAID') {
    return { level: 'error', message: '❌ Не оплачено' };
  }
  
  return null;
};

export default function DispatcherDashboard() {
  const [activeTab, setActiveTab] = useState('bookings');
  const [selectedBooking, setSelectedBooking] = useState(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [paymentTermsFilter, setPaymentTermsFilter] = useState('ALL');
  const [dateFilter, setDateFilter] = useState('today');
  const [showDriverPicker, setShowDriverPicker] = useState(false);
  const [showEditForm, setShowEditForm] = useState(false);
  const [editingBooking, setEditingBooking] = useState(null);

  const filteredBookings = useMemo(() => {
    return mockBookings.filter(booking => {
      const matchesSearch = searchQuery === '' || 
        booking.reference.toLowerCase().includes(searchQuery.toLowerCase()) ||
        booking.customer.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        booking.customer.phone.includes(searchQuery);
      
      const matchesStatus = statusFilter === 'ALL' || booking.status === statusFilter;
      
      const matchesPaymentTerms = paymentTermsFilter === 'ALL' || booking.paymentTerms === paymentTermsFilter;
      
      const matchesDate = dateFilter === 'all' || 
        (dateFilter === 'today' && booking.pickup.date === '2026-01-22') ||
        (dateFilter === 'tomorrow' && booking.pickup.date === '2026-01-23');
      
      return matchesSearch && matchesStatus && matchesPaymentTerms && matchesDate;
    });
  }, [searchQuery, statusFilter, paymentTermsFilter, dateFilter]);

  const stats = useMemo(() => {
    const today = mockBookings.filter(b => b.pickup.date === '2026-01-22');
    const paymentAlerts = mockBookings.filter(b => {
      const alert = getPaymentAlert(b);
      return alert && (alert.level === 'critical' || alert.level === 'warning');
    });
    return {
      todayTransfers: today.length,
      todayRevenue: today.reduce((sum, b) => sum + b.price, 0),
      pending: mockBookings.filter(b => b.status === 'PENDING').length,
      inProgress: mockBookings.filter(b => b.status === 'IN_PROGRESS').length,
      completed: mockBookings.filter(b => b.status === 'COMPLETED').length,
      paymentAlerts: paymentAlerts.length
    };
  }, []);

  const handleStatusChange = (bookingId, newStatus) => {
    console.log(`Changing booking ${bookingId} to ${newStatus}`);
    // В реальном приложении здесь будет API call
  };

  const handleAssignDriver = (bookingId, driverId) => {
    console.log(`Assigning driver ${driverId} to booking ${bookingId}`);
    setShowDriverPicker(false);
    // В реальном приложении здесь будет API call
  };

  const handleEditBooking = (booking) => {
    setEditingBooking({...booking});
    setShowEditForm(true);
  };

  const handleSaveEdit = () => {
    console.log('Saving booking:', editingBooking);
    setShowEditForm(false);
    // В реальном приложении здесь будет API call
  };

  return (
    <div style={{
      width: '100vw',
      height: '100vh',
      background: 'linear-gradient(135deg, #0f172a 0%, #1e293b 100%)',
      fontFamily: '"Manrope", -apple-system, BlinkMacSystemFont, sans-serif',
      color: '#e2e8f0',
      overflow: 'hidden',
      position: 'relative'
    }}>
      {/* Decorative Background Elements */}
      <div style={{
        position: 'absolute',
        top: '-20%',
        right: '-10%',
        width: '600px',
        height: '600px',
        background: 'radial-gradient(circle, rgba(59, 130, 246, 0.1) 0%, transparent 70%)',
        borderRadius: '50%',
        filter: 'blur(60px)',
        pointerEvents: 'none'
      }} />
      <div style={{
        position: 'absolute',
        bottom: '-20%',
        left: '-10%',
        width: '500px',
        height: '500px',
        background: 'radial-gradient(circle, rgba(168, 85, 247, 0.08) 0%, transparent 70%)',
        borderRadius: '50%',
        filter: 'blur(60px)',
        pointerEvents: 'none'
      }} />

      {/* Header */}
      <header style={{
        borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
        background: 'rgba(15, 23, 42, 0.8)',
        backdropFilter: 'blur(20px)',
        padding: '16px 32px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        position: 'relative',
        zIndex: 10
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
          <div style={{
            width: '48px',
            height: '48px',
            background: 'linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%)',
            borderRadius: '12px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: '0 8px 24px rgba(59, 130, 246, 0.3)'
          }}>
            <Users size={24} color="#fff" />
          </div>
          <div>
            <h1 style={{ 
              fontSize: '24px', 
              fontWeight: '700', 
              margin: 0,
              background: 'linear-gradient(135deg, #fff 0%, #94a3b8 100%)',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent'
            }}>
              Диспетчерская
            </h1>
            <p style={{ margin: 0, fontSize: '14px', color: '#64748b' }}>
              22 января 2026, четверг
            </p>
          </div>
        </div>

        {/* KPI Cards in Header */}
        <div style={{ display: 'flex', gap: '16px' }}>
          {[
            { icon: Calendar, label: 'Сегодня', value: stats.todayTransfers, color: '#3b82f6' },
            { icon: DollarSign, label: 'Выручка', value: `€${stats.todayRevenue}`, color: '#10b981' },
            { icon: AlertCircle, label: 'Проблемы с оплатой', value: stats.paymentAlerts, color: '#ef4444' },
            { icon: Clock, label: 'В пути', value: stats.inProgress, color: '#8b5cf6' }
          ].map((stat, idx) => (
            <div key={idx} style={{
              background: 'rgba(255, 255, 255, 0.03)',
              border: '1px solid rgba(255, 255, 255, 0.08)',
              borderRadius: '12px',
              padding: '12px 20px',
              minWidth: '140px',
              backdropFilter: 'blur(10px)'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '4px' }}>
                <stat.icon size={16} style={{ color: stat.color }} />
                <span style={{ fontSize: '12px', color: '#94a3b8', fontWeight: '500' }}>
                  {stat.label}
                </span>
              </div>
              <div style={{ fontSize: '24px', fontWeight: '700', color: '#fff' }}>
                {stat.value}
              </div>
            </div>
          ))}
        </div>
      </header>

      {/* Main Content */}
      <div style={{ display: 'flex', height: 'calc(100vh - 81px)', position: 'relative' }}>
        {/* Sidebar Navigation */}
        <aside style={{
          width: '280px',
          borderRight: '1px solid rgba(255, 255, 255, 0.05)',
          background: 'rgba(15, 23, 42, 0.6)',
          backdropFilter: 'blur(20px)',
          padding: '24px',
          display: 'flex',
          flexDirection: 'column',
          gap: '8px'
        }}>
          {[
            { id: 'bookings', icon: Calendar, label: 'Бронирования', badge: filteredBookings.length },
            { id: 'calendar', icon: Calendar, label: 'Календарь' },
            { id: 'analytics', icon: TrendingUp, label: 'Аналитика' },
            { id: 'drivers', icon: Users, label: 'Водители', badge: mockDrivers.filter(d => d.available).length }
          ].map(tab => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              style={{
                background: activeTab === tab.id ? 'rgba(59, 130, 246, 0.15)' : 'transparent',
                border: activeTab === tab.id ? '1px solid rgba(59, 130, 246, 0.3)' : '1px solid transparent',
                borderRadius: '10px',
                padding: '14px 16px',
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                color: activeTab === tab.id ? '#3b82f6' : '#94a3b8',
                fontSize: '15px',
                fontWeight: '600',
                cursor: 'pointer',
                transition: 'all 0.2s ease',
                textAlign: 'left'
              }}
              onMouseEnter={e => {
                if (activeTab !== tab.id) {
                  e.currentTarget.style.background = 'rgba(255, 255, 255, 0.03)';
                }
              }}
              onMouseLeave={e => {
                if (activeTab !== tab.id) {
                  e.currentTarget.style.background = 'transparent';
                }
              }}
            >
              <tab.icon size={20} />
              <span style={{ flex: 1 }}>{tab.label}</span>
              {tab.badge && (
                <span style={{
                  background: activeTab === tab.id ? '#3b82f6' : 'rgba(255, 255, 255, 0.1)',
                  color: '#fff',
                  fontSize: '12px',
                  fontWeight: '700',
                  padding: '2px 8px',
                  borderRadius: '10px',
                  minWidth: '24px',
                  textAlign: 'center'
                }}>
                  {tab.badge}
                </span>
              )}
            </button>
          ))}
        </aside>

        {/* Bookings List */}
        {activeTab === 'bookings' && (
          <div style={{ 
            flex: '0 0 480px', 
            borderRight: '1px solid rgba(255, 255, 255, 0.05)',
            display: 'flex',
            flexDirection: 'column',
            background: 'rgba(15, 23, 42, 0.4)',
            backdropFilter: 'blur(20px)'
          }}>
            {/* Filters */}
            <div style={{ 
              padding: '20px 24px',
              borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
              background: 'rgba(15, 23, 42, 0.6)'
            }}>
              <div style={{ display: 'flex', gap: '12px', marginBottom: '16px' }}>
                <div style={{ position: 'relative', flex: 1 }}>
                  <Search size={18} style={{ 
                    position: 'absolute', 
                    left: '14px', 
                    top: '50%', 
                    transform: 'translateY(-50%)',
                    color: '#64748b'
                  }} />
                  <input
                    type="text"
                    placeholder="Поиск по номеру, имени, телефону..."
                    value={searchQuery}
                    onChange={e => setSearchQuery(e.target.value)}
                    style={{
                      width: '100%',
                      padding: '12px 12px 12px 44px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '10px',
                      color: '#e2e8f0',
                      fontSize: '14px',
                      outline: 'none'
                    }}
                  />
                </div>
                <button style={{
                  padding: '12px 20px',
                  background: 'linear-gradient(135deg, #3b82f6 0%, #2563eb 100%)',
                  border: 'none',
                  borderRadius: '10px',
                  color: '#fff',
                  fontSize: '14px',
                  fontWeight: '600',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  boxShadow: '0 4px 12px rgba(59, 130, 246, 0.3)'
                }}>
                  <Plus size={18} />
                  Создать
                </button>
              </div>

              <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
                {['today', 'tomorrow', 'all'].map(filter => (
                  <button
                    key={filter}
                    onClick={() => setDateFilter(filter)}
                    style={{
                      padding: '6px 14px',
                      background: dateFilter === filter ? 'rgba(59, 130, 246, 0.2)' : 'rgba(255, 255, 255, 0.05)',
                      border: dateFilter === filter ? '1px solid rgba(59, 130, 246, 0.4)' : '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: dateFilter === filter ? '#3b82f6' : '#94a3b8',
                      fontSize: '13px',
                      fontWeight: '600',
                      cursor: 'pointer'
                    }}
                  >
                    {filter === 'today' ? 'Сегодня' : filter === 'tomorrow' ? 'Завтра' : 'Все'}
                  </button>
                ))}
                
                <div style={{ width: '1px', background: 'rgba(255, 255, 255, 0.1)', margin: '0 4px' }} />
                
                {['ALL', 'PENDING', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED'].map(status => (
                  <button
                    key={status}
                    onClick={() => setStatusFilter(status)}
                    style={{
                      padding: '6px 14px',
                      background: statusFilter === status ? 'rgba(59, 130, 246, 0.2)' : 'rgba(255, 255, 255, 0.05)',
                      border: statusFilter === status ? '1px solid rgba(59, 130, 246, 0.4)' : '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: statusFilter === status ? '#3b82f6' : '#94a3b8',
                      fontSize: '13px',
                      fontWeight: '600',
                      cursor: 'pointer'
                    }}
                  >
                    {status === 'ALL' ? 'Все' : statusConfig[status]?.label}
                  </button>
                ))}
                
                <div style={{ width: '1px', background: 'rgba(255, 255, 255, 0.1)', margin: '0 4px' }} />
                
                {['ALL', 'FULL_PREPAYMENT', 'DEPOSIT_50_50', 'DEPOSIT_30_70', 'PAY_ON_COMPLETION'].map(terms => (
                  <button
                    key={terms}
                    onClick={() => setPaymentTermsFilter(terms)}
                    style={{
                      padding: '6px 14px',
                      background: paymentTermsFilter === terms ? 'rgba(59, 130, 246, 0.2)' : 'rgba(255, 255, 255, 0.05)',
                      border: paymentTermsFilter === terms ? '1px solid rgba(59, 130, 246, 0.4)' : '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: paymentTermsFilter === terms ? '#3b82f6' : '#94a3b8',
                      fontSize: '13px',
                      fontWeight: '600',
                      cursor: 'pointer'
                    }}
                  >
                    {terms === 'ALL' ? 'Все условия' : paymentTermsConfig[terms]?.shortLabel}
                  </button>
                ))}
              </div>
            </div>

            {/* Bookings List */}
            <div style={{ flex: 1, overflowY: 'auto', padding: '16px' }}>
              {filteredBookings.map(booking => {
                const StatusIcon = statusConfig[booking.status].icon;
                const paymentAlert = getPaymentAlert(booking);
                return (
                  <div
                    key={booking.id}
                    onClick={() => setSelectedBooking(booking)}
                    style={{
                      background: selectedBooking?.id === booking.id ? 'rgba(59, 130, 246, 0.1)' : 'rgba(255, 255, 255, 0.03)',
                      border: selectedBooking?.id === booking.id ? '1px solid rgba(59, 130, 246, 0.3)' : 
                        paymentAlert?.level === 'critical' ? '1px solid rgba(239, 68, 68, 0.5)' :
                        paymentAlert?.level === 'warning' ? '1px solid rgba(245, 158, 11, 0.5)' :
                        '1px solid rgba(255, 255, 255, 0.05)',
                      borderRadius: '12px',
                      padding: '16px',
                      marginBottom: '12px',
                      cursor: 'pointer',
                      transition: 'all 0.2s ease',
                      position: 'relative'
                    }}
                    onMouseEnter={e => {
                      if (selectedBooking?.id !== booking.id) {
                        e.currentTarget.style.background = 'rgba(255, 255, 255, 0.05)';
                      }
                    }}
                    onMouseLeave={e => {
                      if (selectedBooking?.id !== booking.id) {
                        e.currentTarget.style.background = 'rgba(255, 255, 255, 0.03)';
                      }
                    }}
                  >
                    {/* Payment Alert Badge */}
                    {paymentAlert && (paymentAlert.level === 'critical' || paymentAlert.level === 'warning') && (
                      <div style={{
                        position: 'absolute',
                        top: '-8px',
                        right: '12px',
                        padding: '4px 10px',
                        background: paymentAlert.level === 'critical' ? 
                          'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)' : 
                          'linear-gradient(135deg, #f59e0b 0%, #d97706 100%)',
                        borderRadius: '12px',
                        fontSize: '10px',
                        fontWeight: '800',
                        color: '#fff',
                        boxShadow: '0 4px 12px rgba(0, 0, 0, 0.3)',
                        animation: paymentAlert.level === 'critical' ? 'pulse 2s infinite' : 'none'
                      }}>
                        {paymentAlert.level === 'critical' ? '🔴 СРОЧНО' : '⚠️ ВНИМАНИЕ'}
                      </div>
                    )}
                    
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '12px' }}>
                      <div>
                        <div style={{ fontSize: '15px', fontWeight: '700', color: '#fff', marginBottom: '4px' }}>
                          {booking.reference}
                        </div>
                        <div style={{ fontSize: '13px', color: '#94a3b8' }}>
                          {booking.customer.name}
                        </div>
                      </div>
                      <div style={{ display: 'flex', gap: '6px', alignItems: 'center', flexWrap: 'wrap', justifyContent: 'flex-end' }}>
                        <span className={statusConfig[booking.status].color} style={{
                          padding: '4px 10px',
                          borderRadius: '6px',
                          fontSize: '11px',
                          fontWeight: '700',
                          color: '#fff',
                          display: 'flex',
                          alignItems: 'center',
                          gap: '4px'
                        }}>
                          <StatusIcon size={12} />
                          {statusConfig[booking.status].label}
                        </span>
                      </div>
                    </div>

                    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', fontSize: '13px' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#cbd5e1' }}>
                        <Clock size={14} style={{ color: '#64748b', flexShrink: 0 }} />
                        <span>{booking.pickup.time}</span>
                        <ChevronRight size={14} style={{ color: '#64748b' }} />
                        <span style={{ 
                          overflow: 'hidden', 
                          textOverflow: 'ellipsis', 
                          whiteSpace: 'nowrap' 
                        }}>
                          {booking.pickup.address.split(',')[0]}
                        </span>
                      </div>
                      
                      {booking.driver ? (
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#10b981' }}>
                          <Users size={14} style={{ flexShrink: 0 }} />
                          <span>{booking.driver.name}</span>
                        </div>
                      ) : (
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#f59e0b' }}>
                          <AlertCircle size={14} style={{ flexShrink: 0 }} />
                          <span>Водитель не назначен</span>
                        </div>
                      )}

                      <div style={{ 
                        display: 'flex', 
                        justifyContent: 'space-between',
                        alignItems: 'center',
                        paddingTop: '8px',
                        borderTop: '1px solid rgba(255, 255, 255, 0.05)'
                      }}>
                        <div style={{ display: 'flex', gap: '6px', alignItems: 'center' }}>
                          <span style={{
                            padding: '3px 8px',
                            borderRadius: '5px',
                            fontSize: '11px',
                            fontWeight: '700',
                            background: `${paymentTermsConfig[booking.paymentTerms].color}20`,
                            color: paymentTermsConfig[booking.paymentTerms].color,
                            border: `1px solid ${paymentTermsConfig[booking.paymentTerms].color}40`
                          }}>
                            {paymentTermsConfig[booking.paymentTerms].icon} {paymentTermsConfig[booking.paymentTerms].shortLabel}
                          </span>
                          <span className={paymentStatusConfig[booking.paymentStatus].color} style={{
                            padding: '3px 8px',
                            borderRadius: '5px',
                            fontSize: '11px',
                            fontWeight: '600'
                          }}>
                            {paymentStatusConfig[booking.paymentStatus].label}
                          </span>
                        </div>
                        <span style={{ color: '#10b981', fontWeight: '700' }}>
                          €{booking.price}
                        </span>
                      </div>
                      
                      {paymentAlert && (
                        <div style={{
                          fontSize: '11px',
                          color: paymentAlert.level === 'critical' ? '#ef4444' : 
                                 paymentAlert.level === 'warning' ? '#f59e0b' : '#64748b',
                          fontWeight: '600',
                          marginTop: '4px'
                        }}>
                          {paymentAlert.message}
                        </div>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Detail Panel */}
        {activeTab === 'bookings' && (
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
            {selectedBooking ? (
              <>
                <div style={{ 
                  padding: '24px 32px',
                  borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
                  background: 'rgba(15, 23, 42, 0.6)',
                  backdropFilter: 'blur(20px)'
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
                    <div>
                      <h2 style={{ 
                        fontSize: '28px', 
                        fontWeight: '700', 
                        margin: '0 0 8px 0',
                        background: 'linear-gradient(135deg, #fff 0%, #94a3b8 100%)',
                        WebkitBackgroundClip: 'text',
                        WebkitTextFillColor: 'transparent'
                      }}>
                        {selectedBooking.reference}
                      </h2>
                      <div style={{ fontSize: '14px', color: '#64748b' }}>
                        Создано: 20 января 2026, 15:32
                      </div>
                    </div>
                    <div style={{ display: 'flex', gap: '12px' }}>
                      <button 
                        onClick={() => handleEditBooking(selectedBooking)}
                        style={{
                          padding: '10px 18px',
                          background: 'rgba(255, 255, 255, 0.05)',
                          border: '1px solid rgba(255, 255, 255, 0.1)',
                          borderRadius: '10px',
                          color: '#e2e8f0',
                          fontSize: '14px',
                          fontWeight: '600',
                          cursor: 'pointer',
                          display: 'flex',
                          alignItems: 'center',
                          gap: '8px'
                        }}
                      >
                        <Edit2 size={16} />
                        Редактировать
                      </button>
                      <button style={{
                        padding: '10px 18px',
                        background: 'rgba(239, 68, 68, 0.15)',
                        border: '1px solid rgba(239, 68, 68, 0.3)',
                        borderRadius: '10px',
                        color: '#ef4444',
                        fontSize: '14px',
                        fontWeight: '600',
                        cursor: 'pointer'
                      }}>
                        Отменить
                      </button>
                    </div>
                  </div>

                  {/* Quick Actions */}
                  <div style={{ display: 'flex', gap: '12px' }}>
                    {['PENDING', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED'].map(status => {
                      const isCurrentStatus = selectedBooking.status === status;
                      const StatusIcon = statusConfig[status].icon;
                      return (
                        <button
                          key={status}
                          onClick={() => !isCurrentStatus && handleStatusChange(selectedBooking.id, status)}
                          disabled={isCurrentStatus}
                          style={{
                            flex: 1,
                            padding: '12px',
                            background: isCurrentStatus ? statusConfig[status].color : 'rgba(255, 255, 255, 0.05)',
                            border: '1px solid ' + (isCurrentStatus ? 'transparent' : 'rgba(255, 255, 255, 0.1)'),
                            borderRadius: '10px',
                            color: isCurrentStatus ? '#fff' : '#94a3b8',
                            fontSize: '13px',
                            fontWeight: '600',
                            cursor: isCurrentStatus ? 'default' : 'pointer',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            gap: '6px',
                            opacity: isCurrentStatus ? 1 : 0.7,
                            transition: 'all 0.2s ease'
                          }}
                        >
                          <StatusIcon size={16} />
                          {statusConfig[status].label}
                        </button>
                      );
                    })}
                  </div>
                </div>

                {/* Details Content */}
                <div style={{ flex: 1, overflowY: 'auto', padding: '32px' }}>
                  {/* Customer Info */}
                  <section style={{ marginBottom: '32px' }}>
                    <h3 style={{ 
                      fontSize: '16px', 
                      fontWeight: '700', 
                      color: '#fff', 
                      marginBottom: '16px',
                      display: 'flex',
                      alignItems: 'center',
                      gap: '8px'
                    }}>
                      <div style={{
                        width: '32px',
                        height: '32px',
                        background: 'linear-gradient(135deg, #3b82f6 0%, #2563eb 100%)',
                        borderRadius: '8px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center'
                      }}>
                        <Users size={16} color="#fff" />
                      </div>
                      Информация о клиенте
                    </h3>
                    <div style={{
                      background: 'rgba(255, 255, 255, 0.03)',
                      border: '1px solid rgba(255, 255, 255, 0.05)',
                      borderRadius: '12px',
                      padding: '20px'
                    }}>
                      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                        <div>
                          <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '4px' }}>Имя</div>
                          <div style={{ fontSize: '15px', color: '#fff', fontWeight: '600' }}>
                            {selectedBooking.customer.name}
                          </div>
                        </div>
                        <div>
                          <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '4px' }}>Телефон</div>
                          <div style={{ 
                            fontSize: '15px', 
                            color: '#3b82f6', 
                            fontWeight: '600',
                            display: 'flex',
                            alignItems: 'center',
                            gap: '6px'
                          }}>
                            <Phone size={14} />
                            {selectedBooking.customer.phone}
                          </div>
                        </div>
                        <div style={{ gridColumn: '1 / -1' }}>
                          <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '4px' }}>Email</div>
                          <div style={{ 
                            fontSize: '15px', 
                            color: '#3b82f6', 
                            fontWeight: '600',
                            display: 'flex',
                            alignItems: 'center',
                            gap: '6px'
                          }}>
                            <Mail size={14} />
                            {selectedBooking.customer.email}
                          </div>
                        </div>
                      </div>
                    </div>
                  </section>

                  {/* Transfer Details */}
                  <section style={{ marginBottom: '32px' }}>
                    <h3 style={{ 
                      fontSize: '16px', 
                      fontWeight: '700', 
                      color: '#fff', 
                      marginBottom: '16px',
                      display: 'flex',
                      alignItems: 'center',
                      gap: '8px'
                    }}>
                      <div style={{
                        width: '32px',
                        height: '32px',
                        background: 'linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%)',
                        borderRadius: '8px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center'
                      }}>
                        <MapPin size={16} color="#fff" />
                      </div>
                      Детали трансфера
                    </h3>
                    <div style={{
                      background: 'rgba(255, 255, 255, 0.03)',
                      border: '1px solid rgba(255, 255, 255, 0.05)',
                      borderRadius: '12px',
                      padding: '20px'
                    }}>
                      <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
                        <div>
                          <div style={{ 
                            display: 'flex', 
                            alignItems: 'center', 
                            gap: '8px',
                            marginBottom: '8px'
                          }}>
                            <div style={{
                              width: '10px',
                              height: '10px',
                              background: '#10b981',
                              borderRadius: '50%',
                              border: '2px solid rgba(16, 185, 129, 0.3)'
                            }} />
                            <span style={{ fontSize: '12px', color: '#64748b', fontWeight: '600' }}>
                              ОТКУДА
                            </span>
                          </div>
                          <div style={{ fontSize: '15px', color: '#fff', fontWeight: '600', marginLeft: '18px' }}>
                            {selectedBooking.pickup.address}
                          </div>
                          <div style={{ fontSize: '13px', color: '#64748b', marginLeft: '18px', marginTop: '4px' }}>
                            {selectedBooking.pickup.date} в {selectedBooking.pickup.time}
                          </div>
                        </div>

                        <div style={{
                          height: '1px',
                          background: 'linear-gradient(to right, transparent, rgba(255, 255, 255, 0.1), transparent)',
                          margin: '0 18px'
                        }} />

                        <div>
                          <div style={{ 
                            display: 'flex', 
                            alignItems: 'center', 
                            gap: '8px',
                            marginBottom: '8px'
                          }}>
                            <div style={{
                              width: '10px',
                              height: '10px',
                              background: '#ef4444',
                              borderRadius: '50%',
                              border: '2px solid rgba(239, 68, 68, 0.3)'
                            }} />
                            <span style={{ fontSize: '12px', color: '#64748b', fontWeight: '600' }}>
                              КУДА
                            </span>
                          </div>
                          <div style={{ fontSize: '15px', color: '#fff', fontWeight: '600', marginLeft: '18px' }}>
                            {selectedBooking.dropoff.address}
                          </div>
                          <div style={{ fontSize: '13px', color: '#64748b', marginLeft: '18px', marginTop: '4px' }}>
                            ~{selectedBooking.dropoff.time}
                          </div>
                        </div>
                      </div>

                      <div style={{ 
                        display: 'grid', 
                        gridTemplateColumns: 'repeat(3, 1fr)', 
                        gap: '16px',
                        marginTop: '20px',
                        paddingTop: '20px',
                        borderTop: '1px solid rgba(255, 255, 255, 0.05)'
                      }}>
                        <div>
                          <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '4px' }}>Класс машины</div>
                          <div style={{ fontSize: '14px', color: '#fff', fontWeight: '600' }}>
                            {selectedBooking.vehicleClass}
                          </div>
                        </div>
                        <div>
                          <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '4px' }}>Пассажиры</div>
                          <div style={{ fontSize: '14px', color: '#fff', fontWeight: '600' }}>
                            {selectedBooking.passengers} чел.
                          </div>
                        </div>
                        <div>
                          <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '4px' }}>Багаж</div>
                          <div style={{ fontSize: '14px', color: '#fff', fontWeight: '600' }}>
                            {selectedBooking.luggage} шт.
                          </div>
                        </div>
                      </div>
                    </div>
                  </section>

                  {/* Driver Assignment */}
                  <section style={{ marginBottom: '32px' }}>
                    <h3 style={{ 
                      fontSize: '16px', 
                      fontWeight: '700', 
                      color: '#fff', 
                      marginBottom: '16px',
                      display: 'flex',
                      alignItems: 'center',
                      gap: '8px'
                    }}>
                      <div style={{
                        width: '32px',
                        height: '32px',
                        background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                        borderRadius: '8px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center'
                      }}>
                        <Users size={16} color="#fff" />
                      </div>
                      Водитель
                    </h3>
                    {selectedBooking.driver ? (
                      <div style={{
                        background: 'rgba(16, 185, 129, 0.1)',
                        border: '1px solid rgba(16, 185, 129, 0.2)',
                        borderRadius: '12px',
                        padding: '20px',
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center'
                      }}>
                        <div>
                          <div style={{ fontSize: '17px', color: '#fff', fontWeight: '700', marginBottom: '4px' }}>
                            {selectedBooking.driver.name}
                          </div>
                          <div style={{ fontSize: '13px', color: '#10b981', marginBottom: '8px' }}>
                            <Phone size={12} style={{ display: 'inline', marginRight: '4px' }} />
                            {selectedBooking.driver.phone}
                          </div>
                        </div>
                        <button 
                          onClick={() => setShowDriverPicker(true)}
                          style={{
                            padding: '10px 18px',
                            background: 'rgba(255, 255, 255, 0.1)',
                            border: '1px solid rgba(255, 255, 255, 0.2)',
                            borderRadius: '8px',
                            color: '#fff',
                            fontSize: '14px',
                            fontWeight: '600',
                            cursor: 'pointer'
                          }}
                        >
                          Изменить
                        </button>
                      </div>
                    ) : (
                      <button 
                        onClick={() => setShowDriverPicker(true)}
                        style={{
                          width: '100%',
                          padding: '20px',
                          background: 'rgba(245, 158, 11, 0.1)',
                          border: '2px dashed rgba(245, 158, 11, 0.3)',
                          borderRadius: '12px',
                          color: '#f59e0b',
                          fontSize: '15px',
                          fontWeight: '600',
                          cursor: 'pointer',
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          gap: '8px'
                        }}
                      >
                        <Plus size={20} />
                        Назначить водителя
                      </button>
                    )}
                  </section>

                  {/* Payment & Price */}
                  <section>
                    <h3 style={{ 
                      fontSize: '16px', 
                      fontWeight: '700', 
                      color: '#fff', 
                      marginBottom: '16px',
                      display: 'flex',
                      alignItems: 'center',
                      gap: '8px'
                    }}>
                      <div style={{
                        width: '32px',
                        height: '32px',
                        background: 'linear-gradient(135deg, #f59e0b 0%, #d97706 100%)',
                        borderRadius: '8px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center'
                      }}>
                        <DollarSign size={16} color="#fff" />
                      </div>
                      Информация об оплате
                    </h3>
                    <div style={{
                      background: 'rgba(255, 255, 255, 0.03)',
                      border: '1px solid rgba(255, 255, 255, 0.05)',
                      borderRadius: '12px',
                      padding: '20px'
                    }}>
                      {/* Payment Alert */}
                      {(() => {
                        const alert = getPaymentAlert(selectedBooking);
                        if (alert && (alert.level === 'critical' || alert.level === 'warning')) {
                          return (
                            <div style={{
                              background: alert.level === 'critical' ? 
                                'rgba(239, 68, 68, 0.15)' : 'rgba(245, 158, 11, 0.15)',
                              border: `1px solid ${alert.level === 'critical' ? 
                                'rgba(239, 68, 68, 0.3)' : 'rgba(245, 158, 11, 0.3)'}`,
                              borderRadius: '8px',
                              padding: '12px',
                              marginBottom: '16px',
                              fontSize: '14px',
                              color: alert.level === 'critical' ? '#fca5a5' : '#fcd34d',
                              fontWeight: '600'
                            }}>
                              {alert.message}
                            </div>
                          );
                        }
                        return null;
                      })()}
                      
                      {/* Payment Terms */}
                      <div style={{ marginBottom: '20px' }}>
                        <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '8px' }}>
                          Условия оплаты
                        </div>
                        <div style={{
                          display: 'inline-flex',
                          alignItems: 'center',
                          gap: '8px',
                          padding: '8px 16px',
                          background: `${paymentTermsConfig[selectedBooking.paymentTerms].color}20`,
                          border: `1px solid ${paymentTermsConfig[selectedBooking.paymentTerms].color}40`,
                          borderRadius: '8px',
                          fontSize: '15px',
                          fontWeight: '700',
                          color: paymentTermsConfig[selectedBooking.paymentTerms].color
                        }}>
                          <span style={{ fontSize: '18px' }}>
                            {paymentTermsConfig[selectedBooking.paymentTerms].icon}
                          </span>
                          {paymentTermsConfig[selectedBooking.paymentTerms].label}
                        </div>
                      </div>
                      
                      {/* Payment Method */}
                      <div style={{ marginBottom: '20px' }}>
                        <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '8px' }}>
                          Способ оплаты
                        </div>
                        <div style={{ fontSize: '15px', color: '#fff', fontWeight: '600' }}>
                          {paymentMethodConfig[selectedBooking.paymentMethod].icon} {paymentMethodConfig[selectedBooking.paymentMethod].label}
                        </div>
                      </div>
                      
                      {/* Payment Breakdown */}
                      <div style={{
                        background: 'rgba(255, 255, 255, 0.03)',
                        borderRadius: '8px',
                        padding: '16px',
                        marginBottom: '16px'
                      }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '12px' }}>
                          <span style={{ fontSize: '14px', color: '#94a3b8' }}>Общая стоимость</span>
                          <span style={{ fontSize: '14px', color: '#fff', fontWeight: '600' }}>€{selectedBooking.price.toFixed(2)}</span>
                        </div>
                        
                        {selectedBooking.depositAmount > 0 && (
                          <>
                            <div style={{ 
                              height: '1px', 
                              background: 'rgba(255, 255, 255, 0.1)', 
                              margin: '12px 0' 
                            }} />
                            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                              <span style={{ fontSize: '13px', color: '#94a3b8' }}>
                                Внесено (депозит)
                              </span>
                              <span style={{ fontSize: '13px', color: '#10b981', fontWeight: '600' }}>
                                €{selectedBooking.depositAmount.toFixed(2)}
                              </span>
                            </div>
                          </>
                        )}
                        
                        {selectedBooking.remainingAmount > 0 && (
                          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                            <span style={{ fontSize: '13px', color: '#94a3b8' }}>
                              К оплате {selectedBooking.paymentStatus === 'BALANCE_DUE' ? '(срочно)' : ''}
                            </span>
                            <span style={{ 
                              fontSize: '13px', 
                              color: selectedBooking.paymentStatus === 'BALANCE_DUE' ? '#ef4444' : '#f59e0b', 
                              fontWeight: '700' 
                            }}>
                              €{selectedBooking.remainingAmount.toFixed(2)}
                            </span>
                          </div>
                        )}
                      </div>
                      
                      {/* Payment Status Badge */}
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <div>
                          <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '4px' }}>
                            Статус оплаты
                          </div>
                          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                            <div style={{
                              width: '8px',
                              height: '8px',
                              borderRadius: '50%',
                              background: paymentStatusConfig[selectedBooking.paymentStatus].dotColor
                            }} />
                            <span className={paymentStatusConfig[selectedBooking.paymentStatus].color} style={{
                              padding: '6px 12px',
                              borderRadius: '6px',
                              fontSize: '13px',
                              fontWeight: '700',
                              display: 'inline-block'
                            }}>
                              {paymentStatusConfig[selectedBooking.paymentStatus].label}
                            </span>
                          </div>
                        </div>
                        
                        {/* Action Buttons for Payment */}
                        {(selectedBooking.paymentStatus === 'BALANCE_DUE' || selectedBooking.paymentStatus === 'UNPAID') && (
                          <button style={{
                            padding: '10px 18px',
                            background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                            border: 'none',
                            borderRadius: '8px',
                            color: '#fff',
                            fontSize: '14px',
                            fontWeight: '700',
                            cursor: 'pointer',
                            boxShadow: '0 4px 12px rgba(16, 185, 129, 0.3)'
                          }}>
                            💳 Принять оплату
                          </button>
                        )}
                      </div>
                    </div>
                  </section>

                  {selectedBooking.notes && (
                    <section style={{ marginTop: '32px' }}>
                      <h3 style={{ 
                        fontSize: '16px', 
                        fontWeight: '700', 
                        color: '#fff', 
                        marginBottom: '12px'
                      }}>
                        Заметки
                      </h3>
                      <div style={{
                        background: 'rgba(59, 130, 246, 0.1)',
                        border: '1px solid rgba(59, 130, 246, 0.2)',
                        borderRadius: '12px',
                        padding: '16px',
                        fontSize: '14px',
                        color: '#cbd5e1',
                        fontStyle: 'italic'
                      }}>
                        {selectedBooking.notes}
                      </div>
                    </section>
                  )}
                </div>
              </>
            ) : (
              <div style={{
                flex: 1,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexDirection: 'column',
                gap: '16px'
              }}>
                <Calendar size={64} style={{ color: '#334155', opacity: 0.5 }} />
                <div style={{ fontSize: '18px', color: '#64748b', fontWeight: '600' }}>
                  Выберите бронирование для просмотра деталей
                </div>
              </div>
            )}
          </div>
        )}

        {/* Analytics Tab */}
        {activeTab === 'analytics' && (
          <div style={{ flex: 1, padding: '32px', overflowY: 'auto' }}>
            <h2 style={{ fontSize: '24px', fontWeight: '700', color: '#fff', marginBottom: '24px' }}>
              Аналитика и статистика
            </h2>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '24px' }}>
              {[
                { title: 'Трансферы за месяц', value: '156', change: '+12%', color: '#3b82f6' },
                { title: 'Общая выручка', value: '€12,450', change: '+8%', color: '#10b981' },
                { title: 'Средний чек', value: '€79.80', change: '+3%', color: '#f59e0b' },
                { title: 'Коэффициент отмен', value: '4.2%', change: '-2%', color: '#ef4444' }
              ].map((stat, idx) => (
                <div key={idx} style={{
                  background: 'rgba(255, 255, 255, 0.03)',
                  border: '1px solid rgba(255, 255, 255, 0.05)',
                  borderRadius: '16px',
                  padding: '24px'
                }}>
                  <div style={{ fontSize: '14px', color: '#64748b', marginBottom: '8px' }}>
                    {stat.title}
                  </div>
                  <div style={{ fontSize: '36px', fontWeight: '700', color: stat.color, marginBottom: '8px' }}>
                    {stat.value}
                  </div>
                  <div style={{ fontSize: '13px', color: stat.change.startsWith('+') ? '#10b981' : '#ef4444' }}>
                    {stat.change} к прошлому месяцу
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Driver Picker Modal */}
      {showDriverPicker && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background: 'rgba(0, 0, 0, 0.7)',
          backdropFilter: 'blur(8px)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 1000
        }} onClick={() => setShowDriverPicker(false)}>
          <div style={{
            background: '#1e293b',
            borderRadius: '16px',
            padding: '32px',
            maxWidth: '600px',
            width: '90%',
            maxHeight: '80vh',
            overflow: 'auto',
            border: '1px solid rgba(255, 255, 255, 0.1)'
          }} onClick={e => e.stopPropagation()}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
              <h3 style={{ fontSize: '20px', fontWeight: '700', color: '#fff', margin: 0 }}>
                Выберите водителя
              </h3>
              <button 
                onClick={() => setShowDriverPicker(false)}
                style={{
                  background: 'rgba(255, 255, 255, 0.1)',
                  border: 'none',
                  borderRadius: '8px',
                  padding: '8px',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}
              >
                <X size={20} color="#94a3b8" />
              </button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              {mockDrivers.map(driver => (
                <div
                  key={driver.id}
                  onClick={() => driver.available && handleAssignDriver(selectedBooking.id, driver.id)}
                  style={{
                    background: driver.available ? 'rgba(255, 255, 255, 0.05)' : 'rgba(255, 255, 255, 0.02)',
                    border: '1px solid ' + (driver.available ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.05)'),
                    borderRadius: '12px',
                    padding: '16px',
                    cursor: driver.available ? 'pointer' : 'not-allowed',
                    opacity: driver.available ? 1 : 0.5,
                    transition: 'all 0.2s ease'
                  }}
                  onMouseEnter={e => {
                    if (driver.available) {
                      e.currentTarget.style.background = 'rgba(59, 130, 246, 0.1)';
                      e.currentTarget.style.borderColor = 'rgba(59, 130, 246, 0.3)';
                    }
                  }}
                  onMouseLeave={e => {
                    if (driver.available) {
                      e.currentTarget.style.background = 'rgba(255, 255, 255, 0.05)';
                      e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.1)';
                    }
                  }}
                >
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div>
                      <div style={{ fontSize: '16px', fontWeight: '700', color: '#fff', marginBottom: '4px' }}>
                        {driver.name}
                      </div>
                      <div style={{ fontSize: '13px', color: '#64748b', marginBottom: '4px' }}>
                        {driver.vehicle} • {driver.plate}
                      </div>
                      <div style={{ fontSize: '13px', color: '#3b82f6' }}>
                        {driver.phone}
                      </div>
                    </div>
                    <div style={{
                      padding: '6px 12px',
                      borderRadius: '6px',
                      fontSize: '12px',
                      fontWeight: '700',
                      background: driver.available ? 'rgba(16, 185, 129, 0.2)' : 'rgba(239, 68, 68, 0.2)',
                      color: driver.available ? '#10b981' : '#ef4444'
                    }}>
                      {driver.available ? 'Доступен' : 'Занят'}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Edit Form Modal */}
      {showEditForm && editingBooking && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background: 'rgba(0, 0, 0, 0.7)',
          backdropFilter: 'blur(8px)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 1000,
          padding: '20px'
        }} onClick={() => setShowEditForm(false)}>
          <div style={{
            background: '#1e293b',
            borderRadius: '16px',
            padding: '32px',
            maxWidth: '800px',
            width: '100%',
            maxHeight: '90vh',
            overflow: 'auto',
            border: '1px solid rgba(255, 255, 255, 0.1)'
          }} onClick={e => e.stopPropagation()}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
              <h3 style={{ fontSize: '20px', fontWeight: '700', color: '#fff', margin: 0 }}>
                Редактирование бронирования {editingBooking.reference}
              </h3>
              <button 
                onClick={() => setShowEditForm(false)}
                style={{
                  background: 'rgba(255, 255, 255, 0.1)',
                  border: 'none',
                  borderRadius: '8px',
                  padding: '8px',
                  cursor: 'pointer'
                }}
              >
                <X size={20} color="#94a3b8" />
              </button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                <div>
                  <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                    Имя клиента
                  </label>
                  <input
                    type="text"
                    value={editingBooking.customer.name}
                    onChange={e => setEditingBooking({
                      ...editingBooking,
                      customer: { ...editingBooking.customer, name: e.target.value }
                    })}
                    style={{
                      width: '100%',
                      padding: '12px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: '#fff',
                      fontSize: '14px'
                    }}
                  />
                </div>
                <div>
                  <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                    Телефон
                  </label>
                  <input
                    type="text"
                    value={editingBooking.customer.phone}
                    onChange={e => setEditingBooking({
                      ...editingBooking,
                      customer: { ...editingBooking.customer, phone: e.target.value }
                    })}
                    style={{
                      width: '100%',
                      padding: '12px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: '#fff',
                      fontSize: '14px'
                    }}
                  />
                </div>
              </div>

              <div>
                <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                  Email
                </label>
                <input
                  type="email"
                  value={editingBooking.customer.email}
                  onChange={e => setEditingBooking({
                    ...editingBooking,
                    customer: { ...editingBooking.customer, email: e.target.value }
                  })}
                  style={{
                    width: '100%',
                    padding: '12px',
                    background: 'rgba(255, 255, 255, 0.05)',
                    border: '1px solid rgba(255, 255, 255, 0.1)',
                    borderRadius: '8px',
                    color: '#fff',
                    fontSize: '14px'
                  }}
                />
              </div>

              <div>
                <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                  Откуда
                </label>
                <input
                  type="text"
                  value={editingBooking.pickup.address}
                  onChange={e => setEditingBooking({
                    ...editingBooking,
                    pickup: { ...editingBooking.pickup, address: e.target.value }
                  })}
                  style={{
                    width: '100%',
                    padding: '12px',
                    background: 'rgba(255, 255, 255, 0.05)',
                    border: '1px solid rgba(255, 255, 255, 0.1)',
                    borderRadius: '8px',
                    color: '#fff',
                    fontSize: '14px'
                  }}
                />
              </div>

              <div>
                <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                  Куда
                </label>
                <input
                  type="text"
                  value={editingBooking.dropoff.address}
                  onChange={e => setEditingBooking({
                    ...editingBooking,
                    dropoff: { ...editingBooking.dropoff, address: e.target.value }
                  })}
                  style={{
                    width: '100%',
                    padding: '12px',
                    background: 'rgba(255, 255, 255, 0.05)',
                    border: '1px solid rgba(255, 255, 255, 0.1)',
                    borderRadius: '8px',
                    color: '#fff',
                    fontSize: '14px'
                  }}
                />
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '16px' }}>
                <div>
                  <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                    Пассажиры
                  </label>
                  <input
                    type="number"
                    value={editingBooking.passengers}
                    onChange={e => setEditingBooking({
                      ...editingBooking,
                      passengers: parseInt(e.target.value)
                    })}
                    style={{
                      width: '100%',
                      padding: '12px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: '#fff',
                      fontSize: '14px'
                    }}
                  />
                </div>
                <div>
                  <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                    Багаж
                  </label>
                  <input
                    type="number"
                    value={editingBooking.luggage}
                    onChange={e => setEditingBooking({
                      ...editingBooking,
                      luggage: parseInt(e.target.value)
                    })}
                    style={{
                      width: '100%',
                      padding: '12px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: '#fff',
                      fontSize: '14px'
                    }}
                  />
                </div>
                <div>
                  <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                    Цена (€)
                  </label>
                  <input
                    type="number"
                    value={editingBooking.price}
                    onChange={e => setEditingBooking({
                      ...editingBooking,
                      price: parseFloat(e.target.value)
                    })}
                    style={{
                      width: '100%',
                      padding: '12px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: '#fff',
                      fontSize: '14px'
                    }}
                  />
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                <div>
                  <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                    Условия оплаты
                  </label>
                  <select
                    value={editingBooking.paymentTerms}
                    onChange={e => setEditingBooking({
                      ...editingBooking,
                      paymentTerms: e.target.value
                    })}
                    style={{
                      width: '100%',
                      padding: '12px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: '#fff',
                      fontSize: '14px'
                    }}
                  >
                    {Object.keys(paymentTermsConfig).map(key => (
                      <option key={key} value={key} style={{ background: '#1e293b', color: '#fff' }}>
                        {paymentTermsConfig[key].icon} {paymentTermsConfig[key].label}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                    Способ оплаты
                  </label>
                  <select
                    value={editingBooking.paymentMethod}
                    onChange={e => setEditingBooking({
                      ...editingBooking,
                      paymentMethod: e.target.value
                    })}
                    style={{
                      width: '100%',
                      padding: '12px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: '#fff',
                      fontSize: '14px'
                    }}
                  >
                    {Object.keys(paymentMethodConfig).map(key => (
                      <option key={key} value={key} style={{ background: '#1e293b', color: '#fff' }}>
                        {paymentMethodConfig[key].icon} {paymentMethodConfig[key].label}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                <div>
                  <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                    Статус оплаты
                  </label>
                  <select
                    value={editingBooking.paymentStatus}
                    onChange={e => setEditingBooking({
                      ...editingBooking,
                      paymentStatus: e.target.value
                    })}
                    style={{
                      width: '100%',
                      padding: '12px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: '#fff',
                      fontSize: '14px'
                    }}
                  >
                    {Object.keys(paymentStatusConfig).map(key => (
                      <option key={key} value={key} style={{ background: '#1e293b', color: '#fff' }}>
                        {paymentStatusConfig[key].label}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                    Класс машины
                  </label>
                  <input
                    type="text"
                    value={editingBooking.vehicleClass}
                    onChange={e => setEditingBooking({
                      ...editingBooking,
                      vehicleClass: e.target.value
                    })}
                    style={{
                      width: '100%',
                      padding: '12px',
                      background: 'rgba(255, 255, 255, 0.05)',
                      border: '1px solid rgba(255, 255, 255, 0.1)',
                      borderRadius: '8px',
                      color: '#fff',
                      fontSize: '14px'
                    }}
                  />
                </div>
              </div>

              <div>
                <label style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '8px', display: 'block' }}>
                  Заметки
                </label>
                <textarea
                  value={editingBooking.notes}
                  onChange={e => setEditingBooking({
                    ...editingBooking,
                    notes: e.target.value
                  })}
                  rows={3}
                  style={{
                    width: '100%',
                    padding: '12px',
                    background: 'rgba(255, 255, 255, 0.05)',
                    border: '1px solid rgba(255, 255, 255, 0.1)',
                    borderRadius: '8px',
                    color: '#fff',
                    fontSize: '14px',
                    resize: 'vertical',
                    fontFamily: 'inherit'
                  }}
                />
              </div>

              <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
                <button
                  onClick={handleSaveEdit}
                  style={{
                    flex: 1,
                    padding: '14px',
                    background: 'linear-gradient(135deg, #3b82f6 0%, #2563eb 100%)',
                    border: 'none',
                    borderRadius: '10px',
                    color: '#fff',
                    fontSize: '15px',
                    fontWeight: '700',
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    gap: '8px'
                  }}
                >
                  <Save size={18} />
                  Сохранить изменения
                </button>
                <button
                  onClick={() => setShowEditForm(false)}
                  style={{
                    padding: '14px 24px',
                    background: 'rgba(255, 255, 255, 0.05)',
                    border: '1px solid rgba(255, 255, 255, 0.1)',
                    borderRadius: '10px',
                    color: '#94a3b8',
                    fontSize: '15px',
                    fontWeight: '600',
                    cursor: 'pointer'
                  }}
                >
                  Отмена
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
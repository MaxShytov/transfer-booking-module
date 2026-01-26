from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models

from apps.core.models import TimeStampedModel


class UserManager(BaseUserManager):
    """Custom user manager with email as the unique identifier."""

    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Email is required')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self.create_user(email, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin, TimeStampedModel):
    """Custom User model with email as the unique identifier."""

    class Role(models.TextChoices):
        ADMIN = 'admin', 'Administrator'
        MANAGER = 'manager', 'Manager'
        DRIVER = 'driver', 'Driver'
        CUSTOMER = 'customer', 'Customer'

    class Language(models.TextChoices):
        EN = 'en', 'English'
        IT = 'it', 'Italiano'
        DE = 'de', 'Deutsch'
        FR = 'fr', 'Français'
        AR = 'ar', 'العربية'

    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=150, blank=True)
    last_name = models.CharField(max_length=150, blank=True)
    phone = models.CharField(max_length=20, blank=True)
    role = models.CharField(max_length=20, choices=Role.choices, default=Role.CUSTOMER)
    language = models.CharField(
        max_length=5,
        choices=Language.choices,
        default=Language.EN,
        verbose_name='Preferred Language'
    )

    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    class Meta:
        verbose_name = 'User'
        verbose_name_plural = 'Users'

    def __str__(self):
        return self.email

    @property
    def full_name(self):
        return f'{self.first_name} {self.last_name}'.strip() or self.email


class DriverProfile(TimeStampedModel):
    """Extended profile for drivers with vehicle information."""

    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='driver_profile',
        limit_choices_to={'role': 'driver'}
    )
    vehicle_plate = models.CharField(max_length=20, verbose_name='Vehicle Plate')
    vehicle_model = models.CharField(max_length=100, verbose_name='Vehicle Model')
    vehicle_class = models.ForeignKey(
        'vehicles.VehicleClass',
        on_delete=models.SET_NULL,
        null=True, blank=True,
        verbose_name='Vehicle Class'
    )
    vehicle_color = models.CharField(max_length=50, blank=True, verbose_name='Vehicle Color')
    is_available = models.BooleanField(default=True, verbose_name='Is Available')
    notes = models.TextField(blank=True, verbose_name='Notes')

    class Meta:
        verbose_name = 'Driver Profile'
        verbose_name_plural = 'Driver Profiles'

    def __str__(self):
        return f'{self.user.full_name} - {self.vehicle_model} ({self.vehicle_plate})'

"""
Django settings package.

Import from development by default for local development.
Set DJANGO_SETTINGS_MODULE environment variable to change:
- config.settings.development (default)
- config.settings.production
- config.settings.test
"""
from .development import *

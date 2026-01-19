# Generated manually on 2026-01-19
# Adds vehicle_class ForeignKey to PassengerMultiplier

import django.db.models.deletion
from django.db import migrations, models


def clear_passenger_multipliers(apps, schema_editor):
    """Clear existing PassengerMultiplier data before adding required FK."""
    PassengerMultiplier = apps.get_model('pricing', 'PassengerMultiplier')
    PassengerMultiplier.objects.all().delete()


class Migration(migrations.Migration):

    dependencies = [
        ('pricing', '0001_initial'),
        ('vehicles', '0001_initial'),
    ]

    operations = [
        # First, clear existing data (will be re-seeded with correct structure)
        migrations.RunPython(clear_passenger_multipliers, migrations.RunPython.noop),

        # Add the vehicle_class FK
        migrations.AddField(
            model_name='passengermultiplier',
            name='vehicle_class',
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name='passenger_multipliers',
                to='vehicles.vehicleclass',
                verbose_name='Vehicle Class',
            ),
            preserve_default=False,
        ),

        # Update ordering to include vehicle_class
        migrations.AlterModelOptions(
            name='passengermultiplier',
            options={
                'ordering': ['vehicle_class', 'min_passengers'],
                'verbose_name': 'Passenger Multiplier',
                'verbose_name_plural': 'Passenger Multipliers',
            },
        ),
    ]

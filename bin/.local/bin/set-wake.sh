#!/bin/bash
# Programa el wake del RTC para las 8:00 AM del próximo día

# Limpiar alarma previa
echo 0 > /sys/class/rtc/rtc0/wakealarm

# Calcular timestamp para las 8 AM del próximo día
WAKE_TIME=$(date '+%s' -d 'tomorrow 08:00:00')

# Si ya pasaron las 8 AM hoy pero antes de medianoche, usa mañana
# Si es antes de las 8 AM hoy, usa hoy
NOW=$(date '+%s')
TODAY_8AM=$(date '+%s' -d 'today 08:00:00')

if [ $NOW -lt $TODAY_8AM ]; then
    WAKE_TIME=$TODAY_8AM
fi

# Programar la alarma
echo $WAKE_TIME > /sys/class/rtc/rtc0/wakealarm

# Log para debugging
echo "Wake alarm set for: $(date -d @$WAKE_TIME)" >> /var/log/rtc-wake.log

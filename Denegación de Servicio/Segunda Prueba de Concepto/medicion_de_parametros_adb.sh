
#!/bin/bash

OUTPUT_FILE="reporte_sistema.txt"
PACKAGE="com.android.chrome"

echo "Generando reporte de sistema..." > $OUTPUT_FILE
echo "==============================" >> $OUTPUT_FILE
echo "Fecha y hora: $(date)" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Temperaturas
echo "### TEMPERATURAS (en °C)" >> $OUTPUT_FILE
THERMAL_LINE=$(adb logcat -d | grep -i thermal | tail -n 1)
if [ -z "$THERMAL_LINE" ]; then
  echo "No se encontraron datos de temperatura." >> $OUTPUT_FILE
else
  TEMP_PART=$(echo "$THERMAL_LINE" | grep -oE 'AP:[0-9]+\(.*?\) BAT:[0-9]+\(.*?\) CHG:[0-9]+\(.*?\) USB:[0-9]+\(.*?\) WIFI:[0-9]+\(.*?\) PA:[0-9]+\(.*?\)')

  declare -A TEMP_NAMES=(
    ["AP"]="Procesador (AP)"
    ["BAT"]="Batería"
    ["CHG"]="Carga"
    ["USB"]="Puerto USB"
    ["WIFI"]="WiFi"
    ["PA"]="Amplificador de potencia"
  )

  for comp in AP BAT CHG USB WIFI PA; do
    val=$(echo "$TEMP_PART" | grep -oP "$comp:\K[0-9]+")
    if [ ! -z "$val" ]; then
      celsius=$(awk "BEGIN {printf \"%.1f\", $val/10}")
      echo "${TEMP_NAMES[$comp]}: $celsius °C" >> $OUTPUT_FILE
    fi
  done
fi
echo "" >> $OUTPUT_FILE

# Nivel de batería
echo "### NIVEL DE BATERÍA" >> $OUTPUT_FILE
BATTERY_LEVEL=$(adb shell dumpsys battery | grep level | awk '{print $2}')
if [ -z "$BATTERY_LEVEL" ]; then
  echo "No se pudo obtener el nivel de batería." >> $OUTPUT_FILE
else
  echo "Nivel de batería: $BATTERY_LEVEL%" >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE


# Memoria usada por Chrome
echo "### MEMORIA USADA POR $PACKAGE" >> $OUTPUT_FILE
echo "Memoria total del sistema:" >> $OUTPUT_FILE
MEM_TOTAL_KB=$(adb shell cat /proc/meminfo | grep MemTotal | awk '{print $2}')
MEM_TOTAL_MB=$(awk "BEGIN {printf \"%.1f\", $MEM_TOTAL_KB/1024}")
echo "  $MEM_TOTAL_MB MB" >> $OUTPUT_FILE


PID=$(adb shell pidof $PACKAGE | tr -d '\r')
if [ -z "$PID" ]; then
  echo "No se encontró el proceso $PACKAGE corriendo." >> $OUTPUT_FILE
else
  echo "Memoria usada por $PACKAGE (PID $PID):" >> $OUTPUT_FILE
  MEM_INFO=$(adb shell dumpsys meminfo $PID | grep -E "^\s*TOTAL\s")
  if [ -z "$MEM_INFO" ]; then
    echo "  No se pudo obtener la memoria usada." >> $OUTPUT_FILE
  else
    MEM_USED_KB=$(echo "$MEM_INFO" | awk '{print $2}')
    MEM_USED_MB=$(awk "BEGIN {printf \"%.1f\", $MEM_USED_KB/1024}")
    echo "  $MEM_USED_MB MB (PSS Total)" >> $OUTPUT_FILE
  fi
fi

echo "" >> $OUTPUT_FILE
echo "Reporte generado en $OUTPUT_FILE"

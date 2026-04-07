#!/bin/bash

DIRECTORIO=$1
BUCKET=$2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVO="backup_${TIMESTAMP}.tar.gz"
LOG_FILE="logs/backup_${TIMESTAMP}.log"

mkdir -p logs

if [ -z "$DIRECTORIO" ] || [ -z "$BUCKET" ]; then
  echo "Uso: bash s3/backup_s3.sh <directorio> <bucket>" | tee -a "$LOG_FILE"
  exit 1
fi

if [ ! -d "$DIRECTORIO" ]; then
  echo "Error: el directorio '$DIRECTORIO' no existe." | tee -a "$LOG_FILE"
  exit 1
fi

echo "Comprimiendo $DIRECTORIO en $ARCHIVO ..." | tee -a "$LOG_FILE"
tar -czf "$ARCHIVO" "$DIRECTORIO"

if [ $? -ne 0 ]; then
  echo "Error al comprimir archivos." | tee -a "$LOG_FILE"
  exit 1
fi

echo "Subiendo $ARCHIVO a s3://$BUCKET/" | tee -a "$LOG_FILE"
aws s3 cp "$ARCHIVO" "s3://$BUCKET/$ARCHIVO" | tee -a "$LOG_FILE"

if [ $? -ne 0 ]; then
  echo "Error al subir archivo a S3." | tee -a "$LOG_FILE"
  exit 1
fi

echo "Backup subido correctamente." | tee -a "$LOG_FILE"

#!/bin/bash

DIRECTORIO=$1
BUCKET=$2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVO="backup_${TIMESTAMP}.tar.gz"

if [ -z "$DIRECTORIO" ] || [ -z "$BUCKET" ]; then
  echo "Uso: bash s3/backup_s3.sh <directorio> <bucket>"
  exit 1
fi

if [ ! -d "$DIRECTORIO" ]; then
  echo "Error: el directorio '$DIRECTORIO' no existe."
  exit 1
fi

echo "Comprimiendo $DIRECTORIO en $ARCHIVO ..."
tar -czf "$ARCHIVO" "$DIRECTORIO"

if [ $? -ne 0 ]; then
  echo "Error al comprimir archivos."
  exit 1
fi

echo "Compresión completada: $ARCHIVO"

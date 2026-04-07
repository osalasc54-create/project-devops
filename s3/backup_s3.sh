#!/bin/bash

DIRECTORIO=$1
BUCKET=$2

if [ -z "$DIRECTORIO" ] || [ -z "$BUCKET" ]; then
  echo "Uso: bash s3/backup_s3.sh <directorio> <bucket>"
  exit 1
fi

if [ ! -d "$DIRECTORIO" ]; then
  echo "Error: el directorio '$DIRECTORIO' no existe."
  exit 1
fi

echo "Parámetros válidos"
echo "Directorio: $DIRECTORIO"
echo "Bucket: $BUCKET"

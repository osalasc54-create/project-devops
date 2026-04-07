#!/bin/bash

ACCION=$1
INSTANCE_ID=$2
DIRECTORIO=$3
BUCKET=$4

if [ -z "$ACCION" ]; then
  echo "Uso: ./deploy.sh <accion_ec2> <instance_id> <directorio> <bucket>"
  exit 1
fi

echo "Ejecutando acción EC2..."
if [ "$ACCION" = "listar" ]; then
  python3 ec2/gestionar_ec2.py listar
  if [ $? -ne 0 ]; then
    echo "Error al listar instancias."
    exit 1
  fi
else
  if [ -z "$INSTANCE_ID" ]; then
    echo "Error: falta instance_id."
    exit 1
  fi

  python3 ec2/gestionar_ec2.py "$ACCION" "$INSTANCE_ID"
  if [ $? -ne 0 ]; then
    echo "Error en operación EC2."
    exit 1
  fi
fi

if [ -z "$DIRECTORIO" ] || [ -z "$BUCKET" ]; then
  echo "Error: faltan parámetros para backup S3."
  exit 1
fi

echo "Ejecutando backup S3..."
bash s3/backup_s3.sh "$DIRECTORIO" "$BUCKET"
if [ $? -ne 0 ]; then
  echo "Error en backup S3."
  exit 1
fi

echo "Deploy ejecutado correctamente."

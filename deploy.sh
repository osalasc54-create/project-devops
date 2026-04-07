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
else
  python3 ec2/gestionar_ec2.py "$ACCION" "$INSTANCE_ID"
fi

echo "Ejecutando backup S3..."
bash s3/backup_s3.sh "$DIRECTORIO" "$BUCKET"

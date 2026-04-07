#!/bin/bash

ACCION=$1
INSTANCE_ID=$2
DIRECTORIO=$3
BUCKET=$4
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="logs/deploy_${TIMESTAMP}.log"

mkdir -p logs

if [ -z "$ACCION" ]; then
  echo "Uso: ./deploy.sh <accion_ec2> <instance_id> <directorio> <bucket>" | tee -a "$LOG_FILE"
  exit 1
fi

echo "=== INICIO DEPLOY ===" | tee -a "$LOG_FILE"
echo "Acción: $ACCION" | tee -a "$LOG_FILE"
echo "Instancia: $INSTANCE_ID" | tee -a "$LOG_FILE"
echo "Directorio: $DIRECTORIO" | tee -a "$LOG_FILE"
echo "Bucket: $BUCKET" | tee -a "$LOG_FILE"

echo "Ejecutando acción EC2..." | tee -a "$LOG_FILE"
if [ "$ACCION" = "listar" ]; then
  python3 ec2/gestionar_ec2.py listar | tee -a "$LOG_FILE"
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "Error al listar instancias." | tee -a "$LOG_FILE"
    exit 1
  fi
else
  if [ -z "$INSTANCE_ID" ]; then
    echo "Error: falta instance_id." | tee -a "$LOG_FILE"
    exit 1
  fi

  python3 ec2/gestionar_ec2.py "$ACCION" "$INSTANCE_ID" | tee -a "$LOG_FILE"
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "Error en operación EC2." | tee -a "$LOG_FILE"
    exit 1
  fi
fi

if [ -z "$DIRECTORIO" ] || [ -z "$BUCKET" ]; then
  echo "Error: faltan parámetros para backup S3." | tee -a "$LOG_FILE"
  exit 1
fi

echo "Ejecutando backup S3..." | tee -a "$LOG_FILE"
bash s3/backup_s3.sh "$DIRECTORIO" "$BUCKET" | tee -a "$LOG_FILE"
if [ ${PIPESTATUS[0]} -ne 0 ]; then
  echo "Error en backup S3." | tee -a "$LOG_FILE"
  exit 1
fi

echo "=== DEPLOY EJECUTADO CORRECTAMENTE ===" | tee -a "$LOG_FILE"

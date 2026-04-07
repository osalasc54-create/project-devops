#!/usr/bin/env python3

import sys
import os
import boto3

REGION = os.getenv("AWS_DEFAULT_REGION", "us-east-1")


def listar_instancias():
    ec2 = boto3.client("ec2", region_name=REGION)
    response = ec2.describe_instances()

    for reserva in response.get("Reservations", []):
        for instancia in reserva.get("Instances", []):
            print(instancia["InstanceId"], instancia["State"]["Name"])


def iniciar_instancia(instance_id):
    ec2 = boto3.client("ec2", region_name=REGION)
    ec2.start_instances(InstanceIds=[instance_id])
    print(f"Instancia {instance_id} iniciada")


def detener_instancia(instance_id):
    ec2 = boto3.client("ec2", region_name=REGION)
    ec2.stop_instances(InstanceIds=[instance_id])
    print(f"Instancia {instance_id} detenida")


def main():
    if len(sys.argv) < 2:
        print("Uso:")
        print("listar")
        print("iniciar <instance_id>")
        print("detener <instance_id>")
        return

    accion = sys.argv[1]

    if accion == "listar":
        listar_instancias()

    elif accion == "iniciar":
        if len(sys.argv) < 3:
            print("Falta instance_id")
            return
        iniciar_instancia(sys.argv[2])

    elif accion == "detener":
        if len(sys.argv) < 3:
            print("Falta instance_id")
            return
        detener_instancia(sys.argv[2])

    else:
        print("Acción no válida")


if __name__ == "__main__":
    main()

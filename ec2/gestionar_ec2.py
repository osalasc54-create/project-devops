#!/usr/bin/env python3

import sys
import boto3

def listar_instancias():
    ec2 = boto3.client("ec2")
    response = ec2.describe_instances()

    for reserva in response["Reservations"]:
        for instancia in reserva["Instances"]:
            print(instancia["InstanceId"], instancia["State"]["Name"])

def main():
    if len(sys.argv) < 2:
        print("Uso: listar")
        return

    if sys.argv[1] == "listar":
        listar_instancias()

if __name__ == "__main__":
    main()

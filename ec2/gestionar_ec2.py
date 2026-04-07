def iniciar_instancia(instance_id):
    ec2 = boto3.client("ec2", region_name=REGION)
    ec2.start_instances(InstanceIds=[instance_id])
    print(f"Instancia {instance_id} iniciada")


elif accion == "iniciar":
    instance_id = sys.argv[2]
    iniciar_instancia(instance_id)

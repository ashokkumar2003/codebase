import boto.ec2
import sys
import paramiko
import time

autoScalingGroups = [['ashokSG', 'HostSG1']]
for asg in autoScalingGroups:
    conn = boto.ec2.connect_to_region("us-east-1",aws_access_key_id='AKIAIIF5VUJEM22UH53Q',aws_secret_access_key='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')
    reservations = conn.get_all_instances(filters={"tag:aws:autoscaling:groupName" : asg[0]})
    list_instances = ""
    host_list=''
    for reservation in reservations:
        instances = reservation.instances
        for instance in instances:
             if instance.state=='running':
                list_instances = list_instances + instance.private_ip_address + " "
    host_list = str(asg[1]) + "=("+list_instances+")"
    if not list_instances:
        list_instances=""
    else:
        print host_list

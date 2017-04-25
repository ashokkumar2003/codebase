#!/bin/bash

echo "Gitting ip list"
python /mnt/autoscaling.py > /mnt/HostMeta.txt
echo "Ip list done"

source /mnt/ServiceMeta.txt
source /mnt/HostMeta.txt
n=`cat /mnt/HostMeta.txt | wc -l`

for i in `seq 1 2`
do
    varHost="HostSG$i"
    eval "HostGroup=\${$varHost[@]}"
echo "$varHost"
echo "$HostGroup"
    for host in $HostGroup
    do
        varServices="ServicesSG$i"
        eval "ServicesGroup=\${$varServices[@]}"
         for service in $ServicesGroup
        do
            echo "------------ Deploying on $host -> $service"

        rsync -avizpg -O -e "ssh -t -i /mnt/free.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /opt/ashokcode/$service  ec2-user@$host:/var/www/html/
done

                ssh -t -i /mnt/free.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ec2-user $host "sudo service httpd status | awk '{if(\$4!=\"running\") {system(\"sudo service httpd start\")}}'"

                echo "----------- Apache service is started"

        #       echo "----------- Deploying rsyslog on $host"

#                rsync -avizpg -O -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" et/gorb-graylog-conf/$service/* pushuser@$host:/etc/rsyslog.d

        #       ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l pushuser $host "sudo service rsyslog restart"

        #       echo "----------- rsyslog service is reloded"

done

done

now=$(date +'%Y-%m-%dT-%H-%M-%S')
echo "----------- Deployed on all the servers at $now ------------"

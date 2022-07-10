#!/bin/bash

DoNotApply="0"
export K8SDOMAIN=cluster.local
export K8SREPO=zabbix
#export K8SREPO=private-repository-k8s.default.svc.cluster.local:5000
export AppNS=monitoring
export DBHOST=hippo-ha.postgres-operator.svc.${K8SDOMAIN}
export DBUSER=zabbix
export DBPWD=`kubectl -n postgres-operator get secrets hippo-pguser-zabbix -o jsonpath="{.data.password}" | base64 -d`
export DBNAME=zabbix
export SCNAME=smb-wnetconfbck01

varNS=`kubectl get namespace | grep -P "^${AppNS} +.*"`
if [ -z "${varNS}" ]; then
   echo "Creating namespace: ${AppNS}"
   kubectl create namespace ${AppNS}
fi

Debug=""
if [ ${DoNotApply} == 1 ]; then
   Debug="-d"
   echo "Only showing templates:"
fi

./kubectlwithenv.sh -f zabbix-storage.yaml ${Debug}
./kubectlwithenv.sh -f zabbix-server-statefulset.yaml ${Debug}
./kubectlwithenv.sh -f zabbix-web-deployment.yaml ${Debug}
./kubectlwithenv.sh -f zabbix-proxy-sqlite3-statefulset.yaml ${Debug}

export DBPWD=""

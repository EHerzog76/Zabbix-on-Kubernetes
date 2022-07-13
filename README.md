# Zabbix-on-Kubernetes
Zabbix on Kubernetes is a repository to add some features and software to the origanal Docker-Images from Zabbix.  
And the Kubernetes StatefulSet´s and Deployment´s needed to run Zabbix on Kubernetes.  
<ul>
<li>zabbix-server</li>
<li>zabbix-web</li>
<li>zabbix-proxy</li>
<li>zabbix-web-service => will follow</li>
<li>zabbix-storage => Storage definitions</li>
</ul>  
crunchy-postgres shows you how you can use the Crunchy-Postgres-Operator with the TimescaleDB-Extension and license "timescale".  
In the original version the license "Apache" is used, with this license type you can not use the compression feature.  

# zabbix-server
Zabbix-Server with  
<ul>
<li>python3 with easysnmp</li>
<li>perl with netsnmp</li>
</ul>

# zabbix-proxy-sqlite3-py3
Zabbix-Proxy with sqlite3 database and python3 with easysnmp.  
This version is based on:  https://github.com/zabbix/zabbix-docker/tree/5.4/Dockerfiles/proxy-sqlite3/alpine  
    with python3 and easysnmp.  

## HowTo:
### Dockerfile edit base version:
ARG MAJOR_VERSION=6.2  
ARG ZBX_VERSION=${MAJOR_VERSION}.0  

### Build:
``MAJOR_VERSION=`cat Dockerfile | grep "ARG MAJOR_VERSION" | head -n1 | cut -f2 -d"="` ``  
``MINOR_VERSION=`cat Dockerfile | grep "ARG ZBX_VERSION" | head -n1 | cut -f2 -d"."` ``  
`VCS_REF=$MAJOR_VERSION.$MINOR_VERSION`  

``docker build -t zabbix-proxy-sqlite3-py3:alpine-$VCS_REF --build-arg VCS_REF="$VCS_REF" --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` -f Dockerfile .``  

`docker image ls`
```
REPOSITORY                                          TAG                 IMAGE ID       CREATED        SIZE
zabbix-proxy-sqlite3-py3                            alpine-5.4-latest   ************   23 hours ago   134MB
```

### Tasks for Registry upload:
`export registry_address=private-repository-name`  
`export registry_port=5000`  

#### If you need to trust the Registriy-Certificate:
`mkdir -p /etc/docker/certs.d/${registry_address}:${registry_port}`  
`openssl s_client -showcerts -connect ${registry_address}:${registry_port} < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/docker/certs.d/${registry_address}:${registry_port}/ca.crt`  

### Image upload to Registry:
`docker login -u USERNAME -p **** ${registry_address}:${registry_port}`  

`docker tag zabbix-proxy-sqlite3-py3:alpine-5.4-latest ${registry_address}:${registry_port}/zabbix-proxy-sqlite3-py3:alpine-5.4-latest`  
`docker push ${registry_address}:${registry_port}/zabbix-proxy-sqlite3-py3:alpine-5.4-latest`  

### Kubernetes config:
`git clone https://github.com/EHerzog76/Zabbix-on-Kubernetes.git`  
`cd Zabbix-on-Kubernetes`  
`cd Kubernetes`  
`chmod +x zabbix-install.sh`  
`chmod +x kubectlwithenv.sh`  
#### Edit zabbix-install.sh parameters for your environments:
<ul>
<li>DoNotApply="0"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 => Show config only</li>
<li>K8SDOMAIN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cluster.local  is the default-domain</li>
<li>K8SREPO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name of the registry e.g.: private-registry:5000  or  
                                    zabbix   if you use it from hub.docker.com</li>
<li>AppNS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Namespace</li>
<li>DBHOST</li>
<li>DBUSER</li>
<li>DBPWD</li>
<li>DBNAME</li>
<li>SCNAME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name of Storageclass</li>
</ul>

`zabbix-install.sh`  

## crunchy-postgres
Optional if you use the Crunchy-Postgres-Operator and you will use the TimescaleDB-Extension with compression.  
Edit the Dockerfile for your version.  
`docker build -t crunchydata/crunchy-postgres:ubi8-13.7-0 -f Dockerfile .`  
  
In your Postgres-Cluster config add the following lines:  
`patroni:
    dynamicConfiguration:
      postgresql:
        parameters:
          shared_preload_libraries: timescaledb
          timescaledb.license: timescale  # instead of apache by default in crunchy`  

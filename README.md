# Zabbix-on-Kubernetes
Zabbix on Kubernetes is a repository to add some features and software to the origanal Docker-Images from Zabbix.  
And the Kubernetes StatefulSet´s and Deployment´s needed to run Zabbix on Kubernetes.

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
### Build:
``docker build -t zabbix-proxy-sqlite3-py3:alpine-5.4-latest --build-arg VCS_REF="5.4.10" --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` -f Dockerfile .``

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
<li>DoNotApply="0"      1...Show config only</li>
<li>K8SDOMAIN           cluster.local  is the default-domain</li>
<li>K8SREPO             Name of the registry e.g.: private-registry:5000  or  
                                    zabbix   if you use it from hub.docker.com</li>
<li>AppNS               Namespace</li>
<li>DBHOST</li>
<li>DBUSER</li>
<li>DBPWD</li>
<li>DBNAME</li>
<li>SCNAME              Name of Storageclass</li>
</ul>

`zabbix-install.sh`  

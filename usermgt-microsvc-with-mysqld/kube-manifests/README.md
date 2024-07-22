# USED KIND CLUSTER K8S
# Create Cluster
kind create cluster --config kind-nodePort.yaml

# How to log in to kind-control-plane node
docker exec -it kind-control-plane bash

# Listing the servers created
grep server ~/.kube/config

# GET CONTEXT
kubectl config get-contexts

# USE CONTEXT
kubectl config use-context kind-kind
Switched to context "kind-kind".

# GET CLUSTER
kind get clusters
kind

kubectl get nodes --context kind-kind
NAME                 STATUS   ROLES           AGE   VERSION
kind-control-plane   Ready    control-plane   61m   v1.30.0
kind-worker          Ready    <none>          60m   v1.30.0
kind-worker2         Ready    <none>          60m   v1.30.0

# DELETE CLUSTER
kind delete cluster --name kind
kind delete cluster --name mycluster

# SSH INTO KIND NODES -https://stackoverflow.com/questions/69108075/how-to-ssh-into-kind-cluster-nodes-with-containerd-runtime
docker ps -a  --(Take a look at the NAMES column - here are nodes names used in Kubernetes)

docker exec -it kind-worker2 sh   _(make sure this path is created on node kind-worker2 "mkdir -p /mnt/disks/vol1")

# ls -- bin  boot  dev  etc  home  kind  lib  lib32  lib64  libx32  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

# ip a  --(Check if the IP address matches the IP address from the kubectl get nodes command)

# Usermgmt-microsvc-with-mysqld
k apply -f kube-manifest/

k apply -f kube-manifest/ -n dev1 or dev2 or dev3   (Can use this when namespace is not hardcoded into each manifest files)

k delete -f kube-manifest/ -n dev1 or dev2 or dev3

k delete ns dev3 -- (this alone will delete all resources created in the dev1 namespace)

k -n dev3 get pods,svc
k -n dev3 get sc,pv,pvc  - Created PV config due to using local storage rather than ebs storage
k -n dev3 get quota

# In order to access the apps, run the below command according to the Pod svc name
k -n dev3 port-forward service/usermgmt-restapp-service 8095:8095

curl -v http://127.0.0.1:8095/usermgmt/health-status or curl -v http://localhost:8095/usermgmt/health-status

# To see pods making use of a node
k describe node kind-worker

# Download Postman client
https://www.postman.com/downloads/

# Import Project to Postman
Import the postman project AWS-EKS-Masterclass-Microservices.postman_collection.json 

Create Environment in Postman

Go to Settings -> Click on Add

Environment Name: UMS-NodePort
Variable: url
Initial Value: http://WorkerNode-Public-IP:31231  # Since I made use of Kind k8s cluster http://127.0.0.1:30950
Current Value: http://WorkerNode-Public-IP:31231  # Since I made use of Kind k8s cluster http://127.0.0.1:30950
Click on Add

Test User Management Services
Select the environment before calling any API
Health Status API
URL: {{url}}/usermgmt/health-status
Create User Service
URL: {{url}}/usermgmt/user
url variable will replaced from environment we selected
    {
        "username": "admin1",
        "email": "obi@gmail.com",
        "role": "ROLE_ADMIN",
        "enabled": true,
        "firstname": "fname1",
        "lastname": "lname1",
        "password": "Pass@123"
    }
List User Service

URL: {{url}}/usermgmt/users
Update User Service

URL: {{url}}/usermgmt/user
    {
        "username": "admin1",
        "email": "david@gmail.com",
        "role": "ROLE_ADMIN",
        "enabled": true,
        "firstname": "fname2",
        "lastname": "lname2",
        "password": "Pass@123"
    }
Delete User Service
URL: {{url}}/usermgmt/user/admin1
Step-05: Verify Users in MySQL Database
# Connect to MYSQL Database
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -u root -pdbpassword12  --This always fails

kubectl exec -it mysql-5b875849fd-cx2q4 -- /bin/sh
# root@mysql-5b875849fd-cx2q4:/# mysql -u root --password=dbpassword12
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.6.51 MySQL Community Server (GPL)

Copyright (c) 2000, 2021, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show schemas;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| usermgmt           |
+--------------------+
4 rows in set (0.06 sec)

# Verify usermgmt schema got created which we provided in ConfigMap
mysql> show schemas;
mysql> use usermgmt;
mysql> show tables;
mysql> select * from users;

# Step-06: Clean-Up
# Delete All
kubectl delete -f kube-manifests/

# List Pods
kubectl -n dev3 get pods

# Verify sc, pvc, pv
kubectl -n dev3 get sc,pvc,pv

# USED KIND CLUSTER K8S
# Create Cluster
kind create cluster --config kind-nodePort.yaml

# Usermgmt-microsvc-with-mysqld
k apply -f kube-manifest/

k -n dev3 get pods,svc
k -n dev3 get sc,pv,pvc  - Created PV config due to using local storage rather than ebs storage

# In order to access the apps, run the below command according to the Pod svc name

k -n dev3 port-forward service/usermgmt-restapp-service 8095:8095

curl -v http://127.0.0.1:8095/usermgmt/health-status or curl -v http://localhost:8095/usermgmt/health-status

# Download Postman client
https://www.postman.com/downloads/

# Import Project to Postman
Import the postman project AWS-EKS-Masterclass-Microservices.postman_collection.json 
Create Environment in postman
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

mysql> use usermgmt
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+--------------------+
| Tables_in_usermgmt |
+--------------------+
| users              |
+--------------------+
1 row in set (0.00 sec)

mysql> select * from users;
+----------+---------------+---------+-----------+----------+--------------------------------------------------------------+------------+
| username | email         | enabled | firstname | lastname | password                                                     | role       |
+----------+---------------+---------+-----------+----------+--------------------------------------------------------------+------------+
| admin1   | obi@gmail.com |        | fname1    | lname1   | $2a$04$6YPiw1CLaPB4Rky15nIUdODHyXKy3uOVX6l4WCl6TG6cOArgZUxMe | ROLE_ADMIN |
+----------+---------------+---------+-----------+----------+--------------------------------------------------------------+------------+
1 row in set (0.00 sec)

mysql> select * from users;
+------------+------------------------+---------+------------+------------+--------------------------------------------------------------+------------+
| username   | email                  | enabled | firstname  | lastname   | password                                                     | role       |
+------------+------------------------+---------+------------+------------+--------------------------------------------------------------+------------+
| admin1     | obi@gmail.com          |        | fname1     | lname1     | $2a$04$6YPiw1CLaPB4Rky15nIUdODHyXKy3uOVX6l4WCl6TG6cOArgZUxMe | ROLE_ADMIN |
| microtest1 | dkalyanreddy@gmail.com |        | MicroFName | MicroLname | $2a$04$tN2m2OWFB/iRJuW4vu45kuAfAcq/sdhLi//suuTv5cti1lH3csNh2 | ROLE_ADMIN |
+------------+------------------------+---------+------------+------------+--------------------------------------------------------------+------------+
2 rows in set (0.00 sec)

mysql> select * from users;  # Added from Postman
+------------+------------------------+---------+-------------+-------------+--------------------------------------------------------------+------------+
| username   | email                  | enabled | firstname   | lastname    | password                                                     | role       |
+------------+------------------------+---------+-------------+-------------+--------------------------------------------------------------+------------+
| admin1     | obi@gmail.com          |        | fname1      | lname1      | $2a$04$6YPiw1CLaPB4Rky15nIUdODHyXKy3uOVX6l4WCl6TG6cOArgZUxMe | ROLE_ADMIN |
| microtest1 | dkalyanreddy@gmail.com |        | MicroFName  | MicroLname  | $2a$04$tN2m2OWFB/iRJuW4vu45kuAfAcq/sdhLi//suuTv5cti1lH3csNh2 | ROLE_ADMIN |
| sql-test   | david@gmail.com        |        | MicroFName1 | MicroLname1 | $2a$04$Ys1PxkN3FO327Nh5PCkWIOl9J0CaagA.o73O0QvwipBy817Kn0gzG | ROLE_ADMIN |
+------------+------------------------+---------+-------------+-------------+--------------------------------------------------------------+------------+
3 rows in set (0.00 sec)
mysql> select * from users;  # updated from Postman
+------------+------------------------+---------+-------------+-------------+--------------------------------------------------------------+------------+
| username   | email                  | enabled | firstname   | lastname    | password                                                     | role       |
+------------+------------------------+---------+-------------+-------------+--------------------------------------------------------------+------------+
| admin1     | dad@gmail.com          |        | fname3      | lname3      | $2a$04$6YPiw1CLaPB4Rky15nIUdODHyXKy3uOVX6l4WCl6TG6cOArgZUxMe | ROLE_ADMIN |
| microtest1 | dkalyanreddy@gmail.com |        | MicroFName  | MicroLname  | $2a$04$tN2m2OWFB/iRJuW4vu45kuAfAcq/sdhLi//suuTv5cti1lH3csNh2 | ROLE_ADMIN |
| sql-test   | david@gmail.com        |        | MicroFName1 | MicroLname1 | $2a$04$Ys1PxkN3FO327Nh5PCkWIOl9J0CaagA.o73O0QvwipBy817Kn0gzG | ROLE_ADMIN |
+------------+------------------------+---------+-------------+-------------+--------------------------------------------------------------+------------+
3 rows in set (0.00 sec)

mysql> select * from users;  # deleted sql-test from Postman
+------------+------------------------+---------+------------+------------+--------------------------------------------------------------+------------+
| username   | email                  | enabled | firstname  | lastname   | password                                                     | role       |
+------------+------------------------+---------+------------+------------+--------------------------------------------------------------+------------+
| admin1     | dad@gmail.com          |        | fname3     | lname3     | $2a$04$6YPiw1CLaPB4Rky15nIUdODHyXKy3uOVX6l4WCl6TG6cOArgZUxMe | ROLE_ADMIN |
| microtest1 | dkalyanreddy@gmail.com |        | MicroFName | MicroLname | $2a$04$tN2m2OWFB/iRJuW4vu45kuAfAcq/sdhLi//suuTv5cti1lH3csNh2 | ROLE_ADMIN |
+------------+------------------------+---------+------------+------------+--------------------------------------------------------------+------------+
2 rows in set (0.00 sec)

# Step-06: Clean-Up
# Delete All
kubectl delete -f kube-manifests/

# List Pods
kubectl -n dev3 get pods

# Verify sc, pvc, pv
kubectl -n dev3 get sc,pvc,pv
https://kind.sigs.k8s.io/docs/user/ingress/
https://kind.sigs.k8s.io/docs/user/configuration/
https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/
https://stackoverflow.com/questions/62432961/how-to-use-nodeport-with-kind - Deploying Kind to make use of NodePort

# Create Cluster
kind create cluster --config kind-nodePort.yaml

k apply -f simple-deploy.yaml

# Ingress Demo
k apply -f apps.yaml
k apply -f app-ingress-rules.yaml
k apply -f deploy-lab.yaml


# In order to access the apps, run the below command according to the Pod svc name
k port-forward service/nginx-service 8080:80
k port-forward service/petclinic-svc 8081:80
k -n dev3 port-forward service/usermgmt-restapp-service 8095:8095

curl -v http://127.0.0.1:8095/usermgmt/health-status or curl -v http://localhost:8095/usermgmt/health-status

curl -v localhost:30950
curl localhost:8080
http://127.0.0.1:8080/
http://127.0.0.1:8081/petclinic/

VIEW AS XML FILE OR JSON
http://127.0.0.1:8081/petclinic/vets.json
http://127.0.0.1:8081/petclinic/vets.xml

https://127.0.0.1:38311

# Log in to kind-control-plane node
==>docker exec -it kind-control-plane bash

# Listing the servers created
grep server ~/.kube/config
server: https://0.0.0.0:38247
server: https://127.0.0.1:43481

kubectl config get-contexts

kubectl get nodes --context kind-kind
NAME                 STATUS   ROLES           AGE   VERSION
kind-control-plane   Ready    control-plane   61m   v1.30.0
kind-worker          Ready    <none>          60m   v1.30.0
kind-worker2         Ready    <none>          60m   v1.30.0
kind-worker3         Ready    <none>          60m   v1.30.0

# USE CONTEXT
kubectl config use-context kind-kind
Switched to context "kind-kind".

# GET CLUSTER
kind get clusters
kind

# DELETE CLUSTER
kind delete cluster --name kind
kind delete cluster --name mycluster

# SSH INTO KIND NODES -https://stackoverflow.com/questions/69108075/how-to-ssh-into-kind-cluster-nodes-with-containerd-runtime
docker ps -a  --(Take a look at the NAMES column - here are nodes names used in Kubernetes)

docker exec -it kind-worker2 sh


# NodePort with Port Mappings
To use port mappings with NodePort, the kind node containerPort and the service nodePort needs to be equal.

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30950
    hostPort: 80

# And then set nodePort to be 30950.
kind: Pod
apiVersion: v1
metadata:
  name: foo
  labels:
    app: foo
spec:
  containers:
  - name: foo
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=foo"
    ports:
    - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: foo
spec:
  type: NodePort
  ports:
  - name: http
    nodePort: 30950
    port: 5678
  selector:
    app: foo

# Extra labels might be useful for working with nodeSelectors.
An example label for specifying a tier label:

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
  - containerPort: 30950
    hostPort: 80
  labels:
    tier: frontend
- role: worker
  labels:
    tier: backend
#!/bin/bash

export APP_NAME=${1:-example}
export IP=$2
export HOSTNAME=`hostname`
export INGRESS_HOST="${APP_NAME}.${HOSTNAME}.k8slocal"

echo "**** Deploy cluster with params"
echo "APP_NAME: $APP_NAME"
echo "IP: $IP"
echo "INGRESS_HOST: $INGRESS_HOST"
echo "HOSTNAME: $HOSTNAME"

# Call script in base box to create a kind cluster
# See: https://github.com/ricardojlrufino/vagrant-box-bionic64-kind/blob/master/runtime_files/bootstrap_kind_cluster.sh
/home/vagrant/runtime_files/bootstrap_kind_cluster.sh $IP

echo "Wait.. for ingress controller (node) up"
#kubectl wait --for=condition=Ready --timeout=600s pod --namespace ingress-nginx  --selector=app.kubernetes.io/component=controller 
kubectl rollout status -w --namespace ingress-nginx deployment/ingress-nginx-controller --timeout=600s

# Goto mounted app folder
cd /vagrant/nginx-app-example

echo "**** Building app"

TAG="localhost:5000/${APP_NAME}:latest"
docker build --tag="$TAG" .
docker push "$TAG"

echo "**** End Building app"


# Save kubeconfig
mkdir -p /home/vagrant/.kube
kind get kubeconfig --name $(hostname) >  /home/vagrant/.kube/config

# host files
mkdir -p /vagrant/.kube
kind get kubeconfig --name $(hostname) > /vagrant/.kube/$(hostname)

echo "**** Deploy into cluster .."

envsubst < ./example-namespace.yml  | kubectl apply -f -
envsubst < ./example-service.yml  | kubectl apply -f -
envsubst < ./example-deployment.yml  | kubectl apply -f -
envsubst < ./example-ingress.yml  | kubectl apply -f -

echo "wait for app pods..."
kubectl wait --for=condition=ready --timeout=30s pod -l app=${APP_NAME} -n ${APP_NAME}

echo "**** END Deploy into cluster .."

Purple='\033[0;35m'       # Purple
NC='\033[0m'       # Text Reset


echo -e "${Purple}"
echo "***************************************""***************************************"
echo " Cluster '$(hostname)' is ready to play !"
echo " Configure in your host machine ....."
echo "***************************************"
echo "Configure your kubectl with (project)/.kube/$(hostname)"
echo "Ex. export KUBECONFIG=\$(pwd)/.kube/cluster2:\$(pwd)/.kube/cluster1"
echo "***************************************"
echo "Configure your /etc/hosts with"
echo "${IP}	${INGRESS_HOST}"
echo "***************************************"
echo "Deploy app you can run /vagrant/deploy_example.sh \"$APP_NAME\" \"$IP\"     (inside you box)"
echo "${IP}	${INGRESS_HOST}"
echo "***************************************"
echo -e "${NC}"

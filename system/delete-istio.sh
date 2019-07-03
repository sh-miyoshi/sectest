#!/bin/bash

ISTIO_VERSION="1.2.2"

NAME="istio-$ISTIO_VERSION"
ls $NAME > /dev/null 2>&1
# if istio data is not download yet
if [ $? != 0 ]; then
  echo "Istio v$ISTIO_VERSION is not installed"
  exit 1
fi

helm template $NAME/install/kubernetes/helm/istio --name istio -f helm_values.yaml --namespace istio-system > istio-install.yaml
kubectl delete -f istio-install.yaml

helm template $NAME/install/kubernetes/helm/istio-init --name istio-init --namespace istio-system > istio-init-install.yaml
kubectl delete -f istio-init-install.yaml

kubectl delete -f $NAME/install/kubernetes/helm/istio-init/files
kubectl delete namespace istio-system

# rm -f istio-install.yaml
# rm -f istio-init-install.yaml

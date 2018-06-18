#!/bin/bash

kubectl delete -f istio/rbac --ignore-not-found=true

kubectl delete -f istio/secret.yaml
kubectl delete -f istio/frontend-ingress-gateway.yaml

kubectl delete -f mysql.yaml
kubectl delete -f mysql-apiserver.yaml
kubectl delete -f frontend.yaml

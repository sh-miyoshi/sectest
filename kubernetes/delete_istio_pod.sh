#!/bin/bash

#kubectl apply -f istio/secret.yaml
kubectl delete -f istio/frontend-ingress-gateway.yaml

kubectl delete -f mysql.yaml
kubectl delete -f mysql-apiserver.yaml
kubectl delete -f frontend.yaml

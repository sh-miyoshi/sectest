#!/bin/bash

#kubectl apply -f istio/secret.yaml
kubectl apply -f istio/frontend-ingress-gateway.yaml

kubectl apply -f <( istioctl kube-inject -f mysql.yaml )
kubectl apply -f <( istioctl kube-inject -f mysql-apiserver.yaml )
kubectl apply -f <( istioctl kube-inject -f frontend.yaml )

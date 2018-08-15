# Security Test Demo

## Overview

This is a demo of security in kubernetes and Istio.
This includes what problem are there in a service on kubernetes, and how to protect by Istio.

## Prerequire

- Istio
  - To deploy apps in Istio, install Istio to your Kubernetes cluster.  
  please see more detail at [official page](https://istio.io/docs/setup/kubernetes/quick-start/)
  - you can install istio by following steps.
    - curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash (Install helm command)
    - cd system
    - vi helm_values.yaml (If you need)
    - ./install-istio.sh

- Nginx Ingress Controller
  - In order to deploy sample apps without Istio, `sectest` requires Nginx Ingress Controller.
  - you can install Nginx Ingress Controller by following steps.
    - kubectl apply -f system/ingress-controller-nginx.yaml

## Usage

1. deploy sample application
    - create secret file
    ``` text
    cd kubernetes
    ./make_secret.sh
    ```

    - deploy apps by kubectl command and access from your web browser
    ``` text
    cd kubernetes
    kubectl apply -f .
    * access to https://<ingress-controller-address>
    ```

    - check program  
    please input user name and password. If your apps works normally, you can get secret message.
    ``` text
    User: "root"
    Password: "ossj_sectest"
    ```

2. create attacker and protect by Istio  
    please see attacker/command_docs/\*.txt and attacker/command_docs/countermeasure/\*.txt for more detail.

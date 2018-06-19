# Security Test Demo

## Overview

This is a demo of security in kubernetes and Istio.
This includes what problem are there in a service on kubernetes, and how to protect by Istio.

## Prerequire

- istioctl command  
  please see [official page](https://istio.io/docs/setup/kubernetes/quick-start/)

## Usage

1. Install Ingress Controller(if you need)
    - sample application use Ingress. so you need to install ingress controller.
    ``` text
    kubectl apply -f system/ingress-controller-nginx.yaml
    ```

2. Install Istio(if you need)
    - Please install Istio. (This tool uses Istio Ingress Controller. It is old version tool but it's useful for https communication.)
    ``` text
    kubectl apply -f system/istio_system.yaml
    ```

3. deploy sample application
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

4. create attacker and protect by Istio  
    please see attacker/command_docs/*.txt and attacker/command_docs/countermeasure/*.txt for more detail.


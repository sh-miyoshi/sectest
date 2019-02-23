# Attack Demo

## Overview

This is a demo of basic security in Kubernetes and Istio.  
This includes what problem are there in a service on Kubernetes, and how to protect by Istio.  
This demo was used in [Open Source Summit Japan 2018](https://events.linuxfoundation.jp/events/open-source-summit-japan-2018/).  
The slides of demo overview are [here](https://speakerdeck.com/smiyoshi/advanced-security-on-kubernetes-with-istio?slide=23).

![image](image.png)

## Attack Overview

1. Wiretap  
    attacker try to wiretap the communication in kubernetes cluster.
2. Spoofing(Already Password Leaked)  
    attacker try to get secret information by using password.
3. Worse Case Spoofing(Already Password and Certificate Leaked)  
    attacker try to get secret information by using password and Istio certificate.

## Prerequire

This demo requires Istio and Ingress Controller.  
In order to deploy sample apps without Istio, `sectest` requires Ingress Controller.

- Istio
  - Please see [official page](https://istio.io/docs/setup/kubernetes/quick-start/).
  - Or you can install istio by following steps.
    - git clone [https://github.com/sh-miyoshi/sectest.git](https://github.com/sh-miyoshi/sectest.git) (checkout this repository)
    - cd system
    - vi helm_values.yaml (If you need)
    - ./install-istio.sh

- Ingress Controller
  - You can use Ingress Controller of Managed Kubernetes Services(GKE, AKS, EKS, ...)
  - Or install Nginx Ingress Controller locally by following step.
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

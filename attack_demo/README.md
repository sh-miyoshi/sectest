# Attack Demo

<!-- TOC -->

- [Attack Demo](#attack-demo)
	- [Overview](#overview)
	- [Demo Contents](#demo-contents)
	- [Wiretap Usage](#wiretap-usage)
		- [Steps](#steps)
	- [Spoofing(Already Password Leaked) Usage](#spoofingalready-password-leaked-usage)
	- [Worse Case Spoofing(Already Password and Certificate Leaked) Usage](#worse-case-spoofingalready-password-and-certificate-leaked-usage)

<!-- /TOC -->

## Overview

This directory includes following demos.

## Demo Contents

1. Wiretap  
    attacker try to wiretap the communication in kubernetes cluster.
2. Spoofing(Already Password Leaked)  
    attacker try to get secret information by using password.
3. Worse Case Spoofing(Already Password and Certificate Leaked)  
    attacker try to get secret information by using password and Istio certificate.

## Wiretap Usage

This section tells you how to wiretap between kubernetes services.
We can wiretap by tcpdump command.

### Steps

1. deploy apps without Istio

    ```bash
    cd /path/to/sectest
    cd kubernetes
    ./make_secret.sh
    kubectl apply -f .
    ```

2. wiretap by tcpdump

    ```bash
    kubectl get pods -o wide
    *) copy ip address of mysql-apiserver pod as <pod-ip>
    cd /path/to/sectest/attacker
    kubectl apply -f attacker.yaml
    kubectl exec -it attacker bash -n dangerarea
    tcpdump -xX -B 65536 dst host <pod-ip> and port 4567 -i weave
    ```

3. delete apps

    ```bash
    cd /path/to/sectest/kubernetes
    kubectl delete -f .
    ```

4. countermeasure by using Istio mTLS

    This attack can protect by using Istio mTLS.  
    So, first of all, please deploy Istio by mTLS mode.  
    Then, deploy apps with Istio.

    ```bash
    cd /path/to/sectest/kubernetes
    ./make_secret.sh   *If you have not run
    ./istio_deploy.sh
    ```

5. check protection

    wiretap again by step 2, and check result

6. delete Istio apps

    ```bash
    cd /path/to/sectest/kubernetes
    ./delete_istio_pod.sh
    ```

## Spoofing(Already Password Leaked) Usage

This section tells you about spoofing.  
MySQL DB password was already leaked, and attacker try to connect with the password.

### Steps

1. deploy apps without Istio

    ```bash
    cd /path/to/sectest
    cd kubernetes
    ./make_secret.sh
    kubectl apply -f .
    ```

2. spoofing by using password

    ```bash
    cd /path/to/sectest/attacker
    kubectl apply -f attacker.yaml
    kubectl exec -it attacker bash -n dangerarea
    nslookup mysql-apiserver.default.svc.cluster.local 10.96.0.10
    *) save ip address as <svc-ip>
    curl -XPOST http://<svc-ip>:4567/api -d '{"user":"root", "password":"ossj_sectest"}'
    ```

3. delete apps

    ```bash
    cd /path/to/sectest/kubernetes
    kubectl delete -f .
    ```

## Worse Case Spoofing(Already Password and Certificate Leaked) Usage

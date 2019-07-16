# Spoofing(Already Password Leaked)

This file tells you about spoofing.  
MySQL DB password was already leaked, and attacker try to connect with the password.

## Steps

1. deploy apps without Istio

    ```bash
    cd /path/to/sectest
    cd kubernetes
    ./make_secret.sh
    kubectl apply -f .
    ```

2. spoofing by using password

    ```bash
    cd /path/to/sectest/apps/attacker
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

## What's happened

(TODO)

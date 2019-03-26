# How to Wiretap and its Countermeasure

This file show how to wiretap between kubernetes services, and its countermeasure.
We can wiretap by tcpdump command.

## Steps

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

## What's happened

(TODO)
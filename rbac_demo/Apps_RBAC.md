# Apps RBAC

## Overview

This file shows how to use Istio RBAC for basic application.

## Usage

1. deploy Istio

    Deploy Istio to your cluster with **mTLS mode**.

2. deploy apps with Istio sidecar

    ```bash
    cd /path/to/sectest/kubernetes
    ./istio_deploy.sh
    ```

3. check access to your app

    Open your brower, and access to [https://\<istio-gateway-addr\>](https://localhost:31390).  
    You should be able to access the app.  
    In this app, if you input {name: root, password: ossj_sectest}, you can get _very secret_ information.

4. enabling Istio RBAC

    ```bash
    cd /path/to/sectest/kubernetes
    kubectl apply -f istio/rbac/istio-rbac-enable.yaml
    ```

5. check access to your app

    Open your brower, and access to [https://\<istio-gateway-addr\>](https://localhost:31390).  
    If RBAC enabled, you can see following message.  
    \*) It may take a few minutes.

    ```text
    RBAC: access denied
    ```

6. allow access to the app

    ```bash
    cd /path/to/sectest/kubernetes
    kubectl apply -f istio/rbac/rbac-apiserver.yaml
    kubectl apply -f istio/rbac/rbac-frontend.yaml
    kubectl apply -f istio/rbac/rbac-mysql.yaml
    ```

7. check access to your app

    Open your brower, and access to [https://\<istio-gateway-addr\>](https://localhost:31390).  
    You should be able to access the app.

8. delete apps

    ```bash
    cd /path/to/sectest/kubernetes
    ./delete_istio_pod.sh
    ```
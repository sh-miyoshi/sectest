# Apps RBAC

## Overview

このファイルではIstio RBACの使用方法について述べる。

## Usage

1. Istioのデプロイ

    Istioを**mTLS mode**をONにしてクラスタにデプロイしてください。

2. アプリのデプロイ

    ```bash
    cd /path/to/sectest/kubernetes
    ./istio_deploy.sh
    ```

3. アプリの動作確認

    ブラウザを開き、[https://\<istio-gateway-addr\>](https://localhost:31390)にアクセスする。  
    正常通りアプリが動作していることを確認する  
    アプリ上で {name: root, password: ossj_sectest}を入力すると, _very secret information_を取得できるはずです。

4. Istio RBACを有効化する

    ```bash
    cd /path/to/sectest/kubernetes
    kubectl apply -f istio/rbac/istio-rbac-enable.yaml
    ```

5. 再度アプリの動作確認

    ブラウザを開き、[https://\<istio-gateway-addr\>](https://localhost:31390)にアクセスする。  
    もしRBACが有効であれば、以下のようなメッセージが表示されます  
    \*) 若干時間がかかる場合があります

    ```text
    RBAC: access denied
    ```

6. Istio RBACでアプリ通信を許可する

    ```bash
    cd /path/to/sectest/kubernetes
    kubectl apply -f istio/rbac/rbac-apiserver.yaml
    kubectl apply -f istio/rbac/rbac-frontend.yaml
    kubectl apply -f istio/rbac/rbac-mysql.yaml
    ```

7. 再度アプリの動作確認

    ブラウザを開き、[https://\<istio-gateway-addr\>](https://localhost:31390)にアクセスする。  
    再度アクセスできるようになっているはずです。

8. アプリの削除

    ```bash
    cd /path/to/sectest/kubernetes
    ./delete_istio_pod.sh
    ```

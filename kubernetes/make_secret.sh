#!/bin/bash

tmpdir=$(mktemp -d)
cd $tmpdir
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=sectest.miyoshi.local"

crt_value=`base64 tls.crt | tr -d '\n'`
key_value=`base64 tls.key | tr -d '\n'`

cd -

cat << EOF > secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: frontend-tls
  namespace: default
type: kubernetes.io/tls
data:
  tls.crt: ${crt_value}
  tls.key: ${key_value}
EOF

mkdir -p istio
cat << EOF > istio/secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: istio-ingressgateway-certs
  namespace: istio-system
type: kubernetes.io/tls
data:
  tls.crt: ${crt_value}
  tls.key: ${key_value}
EOF

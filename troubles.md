# Troubles

## Overview

This file introduces the various troubles I encountered.  
This is just for myself, but I hope useful to someone.

- Case 1
  - repro steps
    ```
      kubectl apply -f jwt-example.yaml
      curl -k https://10.130.116.37:31390/admin/info
    ```
  - error messages
    - curl result
      ```
        Status Code: 503
        Message: upstream connect error or disconnect/reset before headers
      ```
    - istio pilot(discovery) log
      ```
        Failed to fetch pubkey from "https://raw.githubusercontent.com/istio/istio/release-1.0/security/tools/jwt/samples/jwks.json": Get https://raw.githubusercontent.com/istio/istio/release-1.0/security/tools/jwt/samples/jwks.json: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
      ```

# CICD
This repo is meant to setup CICD capabilities, that can be used by various services.

# Instruction to setup
## Run the script setup.sh. It does following things:
* All the following resources are created on current K8 context/cluster
* Create a namespace called ```ns-mycicd```
* Setup Argo separately by pointing to k8 manifests from external location
* Apply the application.yaml K8 manifests for all capabilities to make sure relevant capabilities are deployed on K8.
* Port forward so that relevant functionality is available on host machine on specific ports.

# Capabilities
Please look at README inside specific capability git path to understand specifics

## Argo
```Git Path = /argocd```
```Port exposed = 8090```

## Jenkins
```Git Path = /jenkins```
```Port exposed = 8091```

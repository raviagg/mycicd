# argocd
ArgoCD

# Step 1: Create namespace
```kubectl create namespace argocd```

# Step 2: Install Argo
```kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml```

# Step 3: Access UI
```kubectl port-forward svc/argocd-server -n argocd 8090:443```

- URL => https://localhost:8090
- username => admin
- password => ??

## To get password
```kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo```

# FAQ
Sometimes argo is not able to pull data from git, reason usually is that argocd repo-server is not working, you can verify that by looking at pods of argocd namespace. If yes, then restart the repo-server
- ```kubectl rollout restart deploy/argocd-repo-server -n argocd```
- Here is an example
```
raaggarw@Ravis-MacBook-Pro kafka % kubectl -n argocd get pods

NAME                                                READY   STATUS             RESTARTS          AGE
argocd-application-controller-0                     1/1     Running            2 (166m ago)      8d
argocd-applicationset-controller-6799596c7c-fvrps   0/1     CrashLoopBackOff   576 (3m12s ago)   8d
argocd-dex-server-5cb8756cf7-vqlv7                  1/1     Running            3 (166m ago)      8d
argocd-notifications-controller-5cd8948d4b-m6tvs    1/1     Running            2 (166m ago)      8d
argocd-redis-59784bcdb7-kjlgt                       1/1     Running            2 (166m ago)      8d
argocd-repo-server-55554c56cd-wzsrd                 0/1     Unknown            0                 5d18h
argocd-server-7488fb8dbf-vm8pc                      1/1     Running            2 (166m ago)      8d
```

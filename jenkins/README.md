# myjenkins
Jenkins

***************************************
Some useful commands
***************************************

To get the password for Jenkins UI
```kubectl exec -n ns-mycicd deploy/deploy-mycicd-jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword```

To port forward
```kubectl port-forward svc/svc-mycicd-jenkins -n ns-mycicd 8091:8080 &```

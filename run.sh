# Create argocd namespace
kubectl create ns argocd
echo "**** Namespace argocd created"

# Create shared namespace
kubectl create ns ns-mycicd
echo "**** Namespace ns-mycicd created"

#########################
# Argo Setup
#########################
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "**** Deployed argo in K8, waiting for pods to be ready for 5secs"

# kubectl wait --for=condition=ready service -l app.kubernetes.io/part-of=argocd --timeout=30s
# kubectl wait --for=create secret/argocd-initial-admin-secret -n argocd --timeout=30s
sleep 5
echo "**** 5secs wait is completed"

kubectl port-forward svc/argocd-server -n argocd 8090:443 &
echo "**** Port forwarded argo service to 8090"

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
echo "**** Connect to argo on localhost:8090, with username=admin and password printed above"

#########################
# Jenkins Setup
#########################
cd jenkins
kubectl apply -f application.yaml
echo "**** Deployed jenkins in K8, waiting for pods to be ready for 5secs"

sleep 5
echo "**** 5secs wait is completed"

cd ..
kubectl port-forward svc/svc-mycicd-jenkins -n ns-mycicd 8091:8080 &
echo "**** Connect to jenkins on localhost:8091"

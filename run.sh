# Create argocd namespace
kubectl create ns argocd
echo "**** Namespace argocd created"

# Create shared namespace
GROUP=mycicd
NS_CICD=ns-${GROUP}
kubectl create ns ${NS_CICD}
echo "**** Namespace ${NS_CICD} created"

#########################
# Utility Functions
#########################

wait_for_argo_app() {
    local APP_NAME=$1
    local NS=$2
    local MAX_RETRIES=${3:-30} # Default to 30 retries if not provided
    local SLEEP_TIME=10

    echo "--- Waiting for Argo App: $APP_NAME in $NS ---"

    for ((i=1; i<=$MAX_RETRIES; i++)); do
        # Get statuses
        local STATUS=$(kubectl get app "$APP_NAME" -n "$NS" -o jsonpath='{.status.sync.status} {.status.health.status}' 2>/dev/null)
        local SYNC=$(echo $STATUS | cut -d' ' -f1)
        local HEALTH=$(echo $STATUS | cut -d' ' -f2)

        if [[ "$SYNC" == "Synced" && "$HEALTH" == "Healthy" ]]; then
            echo "✅ $APP_NAME is Synced and Healthy!"
            return 0
        fi

        if [[ "$HEALTH" == "Degraded" ]]; then
            echo "❌ $APP_NAME is Degraded! Check logs."
            return 1
        fi

        echo "Retry $i/$MAX_RETRIES: Sync=$SYNC, Health=$HEALTH..."
        sleep $SLEEP_TIME
    done

    echo "⌛ Timeout waiting for $APP_NAME"
    return 1
}

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
echo "**** Deployed jenkins in K8, waiting for pods to be ready for 10secs"

APP_NAME=app-${GROUP}-jenkins
wait_for_argo_app ${APP_NAME} argocd 50

cd ..
kubectl port-forward svc/svc-${GROUP}-jenkins -n ${NS_CICD} 8091:8080 &
echo "**** Connect to jenkins on localhost:8091"

kubectl exec -n ${NS_CICD} deploy/deploy-${GROUP}-jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword
echo "**** Use above admin password for Jenkins"

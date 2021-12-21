REM Ensure ingress controller is installed
REM kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/cloud/deploy.yaml
sleep 20

kubectl create namespace checklist

kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml

REM Start the DB services
kubectl apply -f db-data-pv.yaml
kubectl apply -f db-data-pvc.yaml
kubectl apply -f db-statefulset.yaml
kubectl apply -f db-headless-service.yaml

kubectl apply -f adminer-deployment.yaml
kubectl apply -f api-deployment.yaml
kubectl apply -f ui-deployment.yaml
kubectl apply -f sms-cronjob.yaml

sleep 5
kubectl apply -f ingress.yaml

REM Ensure ingress controller is installed
REM kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/cloud/deploy.yaml
REM https://dev.to/katzekat/ingress-in-kubernetes-with-docker-for-windows-33o2
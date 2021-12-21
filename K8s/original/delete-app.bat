rem set namespace=--namespace=checklist

kubectl delete %namespace% -f ui-service.yaml
kubectl delete %namespace% -f db-service.yaml
kubectl delete %namespace% -f api-service.yaml
kubectl delete %namespace% -f adminer-service.yaml
kubectl delete %namespace% -f ui-deployment.yaml
kubectl delete %namespace% -f sms-deployment.yaml
kubectl delete %namespace% -f db-deployment.yaml
kubectl delete %namespace% -f api-deployment.yaml
kubectl delete %namespace% -f adminer-deployment.yaml
kubectl delete %namespace% -f mysql-secret.yaml
kubectl delete %namespace% -f mysql-pv.yaml
kubectl delete %namespace% -f production-env-configmap.yaml
rem kubectl delete namespace checklist

set namespace=

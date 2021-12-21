rem set namespace=--namespace=checklist

rem kubectl create namespace checklist
rem kubectl create --namespace=checklist -f mysql_password-secret.yaml
rem kubectl create --namespace=checklist -f mysql_user-secret.yaml
kubectl create %namespace% -f mysql-secret.yaml
kubectl create %namespace% -f mysql-pv.yaml
kubectl create %namespace% -f production-env-configmap.yaml
kubectl create %namespace% -f adminer-deployment.yaml
kubectl create %namespace% -f api-deployment.yaml
kubectl create %namespace% -f db-deployment.yaml
kubectl create %namespace% -f sms-deployment.yaml
kubectl create %namespace% -f ui-deployment.yaml
kubectl create %namespace% -f adminer-service.yaml
kubectl create %namespace% -f api-service.yaml
kubectl create %namespace% -f db-service.yaml
kubectl create %namespace% -f ui-service.yaml

set namespace=

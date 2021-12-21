kubectl delete -f ingress.yaml
kubectl delete -f ui-deployment.yaml
kubectl delete -f sms-cronjob.yaml
kubectl delete -f api-deployment.yaml
kubectl delete -f adminer-deployment.yaml
kubectl delete -f configmap.yaml
kubectl delete -f secrets.yaml
kubectl delete namespace checklist

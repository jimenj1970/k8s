kubectl.exe delete pod/db
kubectl.exe delete persistentvolumeclaim/mysql-pv-claim
kubectl.exe delete persistentvolume/mysql-pv-volume
kubectl.exe create -f production-env-configmap.yaml
kubectl.exe create -f mysql-secret.yaml
kubectl.exe create -f mysql-pv.yaml
kubectl.exe create -f db-pod.yaml
kubectl.exe get pod
echo kubectl exec --stdin --tty db-76d4446cd6-fzwbv -- /bin/bash
kubectl exec db  -- ls /var/lib

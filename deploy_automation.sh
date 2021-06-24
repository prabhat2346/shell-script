#!/bin/bash
deployment_list=$(kubectl  get deploy | awk '{print $1}' | tail -n +2)
for deployment in ${deployment_list=[@]};
do
echo $deployment
kubectl get deploy $deployment -o yaml > $deployment.yaml
sed -i 's|fileserver-claim|file-server-claim|g' $deployment.yaml
kubectl apply -f $deployment.yaml
done

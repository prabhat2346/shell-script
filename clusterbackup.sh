for ns in $(kubectl get ns --no-headers | cut -d " " -f1); do
  if { [ "$ns" != "kube-system" ] ; }; then
  kubectl --namespace="${ns}" get -o=json rolebindings,clusterrolebindings,svc,ing,deployments,cm,secrets,ds,StatefulSet | \
jq '.items[] |
    select(.type!="kubernetes.io/service-account-token") |
    del(
        .spec.clusterIP,
        .metadata.uid,
        .metadata.selfLink,
        .metadata.resourceVersion,
        .metadata.creationTimestamp,
        .metadata.generation,
        .status,
        .spec.template.spec.securityContext,
        .spec.template.spec.dnsPolicy,
        .spec.template.spec.terminationGracePeriodSeconds,
        .spec.template.spec.restartPolicy
    )' >> "cluster-backup.json"
  fi
done
echo "backup file saved: cluster-backup.json"

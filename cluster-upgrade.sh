#/bin/bash
cluster_name="playground5-aks-cluster"
subscription_id="968853fd-f3eb-4840-a1ee-536cfdea8092"
location="West Europe"
# Set to 1  only and only if you want to upgrade control plane only and not node pools else set this as 0
control_plane_only_flag="0"
# Must to have some k8s version value
desired_control_version="1.18.19"
# Must to have some k8s version value
desired_node_version="1.18.17"
# It should be either empty if you want whole cluster to upgrade in one go
node_pool_name="default"
# Location of your scritpt
current_path=$(pwd)
# current date and time
dt=`date +%m-%d-%Y-%T`
echo $dt


count=0
pdb_delete_func () {
namespaces=(`kubectl get pdb --all-namespaces --no-headers  | awk '{print $1}' | grep -v "kube-system" | uniq`)
if [[ -d "pdb_yamls" ]] && [[ "${#namespaces[@]}" -ne 0 ]]; then
    for ns in ${namespaces[@]};
        do
        pdb_names=(`kubectl get pdb -n $ns --no-headers | awk {'print $1'}`)
        for (( i = 0 ; i < ${#pdb_names[@]} ; i++ )) 
            do
                echo "Deleting pdbs ${pdb_names[i]}"
                # kubectl delete pdb ${pdb_names[i]} -n $ns
            done
        done
else 
    echo "pdb_yamls folder is missing";     
fi           
}



node_info_func () {
echo "total nodepools in cluster = ${#nodes_info[@]} .. But can have 0 nodes attached to them"; echo "";
for (( i = 0 ; i < ${#nodes_info[@]} ; i++ )) 
    do  
        echo "*** ${nodes_info[i]} ***"
        node_name=(`kubectl get nodes | grep -w ${nodes_info[i]} | awk '{print $1}'`)
        if [ ${#node_name[@]} -ne 0 ]; then
            for (( j = 0 ; j < ${#node_name[@]} ; j++ )) 
                do
                kubectl get nodes | grep ${node_name[j]} | grep $desired_node_version > /dev/null 2>&1
                    if [ $? -eq 0 ]; then
                        echo "Node version matched for ${node_name[j]}"
                    else
                        echo "ERROR:- Node version did not match with desired one for ${node_name[j]}" && exit 1;
                    fi
            done
        fi
    done   
}



backups_and_checks () {
echo "---------------------------------------------------------------"
echo "Running Pre-Checks And Backups"
echo "---------------------------------------------------------------"
echo ""

# backing up previous yamls
cp -r pdb_yamls pdb_yamls_$dt > /dev/null 2>&1
rm -rf pdb_yamls

###########################################################################
#Pre-checks cluster
kubectl config use-context "$cluster_name-admin"

#Set Subscription
echo "Changed subscription to $subscription_id"
az account set -s $subscription_id

#Fetch Resource group
rg=`az aks list --output table | grep $cluster_name  | awk '{print $3}'`

#Control plane version
control_version=`az aks get-upgrades  --name $cluster_name --resource-group $rg --output table |  awk 'FNR == 3' | awk '{print $3}'`
echo "Current Master Version = $control_version"

echo ""
echo "node pools info"
az aks nodepool list --cluster-name  $cluster_name  --resource-group  $rg -o json | grep -Ew 'name|orchestratorVersion'

#CPU quota
# az vm list-usage --location "$location" -o table --subscription $subscription_id

# min=$(echo $desired_k8_version $control_plane_k8_version | awk '{if ($1 < $2) print $1; else print $2}')
# echo $min

###########################################################################
# Backups
# Backup replica count and thne increase replicas of nginx controllers to 3 for HA
ing_count=`kubectl get deployment -n ingress -o=jsonpath='{.items[?(@.metadata.name=="nginx-ingress-controller")].spec.replicas}'`
ext_ing_count=`kubectl get deployment -n ingress-external -o=jsonpath='{.items[?(@.metadata.name=="external-nginx-ingress-controller")].spec.replicas}'`
echo "internal = $ing_count" > controller-replicas.txt
echo "external = $ext_ing_count" >> controller-replicas.txt
echo ""
echo "~~~~scalling replicas~~~~"
kubectl scale deployment --replicas=3 nginx-ingress-controller -n ingress
kubectl scale deployment --replicas=3 external-nginx-ingress-controller -n ingress-external


# Backup of pdbs
namespaces=(`kubectl get pdb --all-namespaces --no-headers  | awk '{print $1}' | grep -v "kube-system" | uniq`)
pdb_count=${#namespaces[@]}
if [ $pdb_count != '0' ]; then
echo ""
echo "Taking backups of pdbs in pdb_yamls folder"
mkdir pdb_yamls > /dev/null 2>&1
for ns in ${namespaces[@]}; 
    do
        kubectl get pdb -n $ns > pdb-$ns.txt
        pdb_names=(`kubectl get pdb -n $ns --no-headers | awk {'print $1'}`)
        for (( i = 0 ; i < ${#pdb_names[@]} ; i++ )) 
            do
                kubectl get pdb ${pdb_names[i]} -n $ns -o yaml > $current_path/pdb_yamls/${pdb_names[i]}.yaml
            done
    done
else
    echo ""
    echo "Not creating pdb_yamls folder as no pdbs available"
fi
echo "---------------------------------------------------------------"
echo "Backup and Pre-checks completed"
echo "IMPORTANT:- Run post-checks from current location only ";pwd
echo "---------------------------------------------------------------"
echo ""

}
###########################################################################
###########################################################################
###########################################################################




run_upgrade() {

echo "---------------------------------------------------------------"
echo "Running cluster upgrade"
echo "---------------------------------------------------------------"



###########################################################################
# control plane upgrade
if [ $control_plane_only_flag -eq '1' ]; then
az aks get-upgrades  --name $cluster_name --resource-group $rg --output table | awk 'FNR == 3' |  awk '{ $3=$2=$1="";print}' | grep $desired_control_version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Version available"
else
    echo "Control plane version is not available" && exit 1;
fi
echo ""
echo "upgrading control plane to $desired_control_version"
# #az aks upgrade --kubernetes-version $desired_control_version --name $cluster_name --resource-group $rg --control-plane-only -y


###########################################################################
# node pools upgrade
elif [ ! -z $node_pool_name ] && [ "$control_plane_only_flag" -ne '1' ]; then
az aks nodepool get-upgrades  --cluster-name $cluster_name --resource-group $rg --nodepool-name $node_pool_name  | grep $desired_node_version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Version available to upgrade"
    pdb_delete_func
else
    echo "Node pool version did not match with desired one" && exit 1;
fi
echo ""
echo "upgrading node pool $node_pool_name to $desired_control_version"
   # # az aks nodepool upgrade --cluster-name $cluster_name --resource-group $rg  --name $node_pool_name --kubernetes-version $desired_node_version --no-wait --debug --verbose


###########################################################################
# Whole cluster upgrade
elif [ -z $node_pool_name ] && [ "$control_plane_only_flag" -ne '1' ]; then
az aks get-upgrades  --name $cluster_name --resource-group $rg --output table | awk 'FNR == 3' |  awk '{ $3=$2=$1="";print}' | grep $desired_control_version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Version available"
    pdb_delete_func
else
    echo "Control plane version is not available" && exit 1;
fi
echo ""
echo "upgrading whole cluster to $desired_control_version"
## az aks upgrade  --name $cluster_name --resource-group $rg --kubernetes-version $desired_control_version  --no-wait --yes --debug --verbose


else
    echo "variables miss configuration"
fi
echo ""

echo "---------------------------------------------------------------"
echo "Upgrade is in process if you do not see any RED colored error on the terminal"
echo "---------------------------------------------------------------"

}

###########################################################################
###########################################################################
###########################################################################

restore_and_checks () {
echo "---------------------------------------------------------------"
echo "Running Post-Checks And Restoring Backups "
echo "IMPORTANT"
echo "you can rerun if checks fails means if Post-checks completed Message do not pops up at the end"
echo "---------------------------------------------------------------"
echo ""

###########################################################################
# Restore
set -e
    echo "~~~Restoring controller replicas~~~"
    count=`cat controller-replicas.txt | grep "internal" | awk '{print $3}'`
    kubectl scale deployment --replicas="$count" nginx-ingress-controller -n ingress
    ecount=`cat controller-replicas.txt | grep "external" | awk '{print $3}'`
    kubectl scale deployment --replicas="$ecount" external-nginx-ingress-controller -n ingress-external
    echo ""
set +e

# Restore
if [ -d "pdb_yamls" ]; then
    echo "~~~Restoring pdbs~~~"
    kubectl create -f $current_path/pdb_yamls/
else
    echo "No pdb_yamls folder in present destination to restore"
fi

###########################################################################
# Hekm release check
set -e
    echo ""
    echo "~~~Performing checks~~~"
    helm repo add bitnami https://charts.bitnami.com/bitnami; sleep 2;
    helm install --name sre-check bitnami/postgresql --version 8.6.4 ; sleep 10;
    kubectl get pvc,pv | grep sre-check
    echo "******************Sleep for 2 mins, waiting for pod to be in Running state******************"; sleep 120;
    kubectl get pods --no-headers | grep sre-check-postgresql-0 | awk '{print $3}' | grep "Running" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Pod in Running state "
    else
        echo "Pod is not in running state" && exit 1;
    fi
    helm delete sre-check --purge
    kubectl get pvc | grep sre-check | awk '{print $1}' | xargs kubectl delete pvc
set +e
echo ""

###########################################################################
# Version check
# Control plane version check
#Fetch Resource group
rg=`az aks list --output table | grep $cluster_name  | awk '{print $3}'`
az aks get-upgrades  --name $cluster_name --resource-group $rg --output table |  awk 'FNR == 3' | awk '{print $3}' | grep $desired_control_version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Control plane version $desired_control_version"
else
    echo "Control plane version did not match with desired one" && exit 1;
fi

# Nodes version check for specific node or whole cluster nodes
if [ ! -z $node_pool_name ] && [ "$control_plane_only_flag" -ne '1' ]; then
    nodes_info=$node_pool_name
    node_info_func
elif [ -z $node_pool_name ] && [ "$control_plane_only_flag" -ne '1' ]; then
    nodes_info=(`az aks nodepool list --cluster-name  $cluster_name  --resource-group  $rg -o json | grep -Ew 'name' | awk '{print $2}' | sed 's/"//g' | tr -s ',' '\n'`)
    node_info_func
else
    echo "only control plane upgraded"      
fi

echo "---------------------------------------------------------------"
echo "Post-checks completed"
echo "---------------------------------------------------------------"

}


if [[ $1 = "upgrade" ]]; then 
backups_and_checks
run_upgrade
elif [[ $1 = "validate" ]]; then
restore_and_checks
else 
echo "Need an argument (ugrade/validate)"
fi


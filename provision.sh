
> +#!/bin/bash

+set -e

+CIDR=172.16.0.0/16

+REGION=<Region Name>

+VPC_NAME=<VPC-NAME>-${REGION}

+TAG=<VPC-Name>

+bundle exec ah-vpc create $VPC_NAME $CIDR $REGION

+bundle exec ah-vpc tag add $VPC_NAME -t $TAG

+bundle exec ah-vpc show $VPC_NAME

+

+echo "------------VPC is created in region::$REGION with VPC-NAME::$VPC_NAME----------------"

+

+

+###### Availability_Zone #####

+#region-azfeatures $REGION

+AZ1=<Region 1>
> +  --ge --de \

+  -V $VPC \

+  --files-storage-type $FS_VOL_TYPE --database-storage-type $DB_VOL_TYPE > dedstack.txt

+

+cat dedstack.txt

+

+DB=$(awk -F ',' '{ print $1 }' dedstack.txt)

+echo "value of DB is:$DB"

+

+WEBS=$(awk '{ print $1 }' dedstack.txt)

+echo "Value of WEBS is:$WEBS"

+

+#comment

+################Get or allocate the Bals

+

+export EC2_ACCOUNT=hosting-dev
> +

+cat dedstack.txt

+

+DB=$(awk -F ',' '{ print $1 }' dedstack.txt)

+echo "value of DB is:$DB"

+

+WEBS=$(awk '{ print $1 }' dedstack.txt)

+echo "Value of WEBS is:$WEBS"

+

+#comment

+################Get or allocate the Bals

+

+export EC2_ACCOUNT=hosting-dev

+

+echo "--------------------------------------Creating BALS Server--------------------------------------"

+#<<comment

> +  -i $BAL_AMI_TYPE \

+  -r $REGION \

+  -z $AZ1 $AZ2 \

+  -V $VPC > balsstack.txt

+

+cat balsstack.txt

+BAL=$(awk -F ',' '{ print $0 }' balsstack.txt)

+echo "value of BAL is:$BAL"

+BAL1=$(awk -F ',' '{ print $1 }' balsstack.txt)

+echo "value of BAL1 is:$BAL1"

+BAL2=$(awk -F ',' '{ print $2 }' balsstack.txt)

+echo "value of BAL2 is:$BAL2"

+#comment

+

+############ Staging ####################

+#<<comment

> +#<<comment

+BAL_AMI_TYPE=c4.large

+bundle exec ah-provision stack bal \

+  -i $BAL_AMI_TYPE \

+  -r $REGION \

+  -z $AZ1 $AZ2 \

+  -V $VPC > balsstack.txt

+

+cat balsstack.txt

+BAL=$(awk -F ',' '{ print $0 }' balsstack.txt)

+echo "value of BAL is:$BAL"

+BAL1=$(awk -F ',' '{ print $1 }' balsstack.txt)

+echo "value of BAL1 is:$BAL1"

+BAL2=$(awk -F ',' '{ print $2 }' balsstack.txt)

+echo "value of BAL2 is:$BAL2"

+#comment
+#!/bin/bash

+set -e

+CIDR=172.16.0.0/16



> +  --ge --de \

+  -V $VPC \

+  --files-storage-type $FS_VOL_TYPE --database-storage-type $DB_VOL_TYPE > dedstack.txt

+

+cat dedstack.txt

+

+DB=$(awk -F ',' '{ print $1 }' dedstack.txt)

+echo "value of DB is:$DB"

+

+WEBS=$(awk '{ print $1 }' dedstack.txt)

+echo "Value of WEBS is:$WEBS"

+

+#comment

+################Get or allocate the Bals

+

+export EC2_ACCOUNT=hosting-dev



move to top









In script_env_migration.md:



> +

+cat dedstack.txt

+

+DB=$(awk -F ',' '{ print $1 }' dedstack.txt)

+echo "value of DB is:$DB"

+

+WEBS=$(awk '{ print $1 }' dedstack.txt)

+echo "Value of WEBS is:$WEBS"

+

+#comment

+################Get or allocate the Bals

+

+export EC2_ACCOUNT=hosting-dev

+

+echo "--------------------------------------Creating BALS Server--------------------------------------"

+#<<comment



what is this line for?









In script_env_migration.md:



> +  -i $BAL_AMI_TYPE \

+  -r $REGION \

+  -z $AZ1 $AZ2 \

+  -V $VPC > balsstack.txt

+

+cat balsstack.txt

+BAL=$(awk -F ',' '{ print $0 }' balsstack.txt)

+echo "value of BAL is:$BAL"

+BAL1=$(awk -F ',' '{ print $1 }' balsstack.txt)

+echo "value of BAL1 is:$BAL1"

+BAL2=$(awk -F ',' '{ print $2 }' balsstack.txt)

+echo "value of BAL2 is:$BAL2"

+#comment

+

+############ Staging ####################

+#<<comment



what is this line for?









In script_env_migration.md:



> +#<<comment

+BAL_AMI_TYPE=c4.large

+bundle exec ah-provision stack bal \

+  -i $BAL_AMI_TYPE \

+  -r $REGION \

+  -z $AZ1 $AZ2 \

+  -V $VPC > balsstack.txt

+

+cat balsstack.txt

+BAL=$(awk -F ',' '{ print $0 }' balsstack.txt)

+echo "value of BAL is:$BAL"

+BAL1=$(awk -F ',' '{ print $1 }' balsstack.txt)

+echo "value of BAL1 is:$BAL1"

+BAL2=$(awk -F ',' '{ print $2 }' balsstack.txt)

+echo "value of BAL2 is:$BAL2"

+#comment



what is this line for?









In script_env_migration.md:



> +  -d $DB_SIZE \

+  -g $FS_SIZE \

+  -i $STG_AMI_TYPE \

+  -n $STG_CLUSTER_NAME \

+  -r $REGION \

+  -z $AZ1 \

+  --ge --de \

+  -V $VPC \

+  --files-storage-type $FS_VOL_TYPE --database-storage-type $DB_VOL_TYPE)

+

+STAGING=$STAGING_VARIABLE

+echo "Value of STAGING is:$STAGING_VARIABLE" > staging.txt

+

+### SVN SERVER

+

+#bundle exec ah-server list % > server.list



Why is this commented out? can we just list and pick the last svn server? ah-server list svn-%









In script_env_migration.md:



> +  --files-storage-type $FS_VOL_TYPE --database-storage-type $DB_VOL_TYPE)

+

+STAGING=$STAGING_VARIABLE

+echo "Value of STAGING is:$STAGING_VARIABLE" > staging.txt

+

+### SVN SERVER

+

+#bundle exec ah-server list % > server.list

+#SVN=$(awk 'NR==1 { print $1 }' server.list)

+#echo "value of SVN is:$SVN"

+

+SVN=svn-1

+

+

+#<<comment

+SITENAME=<abc>



Move this to the top









In script_env_migration.md:



> +./fields/fields-provision.php --create-site ${SITENAME} --vcs ${SVN} \

+  --bals ${BAL} --webs ${WEBS} --db $DB ; echo ""

+

+

+

+echo "------------------------------------------Creating sites for dev-------------------------------"

+

+./fields/fields-provision.php --create-site ${SITENAME}dev --stage dev \

+  --bals ${BAL} --webs ${STAGING} --db ${STAGING} \

+  --sitegroup ${SITENAME} ; echo ""

+#comment

+################ Launching Servers #############

+#launch the servers

+

+echo "-------------Launching the Staging Servers***********WILL TAKE LONG TIME (APPROX 30 mins)*******************---------"

+bundle exec ah-server relaunch_task $STAGING



let's use ah-server launch server1 server2 server3 etc to parallelize the launches of all servers in this script









In script_env_migration.md:



> +bundle exec ah-site status --query=$SITENAME

+bundle exec ah-site status --query=${SITENAME}dev

+

+###To check status of staging server

+echo "---------------Status of staging server:$STAGING--------------------"

+bundle exec ah-server get $STAGING | grep -i status

+

+###To check status of Bal server

+bundle exec ah-server get $BAL1 | grep ip

+

+#####To print the FQDN Name for prod and dev sites.

+

+bundle exec ah-site get $SITENAME | grep default_fqdn

+bundle exec ah-site get ${SITENAME}dev | grep default_fqdn

+

+bundle exec ah-sitegroup list % 



What are these for?









In script_env_migration.md:



> +###To check status of staging server

+echo "---------------Status of staging server:$STAGING--------------------"

+bundle exec ah-server get $STAGING | grep -i status

+

+###To check status of Bal server

+bundle exec ah-server get $BAL1 | grep ip

+

+#####To print the FQDN Name for prod and dev sites.

+

+bundle exec ah-site get $SITENAME | grep default_fqdn

+bundle exec ah-site get ${SITENAME}dev | grep default_fqdn

+

+bundle exec ah-sitegroup list % 

+bundle exec ah-site list %

+

+echo "***********************************De-provisioning the Sites And Servers*************************************************"



Lets move this depropvisioning stuff to a different file



> +  -d $DB_SIZE \

+  -g $FS_SIZE \

+  -i $STG_AMI_TYPE \

+  -n $STG_CLUSTER_NAME \

+  -r $REGION \

+  -z $AZ1 \

+  --ge --de \

+  -V $VPC \

+  --files-storage-type $FS_VOL_TYPE --database-storage-type $DB_VOL_TYPE)

+

+STAGING=$STAGING_VARIABLE

+echo "Value of STAGING is:$STAGING_VARIABLE" > staging.txt

+

+### SVN SERVER

+

+#bundle exec ah-server list % > server.list

> +  --files-storage-type $FS_VOL_TYPE --database-storage-type $DB_VOL_TYPE)

+

+STAGING=$STAGING_VARIABLE

+echo "Value of STAGING is:$STAGING_VARIABLE" > staging.txt

+

+### SVN SERVER

+

+#bundle exec ah-server list % > server.list

+#SVN=$(awk 'NR==1 { print $1 }' server.list)

+#echo "value of SVN is:$SVN"

+

+SVN=svn-1

+

+

+#<<comment

+SITENAME=<abc>



> +./fields/fields-provision.php --create-site ${SITENAME} --vcs ${SVN} \

+  --bals ${BAL} --webs ${WEBS} --db $DB ; echo ""

+

+

+

+echo "------------------------------------------Creating sites for dev-------------------------------"

+

+./fields/fields-provision.php --create-site ${SITENAME}dev --stage dev \

+  --bals ${BAL} --webs ${STAGING} --db ${STAGING} \

+  --sitegroup ${SITENAME} ; echo ""

+#comment

+################ Launching Servers #############

+#launch the servers

+

+echo "-------------Launching the Staging Servers***********WILL TAKE LONG TIME (APPROX 30 mins)*******************---------"

+bundle exec ah-server relaunch_task $STAGING



let's use ah-server launch server1 server2 server3 etc to parallelize the launches of all servers in this script

> +bundle exec ah-site status --query=$SITENAME

+bundle exec ah-site status --query=${SITENAME}dev

+

+###To check status of staging server

+echo "---------------Status of staging server:$STAGING--------------------"

+bundle exec ah-server get $STAGING | grep -i status

+

+###To check status of Bal server

+bundle exec ah-server get $BAL1 | grep ip

+

+#####To print the FQDN Name for prod and dev sites.

+

+bundle exec ah-site get $SITENAME | grep default_fqdn

+bundle exec ah-site get ${SITENAME}dev | grep default_fqdn

+

+bundle exec ah-sitegroup list % 


> +###To check status of staging server

+echo "---------------Status of staging server:$STAGING--------------------"

+bundle exec ah-server get $STAGING | grep -i status

+

+###To check status of Bal server

+bundle exec ah-server get $BAL1 | grep ip

+

+#####To print the FQDN Name for prod and dev sites.

+

+bundle exec ah-site get $SITENAME | grep default_fqdn

+bundle exec ah-site get ${SITENAME}dev | grep default_fqdn

+

+bundle exec ah-sitegroup list % 

+bundle exec ah-site list %






# This script is for migrating the repositories from bibucket to Github


#!/bin/sh

echo "checking if jq is installed"
jq=$(command -v jq)

if [ -z "$jq" ]
then
    echo "jq not installed"
    yum install epel-release -y
    sudo yum -y install jq
    echo "jq has been installed"
else
    echo "jq is installed"
fi

cd ~
mkdir BB_GitHub_Migration
cd BB_GitHub_Migration

#-------------Variables Declaration-----------------------------
GH_ORG_NAME=
BB_USER=
BB_PASS=
GH_USER=
GH_PASS=

BB_PROJ_KEY=( $(curl -X GET -k -v -u $BB_USER:$BB_PASS https://bitbucket:8443/rest/api/1.0/projects | jq -r ".values[].key") )

for each_key in "${BB_PROJ_KEY[@]}"; do
  echo #######################
  echo "Processing $each_key"
  echo #######################
  PROJ_NAME=$(curl -X GET -k -v -u $BB_USER:$BB_PASS https://bitbucket:8443/rest/api/1.0/projects/$each_key | jq -r ".name" | sed -e 's/ /_/g')
  repos=( $(curl -X GET -k -v -u $BB_USER:$BB_PASS https://bitbucket:8443/rest/api/1.0/projects/$each_key/repos | jq -r ".values[].slug") )
   for repo_name in "${repos[@]}"; do
      echo ########################
      echo "Processing $repo_name"
      echo ########################
      git clone --bare https://$BB_USER:$BB_PASS@bitbucket:8443/scm/$each_key/$repo_name.git
	    cd $repo_name.git
      echo #############################################
      echo "$repo_name cloned, now creating on Github"  
      echo #############################################
      github_repo_name=${repo_name//-/_}
      curl -u $GH_USER:$GH_PASS https://api.github.com/orgs/$GH_ORG_NAME/repos -d "{\"name\": \"$PROJ_NAME-$github_repo_name\", \"private\": true}"
      echo #################################
      echo "Mirroring $repo_name to Github"  
      echo #################################
	    git push --mirror https://$GH_USER:$GH_PASS@github.com/$GH_ORG_NAME/$PROJ_NAME-$github_repo_name.git
	    cd ..
  done
done   
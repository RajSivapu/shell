get=$(curl -v -u $USER_ID:$PASSWORD -G -H "X-Atlassian-Token:nocheck"  "http://bitbucket/rest/api/1.0/admin/permissions/groups" --data-urlencode "filter=$GROUP_NAME")
response=$(echo ${get} | jq ".size")
failure=$(echo ${get} | jq ".errors[0].message")
if [ "$failure" != null ]; then
   echo $failure
   exit 1
elif [ "$response" == 0 ]; then
   curl -v -u $USER_ID:$PASSWORD -X PUT -G -H "X-Atlassian-Token:nocheck" "http://bitbucket/rest/api/1.0/admin/permissions/groups" --data-urlencode "name=$GROUP_NAME" --data-urlencode "permission=$GLOBAL_PERMISSION"
   curl -u $USER_ID:$PASSWORD -H "Content-Type: application/json" -X PUT -G "http://bitbucket/rest/api/1.0/projects/$PROJECT_KEY/repos/$REPO_NAME/permissions/groups" --data-urlencode "name=$GROUP_NAME" --data-urlencode "permission=$REPO_PERMISSION"

   echo "Group added to Global users as $GLOBAL_PERMISSION and  to $REPO_NAME with $REPO_PERMISSION"
else	
    curl -u $USER_ID:$PASSWORD -H "Content-Type: application/json" -X PUT -G "http://bitbucketrest/api/1.0/projects/$PROJECT_KEY/repos/$REPO_NAME/permissions/groups" --data-urlencode "name=$GROUP_NAME" --data-urlencode "permission=$REPO_PERMISSION"
  	echo "Group added to $REPO_NAME with $REPO_PERMISSION"
fi
exit 0
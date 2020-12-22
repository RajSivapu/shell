get=$(curl -v -u $USER_ID:$PASSWORD -X GET -H "X-Atlassian-Token:nocheck"  "http://bitbucket/rest/api/1.0/admin/permissions/users?filter=$USER_NAME")
response=$(echo ${get} | jq ".size")
failure=$(echo ${get} | jq ".errors[0].message")

if [ "$failure" != null ]; then
   echo $failure
   exit 1
elif [ "$response" == 0 ]; then
   curl -v -u $USER_ID:$PASSWORD -X PUT -H "X-Atlassian-Token:nocheck"  "http://bitbucket/rest/api/1.0/admin/permissions/users?name=$USER_NAME&permission=$GLOBAL_PERMISSION"
   curl -v -u $USER_ID:$PASSWORD -H "Content-Type: application/json" -X PUT "http://bitbucket/rest/api/1.0/projects/$PROJECT_KEY/repos/$REPO_NAME/permissions/users?name=$USER_NAME&permission=$REPO_PERMISSION"
   echo "user added to Global users as $GLOBAL_PERMISSION and  to $REPO_NAME with $REPO_PERMISSION"
else	
    curl -u $USER_ID:$PASSWORD -H "Content-Type: application/json" -X PUT "http://bitbucket/rest/api/1.0/projects/$PROJECT_KEY/repos/$REPO_NAME/permissions/users?name=$USER_NAME&permission=$REPO_PERMISSION"
  	echo "user added to $REPO_NAME with $REPO_PERMISSION"
fi
exit 0
create=$(curl -X POST -v -u $USER:$PASSWORD http://bitbucket/rest/api/1.0/projects/$KEY/repos -H "Content-Type: application/json" -d "{\"name\": \"$REPO_NAME\",\"scmId\": \"git\", \"forkable\": true }")
response=$(echo ${create} | jq ".errors[0].message")
echo "$response"

if [ "$response" != null ]; then
  echo "$response"
exit 1
else
  echo "Repo has been created"
fi
exit 0
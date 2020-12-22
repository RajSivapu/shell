create=$(curl --user $USER:$PASSWORD -X POST  -H "Content-type: application/json" -d '{"key":'\""$KEY"\"', "name": '\""$PROJECT_NAME"\"', "description": '\""$DESC"\"'}' http://bitbucket/rest/api/latest/projects)
response=$(echo ${create} | jq ".errors[0].message")
echo "$response"

if [ "$response" != null ]; then
  echo "$response"
exit 1
else
  echo "Project has been created"
fi
exit 0
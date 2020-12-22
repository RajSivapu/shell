$BB_USER = ''
$BB_PASS = ''
$KEY = "DEV"
$REPO_NAME = 'Testing'


$AuthenticationToken=[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $BB_USER,$BB_PASS)))
$headers = @{}
$headers.Authorization = "Basic $AuthenticationToken"
$Uri = "https://bitbucket/rest/api/1.0/projects/$KEY/repos" 
$Body = ('("name":"{0}","scmId": "git","forkable": true)' -f $REPO_NAME) -replace '\(','{' -replace '\)','}'

$response = try {
      Invoke-WebRequest -Method Post -Uri $Uri -Headers $headers -UseBasicParsing -ContentType 'application/json' -Body $Body
}
catch {
    $_.Exception.Response.StatusCode
}

if ($response.StatusCode -eq '201') {
    Write-Output "Repo $REPO_NAME created"
}

else {
  Write-Output "Repo is not created due to $response"
}

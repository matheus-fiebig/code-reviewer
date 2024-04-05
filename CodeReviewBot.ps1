$configPath = './config.json'
$configJson = Get-Content config.json | ConvertFrom-Json
echo $configJson.mainBranch


git diff --name-status firstbranch..yourBranchName
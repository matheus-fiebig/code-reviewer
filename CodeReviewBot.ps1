$configPath = './config.json'
$config = Get-Content $configPath | ConvertFrom-Json

$allowedSuffix = $config.models.allowedSuffix;
$path = $config.models.path;

#WrongNamingRule
$wrongNamedFiles = 
    git diff --name-status $config.targetBranch |
            Select-String -Pattern "[^0]+(?=$path)+(?=(?!.*$allowedSuffix.cs$))"

Clear-Host
Write-Host "   Wrong Named Models   " -ForegroundColor white -BackgroundColor darkred
Write-Host $wrongNamedFiles -ForegroundColor darkred 
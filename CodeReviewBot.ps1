$configPath = './config.json'
$config = Get-Content $configPath | ConvertFrom-Json

$allowedSuffix = $config.models.allowedSuffix;
$path = $config.models.path;

Clear-Host

#WrongNamingRule
Write-Host "   Wrong Named Models   " -ForegroundColor white -BackgroundColor darkred
foreach ($namingRule in $config.namingRules)
{
    $wrongNamedFiles = git diff --name-status $config.targetBranch |
            Select-String -Pattern "[^0]+(?=$path)+(?=(?!.*$allowedSuffix.cs$))"
    Write-Host $wrongNamedFiles -ForegroundColor darkred 
}

Write-Host "   Remember to always check for rich domain and variable names   " -ForegroundColor white -BackgroundColor darkyellow

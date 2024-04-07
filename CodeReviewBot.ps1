$configPath = './config.json'
$config = Get-Content $configPath | ConvertFrom-Json

Clear-Host

$cdFiles = git diff --name-status $config.targetBranch |
            Select-String -Pattern "^(?!D).*\.cs$" |
            %{ $_.ToString().TrimStart('A').TrimStart('M').Trim() }

#Wrong named files 
foreach ($namingRule in $config.namingRules)
{
    $title = $namingRule.title
    Write-Host "   Wrong named $title  " -ForegroundColor white -BackgroundColor darkred
    
    $path = $namingRule.path
    $allowedSuffix = $namingRule.allowedSuffix
    $wrongNamedFiles = git diff --name-status $config.targetBranch |
            Select-String -Pattern "[^D]+(?=$path)+(?=(?!.*$allowedSuffix.cs$))" |
            %{ $_.ToString().TrimStart('A').TrimStart('M') } 

    Write-Host "`n$wrongNamedFiles`n" -ForegroundColor darkred  
}

#Enforce empty constructors
if($config.enforceEmptyConstructor)
{
    Write-Host "`n   Classes without primary constructors  " -ForegroundColor white -BackgroundColor darkred
    foreach($file in $cdFiles)
    {
        $className = $file | Split-Path -Leaf | %{ $_.Replace(".cs", "") }
        
        $fileContent = cat $file | 
            Select-String -Pattern ".*" 
        
        $classesWithoutPrimaryConstructor = "$fileContent".Replace("\n","") | 
            Select-String -Pattern "^(?!.*$className.*$className).*$className.*$" |
            %{ $className } 
        
        Write-Host $classesWithoutPrimaryConstructor
    }
}

#Allow skipping unit tests
if(!$config.allowSkippingUnitTest)
{
    Write-Host "   Classes skipping tests   " -ForegroundColor white -BackgroundColor darkred
    foreach($file in $cdFiles)
    {
        $skippedTests = 
            cat $file | 
            Select-String -Pattern "\b(xit|xdescribe|Fact\(Skip)\b" |
            %{$file}
            
    }
    
    Write-Host "`n`t$skippedTests`n   " -ForegroundColor darkred
}
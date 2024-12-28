$env:POSH_GIT_ENABLED = $true
$env:Path += ";$env:UserProfile\bin"
Import-Module posh-git
oh-my-posh init pwsh --config ~\.config\.oh-my-posh.omp.json | Invoke-Expression
Import-Module PSLazyCompletion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
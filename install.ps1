function resetEnv {
  Set-Item `
      -Path (('Env:', $args[0]) -join '') `
      -Value ((
          [System.Environment]::GetEnvironmentVariable($args[0], "Machine"),
          [System.Environment]::GetEnvironmentVariable($args[0], "User")
      ) -match '.' -join ';')
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
If (-Not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
  resetEnv Path
  resetEnv AppPath
} Else {
  scoop install 7zip
  scoop install git
  scoop install gpg
  scoop install bitwarden-cli
  resetEnv Path
  resetEnv AppPath
}

If (Get-Command bw -ErrorAction SilentlyContinue) {
  bw login
  $BW_SESSION_INIT=$(bw unlock --raw)
  [System.Environment]::SetEnvironmentVariable('BW_SESSION',"$BW_SESSION_INIT")

  If (-Not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
    scoop install chezmoi
    resetEnv Path
    resetEnv AppPath
  }

  chezmoi init --apply "--source=$PSScriptRoot"

} Else {
  Write-Output "Bitwarden is not installed. Cannot proceed with chezmoi apply."
}
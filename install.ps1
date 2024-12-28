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
  scoop install 7zip
  scoop install git
  scoop install gpg
  scoop install bitwarden-cli
}

If (-Not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
  scoop install chezmoi
  resetEnv Path
  resetEnv AppPath
}

chezmoi init --apply "--source=$PSScriptRoot"
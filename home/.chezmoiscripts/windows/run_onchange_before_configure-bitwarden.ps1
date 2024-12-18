$BW_SESSION_INIT=$(bw unlock --raw)
[System.Environment]::SetEnvironmentVariable('BW_SESSION',"$BW_SESSION_INIT")
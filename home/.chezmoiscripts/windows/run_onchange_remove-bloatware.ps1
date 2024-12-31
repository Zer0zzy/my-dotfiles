# Script can only run as Admin
# To run this script:
# 1. Run `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process`
# 1. Run `chezmoi apply ~/.chezmoiscripts/windows/remove-bloatware.ps1`
#
# automate running this script as Administrator
# Check if Powershell is running as Admin
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
#"No Administrative rights, it will display a popup window asking user for Admin rights"
    $arguments = "& '" + $myinvocation.mycommand.definition + "'" + " -NoExit"
    Start-Process "$psHome\powershell.exe" -Verb runAs -Wait -ArgumentList $arguments 
    break
}
#"After user clicked Yes on the popup, your file will be reopened with Admin rights"
#"Put your code here"
$global:AppxErrors = $False;

# FIXME remove Spotify
# FIXME remove LinkedIn
# FIXME remove Windows 11 bottom left widget
$Packages = @(
"Microsoft.Copilot", 
"ClipChamp.ClipChamp",
"DellInc.DellSupportAssistforPCs",
"DellInc.DellDigitalDelivery",
"DellInc.DellOptimizer",
"Microsoft.549981C3F5F10",
"Microsoft.BingNews",
"Microsoft.BingWeather",
"Microsoft.GamingApp",
"Microsoft.GetHelp",
"Microsoft.GetStarted",
"Microsoft.Microsoft3DViewer",
# "Microsoft.MicrosoftOfficeHub",
"Microsoft.MicrosoftSolitaireCollection",
"Microsoft.MicrosoftStickyNotes",
"Microsoft.MixedReality.Portal",
# "Microsoft.MSPaint",
# "Microsoft.OutlookForWindows",
# "Microsoft.Paint",
"Microsoft.People",
"Microsoft.ScreenSketch",
"Microsoft.SkypeApp",
"Microsoft.StorePurchaseApp", # Marks Purchases in Msft Store
"Microsoft.Todos",
"Microsoft.Windows.ParentalControls",
# Microsoft.Windows.Photos",
"Microsoft.WindowsAlarms",
"Microsoft.WindowsCalculator",
"Microsoft.WindowsCamera",
# "Microsoft.WindowsCommunicationsApps", # Start Menu Apps for People/Mail/Calendar
"Microsoft.WindowsFeedbackHub",
"Microsoft.WindowsMaps",
# "Microsoft.WindowsSoundRecorder",
# "Microsoft.WindowsStore",
"Microsoft.Xbox.TCUI",
"Microsoft.XboxApp",
"Microsoft.XboxGameOverlay",
"Microsoft.XboxGamingOverlay",
"Microsoft.XboxIdentityOverlay",
"Microsoft.XboxSpeechToTextOverlay",
# "Microsoft.YourPhone",
"Microsoft.ZuneMusic",
"Microsoft.ZuneVideo",
"MicrosoftWindows.LKG.DesktopSpotlight"
);

$Packages | ForEach-Object {
    $Package = $_
    Try {
        Get-AppxPackage -AllUsers $Package | Remove-AppxPackage -AllUsers -ErrorAction Stop
        Write-Host "Removed $Package."
    } Catch {
        Write-Host "Could not remove $Package."
        $global:AppxErrors = $True
    }
}

If ($global:AppxErrors) {Get-AppxLog}

# https://learn.microsoft.com/en-us/answers/questions/1421927/uninstall-unpin-spotify-whatsapp-etc-using-script

#$Junk = "xbox|phone|disney|skype|spotify|groove|solitaire|zune|mixedreality|tiktok|adobe|prime|soundrecorder|bingweather!3dviewer"
# "Removing apps for this user only."
# $packages = Get-AppxPackage | Where-Object {  $_.Name -match $Junk  } | Where-Object -Property NonRemovable -eq $false 
# foreach ($appx in $packages) {
#     "Removing {0}" -f $appx.name
#     Remove-AppxPackage $appx -ErrorAction SilentlyContinue
# }
# ""
# "Removing apps for all users."
# $packages = Get-AppxPackage -AllUsers | Where-Object {  $_.Name -match $Junk  } | Where-Object -Property NonRemovable -eq $false 
# foreach ($appx in $packages) {
#     "Removing {0}" -f $appx.name
#     Remove-AppxPackage $appx -AllUsers -ErrorAction SilentlyContinue
# }
# ""
# "Removing provisioned apps."
# $packages = Get-AppxProvisionedPackage -Online | Where-Object {  $_.DisplayName -match $Junk  }
# foreach ($appx in $packages) {
#     "Removing {0}" -f $appx.displayname
#     Remove-AppxProvisionedPackage -online -allusers -PackageName $appx.PackageName -ErrorAction SilentlyContinue
# }

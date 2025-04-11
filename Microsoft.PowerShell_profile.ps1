

# Load Modules into your environment path $env:PSModulePath from the following locations
$env:PSModulePath = $env:PSModulePath,'\\files-01\Powershell$' -join [System.IO.Path]::PathSeparator
if(Test-Path -Path "C:\Users\lucas\OneDrive - Campus XII Avenue\Powershell\Modules") {$env:PSModulePath = $env:PSModulePath,'C:\Users\lucas\OneDrive - Campus XII Avenue\Powershell\Modules' -join [System.IO.Path]::PathSeparator}
if(Test-Path -Path "C:\Users\l.moser\OneDrive - Campus XII Avenue\Powershell\Modules") {$env:PSModulePath = $env:PSModulePath,'C:\Users\l.moser\OneDrive - Campus XII Avenue\Powershell\Modules' -join [System.IO.Path]::PathSeparator}

# Load scripts dot sourcing from the following locations
if(Test-Path -Path "$env:USERPROFILE\OneDrive - Campus XII Avenue\Powershell\Scripts") {
    $Functions = Get-ChildItem -Path "$env:USERPROFILE\OneDrive - Campus XII Avenue\Powershell\Scripts\*.ps1" -Recurse -Exclude "$env:USERPROFILE\OneDrive - Campus XII Avenue\Powershell\Scripts\test\*.ps1"
    ForEach ($Item in $Functions) {
        . $Item.FullName
    }
}

# Load scripts into your environment path $env:path from the following locations
$env:Path += ";D:\SysAdmin\scripts\PowerShellBasics"
$env:Path += ";D:\SysAdmin\scripts\Connectors"
$env:Path += ";D:\SysAdmin\scripts\Office365"
#if(Test-Path -Path "C:\Users\lucas\OneDrive - Campus XII Avenue\Powershell\Scripts") {$env:Path += ";C:\Users\lucas\OneDrive - Campus XII Avenue\Powershell\Scripts"}
#if(Test-Path -Path "C:\Users\l.moser\OneDrive - Campus XII Avenue\Powershell\Scripts") {$env:Path += ";C:\Users\l.moser\OneDrive - Campus XII Avenue\Powershell\Scripts"}

#Set-Alias Get-MailDomainInfo Get-MailDomainInfo.ps1

function Reload-Profile {
    & $profile
}


Function BackUp-Profile {
    $destination="$env:USERPROFILE\OneDrive - Campus XII Avenue\Powershell\Profil"
    if(!(test-path $destination)) {
        New-Item -Path $destination -ItemType directory -force | out-null
    }
    $backupName = "{0}.{1}" -f (Get-Date -Format "dd-MM-yyyy"), (Split-Path -Path $PROFILE -Leaf)
    copy-item -path $profile -destination "$destination\$backupName" -force
} 

function ll { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }

function tail {
  param($Path, $n = 10, [switch]$f = $false)
  Get-Content $Path -Tail $n -Wait:$f
}

function Update-PowerShell {
    try {
        Write-Host "Checking for PowerShell updates..." -ForegroundColor Cyan
        $updateNeeded = $false
        $currentVersion = $PSVersionTable.PSVersion.ToString()
        $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
        $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
        $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
        if ($currentVersion -lt $latestVersion) {
            $updateNeeded = $true
        }

        if ($updateNeeded) {
            Write-Host "Updating PowerShell..." -ForegroundColor Yellow
            Start-Process powershell.exe -ArgumentList "-NoProfile -Command winget upgrade Microsoft.PowerShell --accept-source-agreements --accept-package-agreements" -Wait -NoNewWindow
            Write-Host "PowerShell has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
        } else {
            Write-Host "Your PowerShell is up to date." -ForegroundColor Green
        }
    } catch {
        Write-Error "Failed to update PowerShell. Error: $_"
    }
}

# Check for Profile Updates
function Update-Profile {
    try {
        $url = "https://raw.githubusercontent.com/ChrisTitusTech/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
        $oldhash = Get-FileHash $PROFILE
        Invoke-RestMethod $url -OutFile "$env:temp/Microsoft.PowerShell_profile.ps1"
        $newhash = Get-FileHash "$env:temp/Microsoft.PowerShell_profile.ps1"
        if ($newhash.Hash -ne $oldhash.Hash) {
            Copy-Item -Path "$env:temp/Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
            Write-Host "Profile has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
        } else {
            Write-Host "Profile is up to date." -ForegroundColor Green
        }
    } catch {
        Write-Error "Unable to check for `$profile updates: $_"
    } finally {
        Remove-Item "$env:temp/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
    }
}


<#
.SYNOPSIS
  <Overview of script>

.DESCRIPTION
  <Brief description of script>

.PARAMETER <Parameter_Name>
  <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS Server
  Mandatory. The vCenter Server or ESXi Host the script will connect to, in the format of IP address or FQDN.

.INPUTS Credentials
  Mandatory. The user account credendials used to connect to the vCenter Server of ESXi Host.

.OUTPUTS Log File
  The script log file stored in C:\Windows\Temp\<name>.log

.NOTES
  Version:        1.0
  Author:         <Name>
  Creation Date:  <Date>
  Purpose/Change: Initial script development

.EXAMPLE
  <Example explanation goes here>
  
  <Example goes here. Repeat this attribute for more than one example>
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

[CmdletBinding()]
param(
      [Parameter(Mandatory=$false)][String]$search,
      [Parameter(Mandatory=$false)][switch]$all,
      [Parameter(Mandatory=$false)][switch]$OnlySync 
    )
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins
#Import-Module PSLogging

#----------------------------------------------------------[Declarations]----------------------------------------------------------
#Script Version
$sScriptVersion = '1.0'

#-----------------------------------------------------------[Functions]------------------------------------------------------------
Try {
    if($all -eq $false){
        $search = '*' + $search + '*'
        #Get-AzureADUser -searchstring $search | Where {$_.DirSyncEnabled -ne $null} | Select displayname,UserPrincipalName,Mail,City,@{N="EmployeeId";E={$_.ExtensionProperty["employeeId"]}},@{N="onPremisesDistinguishedName";E={$_.ExtensionProperty["onPremisesDistinguishedName"]}} | ft -AutoSize
        #Get-AzureADUser -all $true | Where-Object {($_.Mail -like '*$search*') -or ($_.Displayname -like '*$search*')} | Select displayname,UserPrincipalName,Mail,City,@{N="EmployeeId";E={$_.ExtensionProperty["employeeId"]}},@{N="onPremisesDistinguishedName";E={$_.ExtensionProperty["onPremisesDistinguishedName"]}} | ft -AutoSize
        Get-AzureADUser -all $true | Where-Object {($_.Mail -like $search) -or ($_.Displayname -like $search) -or ($_.City -like $search)} | Select displayname,UserPrincipalName,Mail,City,@{N="EmployeeId";E={$_.ExtensionProperty["employeeId"]}},@{N="onPremisesDistinguishedName";E={$_.ExtensionProperty["onPremisesDistinguishedName"]}} | ft -AutoSize
    }
    elseif($all -eq $true){
        Get-AzureADUser -all $true | Where {$_.DirSyncEnabled -ne $null} | Select displayname,UserPrincipalName,Mail,City,@{N="EmployeeId";E={$_.ExtensionProperty["employeeId"]}},@{N="onPremisesDistinguishedName";E={$_.ExtensionProperty["onPremisesDistinguishedName"]}} | ft -AutoSize
    }
}

Catch {
    #  Write-LogError -LogPath $sLogFile -Message $_.Exception -ExitGracefully
    Break
}
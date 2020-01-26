param(
    [Parameter(Mandatory=$true)] $sNomDeLInstance, $sCheminDeLInstance, $bDebug=$false
)

<#
.SYNOPSIS
    Sauvegarde de l'instances Minecraft

.PARAMETER <sNomDeLInstance>
    Nom de l'instance à sauvegarde pour le nom de l'archive

.PARAMETER <sCheminDeLInstance>
    Chemin vers le dossier de l'instance

.INPUTS
    N/A

.OUTPUTS
    Archive de l'instance   - Example: D:\Jeux\Backup\nomDeLInstance_2020.01.25.7z
    Logs                    - Exemple: D:\Jeux\Backup\Logs\nomDeLInstance_2020.01.25.log

.NOTES
    Version:        1.0
    Auteur:         Chucky2401
    Date Création:  25 Janvier 2020
    Changement:     Initialisation

.EXAMPLE
    .\backup.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC
 #>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
#$ErrorActionPreference = "SilentlyContinue"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

## Variables Utilisateurs
#Dossier de sauvegarde
$sBackupPath           = "D:\Utilisateurs\TheBlackWizard\Jeux\Backup\Minecraft"
#Dossier du log
$sLogPath              = "D:\Utilisateurs\TheBlackWizard\Jeux\Backup\Minecraft\Logs"


####################################################
##                                                ##
## /!\ NE PAS MODIFIER LES VALEURS CI-DESSOUS /!\ ##
##                                                ##
####################################################
#Script Version
$sScriptVersion        = "1.0"

#Date du jour
$sDate                 = Get-Date -UFormat "%Y.%m.%d"
$sHour                 = Get-Date -UFormat "%H"
$sHourMinute           = Get-Date -UFormat "%H.%M"

#Archive information
$sArchiveName          = "$($sNomDeLInstance)-$($sDate)_$($sHour).00.7z"
$sArchiveFile          = Join-Path -Path $sBackupPath -ChildPath $sArchiveName

#Log File Info
$sLogName              = "$($sNomDeLInstance)-$($sDate)_$($sHourMinute).log"
$sLogFile              = Join-Path -Path $sLogPath -ChildPath $sLogName

#7z executable info
$s7zPath               = "D:\Utilisateurs\TheBlackWizard\Logiciels\Apps_PS\#Git\backup_minecraft"
$s7zName               = "7z.exe"
$s7zFile               = Join-Path -Path $s7zPath -ChildPath $s7zName

#-----------------------------------------------------------[Execution]------------------------------------------------------------

If (-not($bDebug)) {
    Start-Process -FilePath $s7zFile -ArgumentList "a -bb -bt -mx9 -r -t7z ""$($sArchiveFile)"" ""$($sCheminDeLInstance)""" -RedirectStandardOutput $sLogFile -WindowStyle Minimized -Wait
} Else {
    Write-Host "$($s7zFile)"
    Write-Host "a -r -t7z ""$($sArchiveFile)"" ""$($sCheminDeLInstance)"""
    Write-Host "$($sLogFile)"
}

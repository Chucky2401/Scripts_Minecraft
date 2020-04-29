param(
    [Parameter(Mandatory=$true)] $sNomDeLInstance, $sCheminDeLInstance, $bDebug=$false, $bTest=$false
)

<#
.SYNOPSIS
    Sauvegarde de l'instances Minecraft

.PARAMETER <sNomDeLInstance>
    Nom de l'instance à sauvegarde pour le nom de l'archive

.PARAMETER <sCheminDeLInstance>
    Chemin vers le dossier de l'instance

.PARAMETER <bDebug>
    Booléen pour afficher les messages de DEBUG

.PARAMETER <bTest>
    Si on lance en mode test (rien n'est fait)

.INPUTS
    N/A

.OUTPUTS
    Archive de l'instance   - Example: D:\Jeux\Backup\nomDeLInstance_2020.01.25_18.00.7z
    Logs                    - Exemple: D:\Jeux\Backup\Logs\nomDeLInstance_2020.01.25_18.56.log

.NOTES
    Version:                1.3.1
    Auteur:                 Chucky2401
    Date Création:          25 Janvier 2020
    Dernière modification:  15 Avril 2020
    Changement:             Correction suppression anciennes sauvegardes qui supprimé tout...

.EXAMPLE
    .\backup.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC
 #>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
If (-not($bDebug)) {
    $ErrorActionPreference = "SilentlyContinue"
}

#Windows ISO
$sCheminDeLInstance = $sCheminDeLInstance -replace '/', '\'

#----------------------------------------------------------[Declarations]----------------------------------------------------------

## Variables Utilisateurs
#Dossier de sauvegarde
$sBackupPath           = "D:\Utilisateurs\TheBlackWizard\Jeux\Backup\Minecraft"
#Dossier du log
$sLogPath              = "D:\Utilisateurs\TheBlackWizard\Jeux\Backup\Minecraft\Logs"
#Nombre de sauvegarde à conserver
$iKeep                 = -14
$dMaxKeep              = $(Get-Date).AddDays($iKeep)
#Taux de compression
#Valeurs possibles : Aucune / Plus rapide / Rapide / Normal / Maximum / Ultra
$sTauxCompression      = "Ultra"



####################################################
##                                                ##
## /!\ NE PAS MODIFIER LES VALEURS CI-DESSOUS /!\ ##
##                                                ##
####################################################
#Script Version
$sScriptVersion        = "1.2"

#Date du jour
$sDate                 = Get-Date -UFormat "%Y.%m.%d"
$sHour                 = Get-Date -UFormat "%H"
$sHourMinute           = Get-Date -UFormat "%H.%M"

#Archive information
$sArchiveName          = "$($sNomDeLInstance)-$($sDate)_$($sHour).00.7z"
$sArchiveFile          = Join-Path -Path $sBackupPath -ChildPath $sArchiveName

#Log File Info
$sLogName              = If (-not $bTest) {"$($sNomDeLInstance)-$($sDate)_$($sHourMinute).log"} Else {"TEST.log"}
$sLog7zName            = "SevenZip.log"
$sLogFile              = Join-Path -Path $sLogPath -ChildPath $sLogName
$sLog7zFile            = Join-Path -Path $sLogPath -ChildPath $sLog7zName

#7z executable info
$a7zCompressionValue   = @{
    "Aucune"      = 0;
    "Plus rapide" = 1;
    "Rapide"      = 3;
    "Normal"      = 5;
    "Maximum"     = 7;
    "Ultra"       = 9;
}

$iTauxCompression      = If ( -not $a7zCompressionValue[$sTauxCompression]) {$a7zCompressionValue["Normal"]} Else {$a7zCompressionValue[$sTauxCompression]}
$s7zPath               = "D:\Utilisateurs\TheBlackWizard\Logiciels\Apps_PS\#Git\backup_minecraft"
$s7zName               = "7z.exe"
$s7zCommand            = "a"
$s7zSwitches           = "-bb -bt -mx$($iTauxCompression) -r -t7z"
$s7zFile               = Join-Path -Path $s7zPath -ChildPath $s7zName

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function LogMessage {
    Param(
        [Parameter(Mandatory=$true)] $type, $message, $logFile
    )

    $sDate = Get-Date -UFormat "%d.%m.%Y - %H:%M:%S"
  
    switch ($type) {
        "INFO" {
            Write-Output "[$($sDate)] (INFO)    $($message)" >> $logFile
            Break
        }
        "WARNING" {
            Write-Output "[$($sDate)] (WARNING) $($message)" >> $logFile
            Break
        }
        "ERROR" {
            Write-Output "[$($sDate)] (ERROR)   $($message)" >> $logFile
            Break
        }
        "SUCCESS" {
            Write-Output "[$($sDate)] (SUCCESS) $($message)" >> $logFile
            Break
        }
        "DEBUG" {
            Write-Output "[$($sDate)] (DEBUG)   $($message)" >> $logFile
            Break
        }
        default {
            Write-Output "[$($sDate)] (INFO)    $($message)" >> $logFile
        }
    }
}

Function ShowMessage {
    Param(
        [Parameter(Mandatory=$true)] $type, $message
    )

    $sDate = Get-Date -UFormat "%d.%m.%Y - %H:%M:%S"
  
    switch ($type) {
        "INFO" {
            Write-Host "[$($sDate)] (INFO)    $($message)"
            Break
        }
        "WARNING" {
            Write-Host "[$($sDate)] (WARNING) $($message)" -ForegroundColor Yellow
            Break
        }
        "ERROR" {
            Write-Host "[$($sDate)] (ERROR)   $($message)" -ForegroundColor Red
            Break
        }
        "SUCCESS" {
            Write-Host "[$($sDate)] (SUCCESS) $($message)" -ForegroundColor Green
            Break
        }
        "DEBUG" {
            Write-Host "[$($sDate)] (DEBUG)   $($message)" -ForegroundColor Cyan
            Break
        }
        default {
            Write-Host "[$($sDate)] (INFO)    $($message)"
        }
    }

}

Function SaveToUTF8 {
    Param(
        [Parameter(Mandatory=$true)] $fichier
    )

    $MyFile = Get-Content $fichier
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($fichier, $MyFile, $Utf8NoBomEncoding)
}

Function MergeLogFile {
    Param(
        [Parameter(Mandatory=$true)] $log, $log7z
    )

    $contenuLog7z = Get-Content $log7z

    Write-Output "" >> $log
    Write-Output "#------------------------------------------------------------[7z Log]-------------------------------------------------------------" >> $log
    Write-Output "" >> $log
    $contenuLog7z >> $log
    Write-Output "" >> $log
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

If ($bDebug) { cls }

#En-tête
Write-Host "****************************************"
Write-Host "*                                      *"
Write-Host "*  Sauvegarde de l'instance Minecraft  *"
Write-Host "*       Sauvegarde du $(Get-Date -UFormat "%d/%m/%Y")       *"
Write-Host "*           Début à $(Get-Date -UFormat "%Hh%Mm%Ss")          *"
Write-Host "*                                      *"
Write-Host "****************************************"
Write-Host ""
ShowMessage "INFO" "Nom de l'instance        : $($sNomDeLInstance)"
ShowMessage "INFO" "Chemin de l'instance     : $($sCheminDeLInstance)"
ShowMessage "INFO" "Dossier de Sauvegarde    : $($sBackupPath)"
ShowMessage "INFO" "Nom de l'archive         : $($sArchiveName)"
ShowMessage "INFO" "Taux de compression      : $($sTauxCompression) ($($iTauxCompression))"
ShowMessage "INFO" "Chemin des logs          : $($sLogPath)"
ShowMessage "INFO" "Nom du log               : $($sLogName)"
ShowMessage "INFO" "Nom du log 7z            : $($sLog7zName)"
ShowMessage "INFO" "Nombre de sauvegarde max : $([math]::abs($iKeep))"
Write-Host ""

Write-Output "****************************************" > $sLogFile
Write-Output "*                                      *" >> $sLogFile
Write-Output "*  Sauvegarde de l'instance Minecraft  *" >> $sLogFile
Write-Output "*       Sauvegarde du $(Get-Date -UFormat "%d/%m/%Y")       *" >> $sLogFile
Write-Output "*           Début à $(Get-Date -UFormat "%Hh%Mm%Ss")          *" >> $sLogFile
Write-Output "*                                      *" >> $sLogFile
Write-Output "****************************************" >> $sLogFile
Write-Output "" >> $sLogFile
LogMessage "INFO" "Nom de l'instance        : $($sNomDeLInstance)" $($sLogFile)
LogMessage "INFO" "Chemin de l'instance     : $($sCheminDeLInstance)" $($sLogFile)
LogMessage "INFO" "Dossier de Sauvegarde    : $($sBackupPath)" $($sLogFile)
LogMessage "INFO" "Nom de l'archive         : $($sArchiveName)" $($sLogFile)
LogMessage "INFO" "Taux de compression      : $($sTauxCompression) ($($iTauxCompression))" $($sLogFile)
LogMessage "INFO" "Chemin des logs          : $($sLogPath)" $($sLogFile)
LogMessage "INFO" "Nom du log               : $($sLogName)" $($sLogFile)
LogMessage "INFO" "Nom du log 7z            : $($sLog7zName)" $($sLogFile)
LogMessage "INFO" "Nombre de sauvegarde max : $([math]::abs($iKeep))" $($sLogFile)
Write-Output "" >> $sLogFile

#Archivage du dossier
If (-not($bTest)) {
    ShowMessage "INFO" "Démarrage Sauvegarde..."
    LogMessage "INFO" "Démarrage Sauvegarde..." $($sLogFile)
    If ($bDebug) {
        ShowMessage "DEBUG" "Start-Process :"
        ShowMessage "DEBUG" "          $($s7zFile)"
        ShowMessage "DEBUG" "          $($s7zCommand) $($s7zSwitches) ""$($sArchiveFile)"" ""$($sCheminDeLInstance)"""
        ShowMessage "DEBUG" "          $($sLog7zFile)"
        Write-Host ""

        LogMessage "DEBUG" "Start-Process :" $($sLogFile)
        LogMessage "DEBUG" "          $($s7zFile)" $($sLogFile)
        LogMessage "DEBUG" "          $($s7zCommand) $($s7zSwitches) ""$($sArchiveFile)"" ""$($sCheminDeLInstance)""" $($sLogFile)
        LogMessage "DEBUG" "          $($sLog7zFile)" $($sLogFile)
        Write-Output "" >> $($sLogFile)
    }
    Start-Process -FilePath $s7zFile -ArgumentList "$($s7zCommand) $($s7zSwitches) ""$($sArchiveFile)"" ""$($sCheminDeLInstance)""" -RedirectStandardOutput $sLog7zFile -WindowStyle Hidden -Wait
    If ($?) {
        ShowMessage "SUCCESS" "Sauvegarde réussi !"
        LogMessage "SUCCESS" "Sauvegarde réussi !" $($sLogFile)
    } Else {
        ShowMessage "ERROR" "Sauvegarde échoué !"
        LogMessage "ERROR" "Sauvegarde échoué !" $($sLogFile)
    }
    ShowMessage "INFO" "Log 7z à la fin de ce log"
    Write-Host ""

    LogMessage "INFO" "Log 7z à la fin de ce log" $($sLogFile)
    Write-Output "" >> $($sLogFile)
} Else {
    If ($bDebug) {
        ShowMessage "DEBUG" "Start-Process :"
        ShowMessage "DEBUG" "          $($s7zFile)"
        ShowMessage "DEBUG" "          $($s7zCommand) $($s7zSwitches) ""$($sArchiveFile)"" ""$($sCheminDeLInstance)"""
        ShowMessage "DEBUG" "          $($sLog7zFile)"
        Write-Host ""
        
        LogMessage "DEBUG" "Start-Process :" $($sLogFile)
        LogMessage "DEBUG" "          $($s7zFile)" $($sLogFile)
        LogMessage "DEBUG" "          $($s7zCommand) $($s7zSwitches) ""$($sArchiveFile)"" ""$($sCheminDeLInstance)""" $($sLogFile)
        LogMessage "DEBUG" "          $($sLog7zFile)" $($sLogFile)
        Write-Output "" >> $($sLogFile)
    }
}

#Suppression des fichiers plus vieux...
#... et des logs !
If (-not($bTest)) {
    ShowMessage "INFO" "Suppression des anciens fichiers..."
    LogMessage "INFO" "Suppression des anciens fichiers..." $($sLogFile)

    If ($bDebug) {
        ShowMessage "DEBUG" "Suppression anciennes archives (Get-ChildItem) :"
        #ShowMessage "DEBUG" "          Get-ChildItem $($sBackupPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance)} | Sort LastWriteTime -Descending | Select -Skip $($iKeep) | Remove-Item -Force"
        ShowMessage "DEBUG" "          Get-ChildItem $($sBackupPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force"
        Write-Host ""

        LogMessage "DEBUG" "Suppression ancienne archive (Get-ChildItem) :" $($sLogFile)
        #LogMessage "DEBUG" "          Get-ChildItem $($sBackupPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance)} | Sort LastWriteTime -Descending | Select -Skip $($iKeep) | Remove-Item -Force" $($sLogFile)
        LogMessage "DEBUG" "          Get-ChildItem $($sBackupPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force"
        Write-Output "" >> $($sLogFile)
    }

    Get-ChildItem $sBackupPath | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force
    
    If ($?) {
        ShowMessage "SUCCESS" "Suppression des anciens fichiers réussi !"
        Write-Host ""

        LogMessage "SUCCESS" "Suppression des anciens fichiers réussi !" $($sLogFile)
        Write-Output "" >> $($sLogFile)
    } Else {
        ShowMessage "ERROR" "Suppression des anciens fichiers échoué !"
        Write-Host ""

        LogMessage "ERROR" "Suppression des anciens fichiers échoué !" $($sLogFile)
        Write-Output "" >> $($sLogFile)
    }

    ShowMessage "INFO" "Suppression des anciens logs..."
    LogMessage "INFO" "Suppression des anciens logs..." $($sLogFile)

    If ($bDebug) {
        ShowMessage "DEBUG" "Suppression anciens logs (Get-ChildItem) :"
        ShowMessage "DEBUG" "          Get-ChildItem $($sLogPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force"
        Write-Host ""

        LogMessage "DEBUG" "Suppression anciens logs (Get-ChildItem) :" $($sLogFile)
        LogMessage "DEBUG" "          Get-ChildItem $($sLogPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force" $($sLogFile)
        Write-Output "" >> $($sLogFile)
    }

    Get-ChildItem $sLogPath | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force

    If ($?) {
        ShowMessage "SUCCESS" "Suppression des anciens logs réussi !"
        Write-Host ""

        LogMessage "SUCCESS" "Suppression des anciens logs réussi !" $($sLogFile)
        Write-Output "" >> $($sLogFile)
    } Else {
        ShowMessage "ERROR" "Suppression des anciens logs échoué !"
        Write-Host ""

        LogMessage "ERROR" "Suppression des anciens logs échoué !" $($sLogFile)
        Write-Output "" >> $($sLogFile)
    }
} Else {
    ShowMessage "DEBUG" "Suppression anciennes archives (Get-ChildItem) :"
    ShowMessage "DEBUG" "          Get-ChildItem $($sBackupPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force"
    ShowMessage "DEBUG" "Suppression anciens logs (Get-ChildItem) :"
    ShowMessage "DEBUG" "          Get-ChildItem $($sLogPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force"
    Write-Host ""

    LogMessage "DEBUG" "Suppression anciennes archives (Get-ChildItem) :" $($sLogFile)
    LogMessage "DEBUG" "          Get-ChildItem $($sBackupPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force"
    LogMessage "DEBUG" "Suppression anciens logs (Get-ChildItem) :" $($sLogFile)
    LogMessage "DEBUG" "          Get-ChildItem $($sLogPath) | ?{-not $_.PsIsContainer -and $_.Name -Match $($sNomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force"
    Write-Output "" >> $($sLogFile)
}


#Pied de page
Write-Host "****************************************"
Write-Host "*                                      *"
Write-Host "*  Sauvegarde de l'instance Minecraft  *"
Write-Host "*       Sauvegarde du $(Get-Date -UFormat "%d/%m/%Y")       *"
Write-Host "*            Fin a $(Get-Date -UFormat "%Hh%Mm%Ss")           *"
Write-Host "*                                      *"
Write-Host "****************************************"

Write-Output "****************************************" >> $sLogFile
Write-Output "*                                      *" >> $sLogFile
Write-Output "*  Sauvegarde de l'instance Minecraft  *" >> $sLogFile
Write-Output "*       Sauvegarde du $(Get-Date -UFormat "%d/%m/%Y")       *" >> $sLogFile
Write-Output "*            Fin a $(Get-Date -UFormat "%Hh%Mm%Ss")           *" >> $sLogFile
Write-Output "*                                      *" >> $sLogFile
Write-Output "****************************************" >> $sLogFile

If (-not $bTest) {
    #On merge les fichiers !
    MergeLogFile $sLogFile $sLog7zFile
    #Sauvegarde du log en UTF8
    SaveToUTF8 $sLogFile
}

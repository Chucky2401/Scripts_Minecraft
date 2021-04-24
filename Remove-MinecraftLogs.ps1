<#
.SYNOPSIS
    Supprime les logs Minecraft
.DESCRIPTION
    Ce script s'occupe de supprimer les plus vieux logs de Minecraft
.PARAMETER NomDeLInstance
    Nom de l'instance à sauvegarde pour le nom de l'archive
.PARAMETER CheminMinecraft
    Chemin vers le dossier '.minecraft' de l'instance
.PARAMETER Verbeux
    Booléen pour afficher les messages de DEBUG
.PARAMETER Test
    Si on lance en mode test (rien n'est fait)
.NOTES
    Nom            : Remove-MinecraftLogs
    Version        : 1.0
    Créé par       : Chucky2401
    Date Création  : 24/04/2021
    Modifié par    : Chucky2401
    Date modifié   : 24/04/2021
    Changement     : Création
.EXAMPLE
    .\Remove-MinecraftLogs.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC/.minecraft
    
    Supprime les logs de l'instance 'GoC_Multi' situé dans 'F:\Games\Minecraft\MultiMC\instances\GoC\.minecraft\logs'
.EXAMPLE
    .\Remove-MinecraftLogs.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC/.minecraft -Verbeux

    Supprime les logs de l'instance 'GoC_Multi' situé dans 'F:\Games\Minecraft\MultiMC\instances\GoC\.minecraft\logs' et affiche les messages de debug
.EXAMPLE
    .\Remove-MinecraftLogs.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC/.minecraft -Test

    Test la suppression des logs de l'instance 'GoC_Multi' situé dans 'F:\Games\Minecraft\MultiMC\instances\GoC\.minecraft\logs'.
    /!\ Aucun fichier de logs n'est supprimés 'TEST.log'
.EXAMPLE
    .\Remove-MinecraftLogs.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC/.minecraft -Test -Verbeux

    Test la suppression des logs de l'instance 'GoC_Multi' situé dans 'F:\Games\Minecraft\MultiMC\instances\GoC\.minecraft\logs' avec les messages debug
    /!\ Aucun fichier de logs n'est supprimés 'TEST.log', le fichier de log sera nommé 'TEST.log' et les commandes normalemment exécuté sont affiché à l'écran
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

[cmdletbinding()]
Param (
    [Parameter(Mandatory = $true)]
    [Alias("n")]
    [string]$NomDeLInstance,
    [Parameter(Mandatory = $true)]
    [Alias("c")]
    [string]$CheminMinecraft,
    [Parameter(Mandatory = $false)]
    [Alias("d")]
    [switch]$Verbeux,
    [Parameter(Mandatory = $false)]
    [Alias("t")]
    [switch]$Test
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
If (-not($Verbeux)) {
    $ErrorActionPreference = "SilentlyContinue"
}

#Windows ISO
$CheminMinecraft = $CheminMinecraft -replace '/', '\'

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function LogMessage {
    <#
        .SYNOPSIS
            Ajoute un message dans un fichier de log
        .DESCRIPTION
            Cette fonction ajoute un message dans un fichier de log.
            Elle affiche aussi en tout début de ligne la date et l'heure, suivis du type de message entre paranthèse.
        .PARAMETER type
            Type de message :
                INFO        : Message à titre informatif en bleu
                WARNING     : Message à titre d'avertissement en jaune
                ERROR       : Message d'erreur en rouge
                SUCCESS     : Message de réussite en vert
                DEBUG       : Message de débugage en bleu sur fond noir
                AUTRES      : Message à titre informatif en bleu mais sans la date et le type en début de ligne
        .PARAMETER message
            Message à afficher
       .PARAMETER sLogFile
           Chaîne de caractères indiquant l'emplacement du fichier de log.
           Il est possible d'envoyer une variable de type Array() pour que la fonction retourne la chaîne de caractère. Voir Exemple 3 sur l'utilisation dans ce cas.
        .EXAMPLE
            ShowLogMessage "INFO" "Récupération des fichiers..." C:\Temp\backup.log
        .EXAMPLE
            ShowLogMessage "WARNING" "Processus introuvable" C:\Temp\restauration.log
       .EXAMPLE
           aTexte = @()
           aTexte = ShowLogMessage "WARNING" "Processus introuvable" aTexte
        .NOTES
            Nom             : LogMessage
            Créé par        : Tristan BREJON
            Date écrit      : 01/01/2019
            Modifié par     : Tristan BREJON
            Date modifié    : 07/04/2021
            Changement      : Message peut être null pour ajouter un retour à la ligne
    #>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Alias("t")]
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS", "DEBUG", "AUTRES", IgnoreCase = $false)]
        [string]$type,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [Alias("m")]
        [string]$message,
        [Parameter(Mandatory = $true)]
        [Alias("l")]
        $sLogFile
    )

    $sDate = Get-Date -UFormat "%d.%m.%Y - %H:%M:%S"
  
    switch ($type) {
        "INFO" {
            $sSortie = "[$($sDate)] (INFO)    $($message)"
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "WARNING" {
            $sSortie = "[$($sDate)] (WARNING) $($message)"
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "ERROR" {
            $sSortie = "[$($sDate)] (ERROR)   $($message)"
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "SUCCESS" {
            $sSortie = "[$($sDate)] (SUCCESS) $($message)"
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "DEBUG" {
            $sSortie = "[$($sDate)] (DEBUG)   $($message)"
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "AUTRES" {
            $sSortie = "$($message)"
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
    }
}

function ShowMessage {
   <#
       .SYNOPSIS
           Affiche un message
       .DESCRIPTION
           Cette fonction affiche un message avec une couleure différente en fonction du type de message.
           Elle affiche aussi en tout début de ligne la date et l'heure, suivis du type de message entre paranthèse.
       .PARAMETER type
           Type de message :
               INFO        : Message à titre informatif en bleu
               WARNING     : Message à titre d'avertissement en jaune
               ERROR       : Message d'erreur en rouge
               SUCCESS     : Message de réussite en vert
               DEBUG       : Message de débugage en bleu sur fond noir
               AUTRES      : Message à titre informatif en bleu mais sans la date et le type en début de ligne
       .PARAMETER message
           Message à afficher
       .EXAMPLE
           ShowLogMessage "INFO" "Récupération des fichiers..."
       .EXAMPLE
           ShowLogMessage "WARNING" "Processus introuvable"
       .NOTES
           Nom             : ShowMessage
           Créé par        : Tristan BREJON
           Date écrit      : 01/01/2019
           Modifié par     : Tristan BREJON
           Date modifié    : 07/04/2021
           Changement      : Message peut être null pour ajouter un retour à la ligne
   #>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Alias("t")]
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS", "DEBUG", "AUTRES", IgnoreCase = $false)]
        [string]$type,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [Alias("m")]
        [string]$message
    )

    $sDate = Get-Date -UFormat "%d.%m.%Y - %H:%M:%S"
  
    switch ($type) {
        "INFO" {
            Write-Host "[$($sDate)] (INFO)    $($message)" -ForegroundColor Cyan
            Break
        }
        "WARNING" {
            Write-Host "[$($sDate)] (WARNING) $($message)" -ForegroundColor White -BackgroundColor Black
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
            Write-Host "[$($sDate)] (DEBUG)   $($message)" -ForegroundColor Cyan -BackgroundColor Black
            Break
        }
        "AUTRES" {
            Write-Host "$($message)"
            Break
        }
        default {
            Write-Host "[$($sDate)] (INFO)    $($message)" -ForegroundColor Cyan
        }
    }
}

function ShowLogMessage {
   <#
       .SYNOPSIS
           Affiche un message et l'ajoute dans un fichier de log
       .DESCRIPTION
           Cette fonction affiche un message avec une couleure différente en fonction du type de message, et log le même message dans un fichier de log.
           Elle affiche aussi en tout début de ligne la date et l'heure, suivis du type de message entre paranthèse.
       .PARAMETER type
           Type de message :
               INFO    : Message à titre informatif en bleu
               WARNING : Message à titre d'avertissement en jaune
               ERROR   : Message d'erreur en rouge
               SUCCESS : Message de réussite en vert
               DEBUG   : Message de débugage en bleu sur fond noir
               AUTRES  : Message à titre informatif en bleu mais sans la date et le type en début de ligne
       .PARAMETER message
           Message à afficher
       .PARAMETER sLogFile
           Chaîne de caractères indiquant l'emplacement du fichier de log.
           Il est possible d'envoyer une variable de type Array() pour que la fonction retourne la chaîne de caractère. Voir Exemple 3 sur l'utilisation dans ce cas.
       .EXAMPLE
           ShowLogMessage "INFO" "Récupération des fichiers..." C:\Temp\backup.log
       .EXAMPLE
           ShowLogMessage "WARNING" "Processus introuvable" C:\Temp\restauration.log
       .EXAMPLE
           aTexte = @()
           aTexte = ShowLogMessage "WARNING" "Processus introuvable" aTexte
       .NOTES
           Nom            : ShowLogMessage
           Créé par       : Tristan BREJON
           Date écrit     : 01/01/2019
           Modifié par    : Tristan BREJON
           Date modifié   : 07/04/2021
           Changement     : Message peut être null pour ajouter un retour à la ligne
   #>
   [cmdletbinding()]
   Param (
       [Parameter(Mandatory = $true)]
       [Alias("t")]
       [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS", "DEBUG", "AUTRES", IgnoreCase = $false)]
       [string]$type,
       [Parameter(Mandatory = $true)]
       [AllowEmptyString()]
       [Alias("m")]
       [string]$message,
       [Parameter(Mandatory = $true)]
       [Alias("l")]
       $sLogFile
   )

    $sDate = Get-Date -UFormat "%d.%m.%Y - %H:%M:%S"
  
    switch ($type) {
        "INFO" {
            $sSortie = "[$($sDate)] (INFO)    $($message)"
            Write-Host $sSortie -ForegroundColor Cyan
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "WARNING" {
            $sSortie = "[$($sDate)] (WARNING) $($message)"
            Write-Host $sSortie -ForegroundColor White -BackgroundColor Black
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "ERROR" {
            $sSortie = "[$($sDate)] (ERROR)   $($message)"
            Write-Host $sSortie -ForegroundColor Red
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "SUCCESS" {
            $sSortie = "[$($sDate)] (SUCCESS) $($message)"
            Write-Host $sSortie -ForegroundColor Green
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "DEBUG" {
            $sSortie = "[$($sDate)] (DEBUG)   $($message)"
            Write-Host $sSortie -ForegroundColor Cyan -BackgroundColor Black
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
        "AUTRES" {
            $sSortie = "$($message)"
            Write-Host $sSortie
            Write-Output $sSortie >> $sLogFile
            If ($sLogFile.GetType().Name -ne "String") {
                $sSortie
            }
            Break
        }
    }
}

function Write-CenterText {
    <#
        .SYNOPSIS
            Affiche un message centrer à l'écran
        .DESCRIPTION
            Cette fonction s'occupe d'afficher un message en le centrant à l'écran.
            Il est aussi possible de l'ajouter à un log.
        .PARAMETER sChaine
            Chaîne de caractère à centrer à l'écran
        .PARAMETER sLogFile
            Chaîne de caractères indiquant l'emplacement du fichier de log
        .EXAMPLE
            Write-CenterText "Récupération des fichiers..."
        .EXAMPLE
            Write-CenterText "Processus introuvable" C:\Temp\restauration.log
        .NOTES
            Nom             : Write-CenterText
            Créé par        : Tristan BREJON
            Date écrit      : 01/01/2021
            Modifié par     : Tristan BREJON
            Date modifié    : 19/03/2021
            Changement      : Help et paramètres
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Position=0,Mandatory=$true)]
        [string]$sChaine,
        [Parameter(Position=1,Mandatory=$false)]
        [string]$sLogFile = $null
    )
   $nConsoleWidth          = (Get-Host).UI.RawUI.MaxWindowSize.Width
   $nLongueurChaine        = $sChaine.Length
   $nTaillePadding         = "{0:N0}" -f (($nConsoleWidth - $nLongueurChaine) / 2)
   $nTailleAvecPaddingLeft = $nTaillePadding / 1 + $nLongueurChaine
   $sChaineFinal           = $sChaine.PadLeft($nTailleAvecPaddingLeft, " ").PadRight($nTailleAvecPaddingLeft, " ")

   Write-Host $sChaineFinal
   If ($null -ne $sLogFile) {
       Write-Output $sChaineFinal >> $sLogFile
   }
}

function SaveToUTF8 {
    <#
        .SYNOPSIS
            Convertie un fichier en UTF8
        .DESCRIPTION
            Cette fonction s'occupe de récupérer le contenu du fichier en paramètre, le convertis en UTF8 et ré-écris complètement le fichier avec cet encodage.
        .PARAMETER fichier
            Chaîne de caractères indiquant l'emplacement du fichier
        .EXAMPLE
            SaveToUTF8 C:\Temp\backup_2021.03.19.log
        .NOTES
            Nom             : SaveToUTF8
            Créé par        : Tristan BREJON
            Date écrit      : 01/01/2021
            Modifié par     : Tristan BREJON
            Date modifié    : 19/03/2021
            Changement      : Help et paramètres
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$fichier
    )

    $MyFile = Get-Content $fichier
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($fichier, $MyFile, $Utf8NoBomEncoding)
}

function MergeLogFile {
    <#
        .SYNOPSIS
            Fusionne deux fichiers de logs
        .DESCRIPTION
            Parfois dans des scripts j'utilise deux fichiers de logs, celui du script courant et celui de 7-Zip.
            Cette fonction s'occupe de fusionner les deux fichiers de logs dans le premier envoyé en paramètre.
        .PARAMETER log
            Chaîne de caractères indiquant l'emplacement du fichier de log
        .PARAMETER log7z
            Chaîne de caractères indiquant l'emplacement du fichier de log 7-Zip
        .EXAMPLE
            MergeLogFile C:\Temp\backup_2020.03.19.log C:\Temp\7zip_2020.03.19.log
        .NOTES
            Nom             : MergeLogFile
            Créé par        : Tristan BREJON
            Date écrit      : 01/01/2021
            Modifié par     : Tristan BREJON
            Date modifié    : 19/03/2021
            Changement      : Help et paramètres
    #>
    Param (
        [CmdletBinding()]
        [Parameter(Mandatory = $true)]
        [String]$log,
        [Parameter(Mandatory = $true)]
        [String]$log7z
    )

    $contenuLog7z = Get-Content $log7z

    Write-Output "" >> $log
    Write-Output "#------------------------------------------------------------[7z Log]-------------------------------------------------------------" >> $log
    Write-Output "" >> $log
    $contenuLog7z >> $log
    Write-Output "" >> $log
}

#----------------------------------------------------------[Declarations]----------------------------------------------------------

## Variables Utilisateur / User variables
#####################################################
##                                                 ##
##     /!\ MODIFIER LES VALEURS CI-DESSOUS /!\     ##
##         /!\ EDIT YOUR VARIABLES HERE /!\        ##
##                                                 ##
#####################################################
#Dossier du log / Log directory
$sLogPath              = "D:\Utilisateurs\TheBlackWizard\Jeux\Minecraft\Logs"
#Nombre de jour de logs à conserver / How many backup to keep
$iKeep                 = 14

####################################################
##                                                ##
## /!\ NE PAS MODIFIER LES VALEURS CI-DESSOUS /!\ ##
##            /!\ DO NOT EDIT BELOW /!\           ##
##                                                ##
####################################################
$dMaxKeep              = $(Get-Date).AddDays(-$iKeep)
#Date du jour
$sDate                 = Get-Date -UFormat "%Y.%m.%d"
$sHourMinute           = Get-Date -UFormat "%H.%M"

#Log File Info
$sLogName              = If (-not $Test) {"$($NomDeLInstance)-$($sDate)_$($sHourMinute).log"} Else {"TEST.log"}
$sLogFile              = Join-Path -Path $sLogPath -ChildPath $sLogName

#Chemin Minecraft
$aCheminMinecraft      = $CheminMinecraft.Split('\')
$iLongueurArrayChemin  = $aCheminMinecraft.Length
$sDerniereValeur       = $aCheminMinecraft[$iLongueurArrayChemin-1]

#Booléen
$bCheminMinecraftOk    = $True

#-----------------------------------------------------------[Execution]------------------------------------------------------------

If ($Verbeux) { Clear-Host }

#En-tête
Write-CenterText -sChaine "****************************************" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*                                      *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*     Suppression de log Minecraft     *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*       Suppression du $(Get-Date -UFormat "%d/%m/%Y")      *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*           Début à $(Get-Date -UFormat "%Hh%Mm%Ss")          *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*                                      *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "****************************************" -sLogFile $($sLogFile)
ShowLogMessage "AUTRES" "" $($sLogFile)

ShowLogMessage "AUTRES" "Variables de la session en cours :" $($sLogFile)
ShowLogMessage "AUTRES" "Nom de l'instance        : $($NomDeLInstance)" $($sLogFile)
ShowLogMessage "AUTRES" "Chemin de Minecraft      : $($CheminMinecraft)" $($sLogFile)
ShowLogMessage "AUTRES" "Chemin des logs          : $($sLogPath)" $($sLogFile)
ShowLogMessage "AUTRES" "Nom du log               : $($sLogName)" $($sLogFile)
ShowLogMessage "AUTRES" "Nombre de logs max       : $([math]::abs($iKeep))" $($sLogFile)
ShowLogMessage "AUTRES" "" $($sLogFile)

#Vérification chemin Minecraft
If ($sDerniereValeur -ne ".minecraft") {
    ShowLogMessage "ERROR" "Vous n'avez pas fournis un chemin vers le .minecraft !" $($sLogFile)
    If ($Verbeux) {
        ShowLogMessage "DEBUG" "Chemin : $($CheminMinecraft)" $($sLogFile)
        ShowLogMessage "DEBUG" "Dernière valeur : $($sDerniereValeur)" $($sLogFile)
    }
    ShowLogMessage "ERROR" "Veuillez fournir un chemin poitant sur .minecraft" $($sLogFile)
    ShowLogMessage "INFO" "Exemple : 'F:/Games/Minecraft/MultiMC/instances/GoC/.minecraft'" $($sLogFile)
    $bCheminMinecraftOk = $False
} Else {
    $CheminMinecraft += "\logs"
}

If ($bCheminMinecraftOk) {
    #Suppression des fichiers plus vieux...
    #... et des logs !
    If (-not($Test)) {
        ShowLogMessage "INFO" "Suppression des anciens logs Minecraft..." $($sLogFile)

        If ($Verbeux) {
            ShowLogMessage "DEBUG" "          Get-ChildItem $($CheminMinecraft) | Where-Object {-not $_.PsIsContainer -and $_.Name -Match "".log.gz"" -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force"  $($sLogFile)
            ShowLogMessage "AUTRES" "" $($sLogFile)
        }

        Get-ChildItem $($CheminMinecraft) | Where-Object {-not $_.PsIsContainer -and $_.Name -Match ".log.gz" -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force

        If ($?) {
            ShowLogMessage "SUCCESS" "Suppression des anciens fichiers de logs Minecraft réussi !" $($sLogFile)
        } Else {
            ShowLogMessage "ERROR" "Suppression des anciens fichiers de logs Minecraft échoué !" $($sLogFile)
        }
        ShowLogMessage "AUTRES" "" $($sLogFile)

        ShowLogMessage "INFO" "Suppression des anciens logs..." $($sLogFile)

        If ($Verbeux) {
            ShowLogMessage "DEBUG" "          Get-ChildItem $($sLogPath) | Where-Object {-not $_.PsIsContainer -and $_.Name -Match $($NomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force" $($sLogFile)
            ShowLogMessage "AUTRES" "" $($sLogFile)
        }

        Get-ChildItem $($sLogPath) | Where-Object {-not $_.PsIsContainer -and $_.Name -Match $($NomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force

        If ($?) {
            ShowLogMessage "SUCCESS" "Suppression des anciens logs réussi !" $($sLogFile)
        } Else {
            ShowLogMessage "ERROR" "Suppression des anciens logs échoué !" $($sLogFile)
        }
        ShowLogMessage "AUTRES" "" $($sLogFile)
        
    } Else {
        ShowLogMessage "INFO" "{MODE TEST} Aucune suppression ne sera effectué" $($sLogFile)
        ShowLogMessage "WARNING" "{MODE TEST} Activé le mode {DEBUG} pour plus de détail en mode test" $($sLogFile)
        ShowLogMessage "AUTRES" "" $($sLogFile)

        If ($Verbeux) {
            ShowLogMessage "DEBUG" "Suppression des anciens logs Minecraft (Get-ChildItem) :" $($sLogFile)
            ShowLogMessage "DEBUG" "          Get-ChildItem $($CheminMinecraft) | Where-Object {-not $_.PsIsContainer -and $_.Name -Match "".log.gz"" -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force" $($sLogFile)
            ShowLogMessage "DEBUG" "Suppression anciens logs (Get-ChildItem) :" $($sLogFile)
            ShowLogMessage "DEBUG" "          Get-ChildItem $($sLogPath) | Where-Object {-not $_.PsIsContainer -and $_.Name -Match $($NomDeLInstance) -and $_.CreationTime -le $($dMaxKeep)} | Remove-Item -Force" $($sLogFile)
            ShowLogMessage "AUTRES" "" $($sLogFile)
        }
    }
}

#Pied de page
Write-CenterText -sChaine "****************************************" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*                                      *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*     Suppression de log Minecraft     *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*       Suppression du $(Get-Date -UFormat "%d/%m/%Y")      *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*            Fin a $(Get-Date -UFormat "%Hh%Mm%Ss")           *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "*                                      *" -sLogFile $($sLogFile)
Write-CenterText -sChaine "****************************************" -sLogFile $($sLogFile)

If (-not $Test) {
    #On merge les fichiers !
    MergeLogFile $sLogFile $sLog7zFile
    #Sauvegarde du log en UTF8
    SaveToUTF8 $sLogFile
}

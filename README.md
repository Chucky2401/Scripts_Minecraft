# Backup Minecraft

- [Backup Minecraft](#backup-minecraft)
  - [FRENCH VERSION](#french-version)
    - [Détail](#détail)
    - [Configuration](#configuration)
  - [ENGLISH VERSION](#english-version)
    - [Detailed](#detailed)
    - [Configuration](#configuration-1)

## FRENCH VERSION

Script PowerShell pour sauvegarder une instance Minecraft de MultiMC, avec l'utilisation des commandes d'arrêt

### Détail

    .SYNOPSIS
        Sauvegarde instance Minecraft
    .DESCRIPTION
        Ce script s'occupe de sauvegarder une instance Minecraft sous format 7z
    .PARAMETER NomDeLInstance
        Nom de l'instance à sauvegarde pour le nom de l'archive
    .PARAMETER CheminDeLInstance
        Chemin vers le dossier de l'instance
    .PARAMETER Verbeux
        Booléen pour afficher les messages de DEBUG
    .PARAMETER Test
        Si on lance en mode test (rien n'est fait)
    .NOTES
        Nom            : Backup-Minecraft
        Version        : 1.4.1
        Créé par       : Chucky2401
        Date Création  : 25/01/2020
        Modifié par    : Chucky2401
        Date modifié   : 22/04/2021
        Changement     : Modification de quelques messages
    .EXAMPLE
        .\Backup-Minecraft.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC
        
        Sauvegarde l'instance 'GoC_Multi' situé dans 'F:\Games\Minecraft\MultiMC\instances\GoC'
    .EXAMPLE
        .\Backup-Minecraft.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC -Verbeux

        Sauvegarde l'instance 'GoC_Multi' situé dans 'F:\Games\Minecraft\MultiMC\instances\GoC' et affiche les messages de debug
    .EXAMPLE
        .\Backup-Minecraft.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC -Test

        Sauvegarde l'instance 'GoC_Multi' situé dans 'F:\Games\Minecraft\MultiMC\instances\GoC' en mode test.
        /!\ Aucun fichier de sauvegarde n'est créé et le fichier de log sera nommé 'TEST.log'
    .EXAMPLE
        .\Backup-Minecraft.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC -Test -Verbeux

        Sauvegarde l'instance 'GoC_Multi' situé dans 'F:\Games\Minecraft\MultiMC\instances\GoC' en mode test et avec debug
        /!\ Aucun fichier de sauvegarde n'est créé, le fichier de log sera nommé 'TEST.log' et les commandes normalemment exécuté sont affiché à l'écran

### Configuration

Dans le script, de la ligne **478** à **486**, il y a 4 variables à modifier :

- **$sBackupPath** : Est le dossier où sera stocker les sauvegardes
- **$sLogPath** : Est le dossier où sera stocker les logs de la sauvegarde
- **$iKeep** : Nombre de sauvegarde que vous souhaitez conserver
- **$sTauxCompression** : Taux de compression à utiliser pour les archives. Plus le taux est élevé, plus la sauvegarde sera longue, mais l'archive prendra moins de place. Voici les taux possibles :
  - Aucune
  - Plus rapide
  - Rapide
  - Normal
  - Maximum
  - Ultra

---

## ENGLISH VERSION

Script PowerShell to backup Minecraft instance of MultiMC with use of post-stop command.

### Detailed

    .SYNOPSIS
        Backup Minecraft instance
    .DESCRIPTION
        This script backup a Minecraft instance in a 7z archive
    .PARAMETER NomDeLInstance
        Instance name. Used for the archive name, too
    .PARAMETER CheminDeLInstance
        Instance path
    .PARAMETER Verbeux
        Switch, enable verbose message
    .PARAMETER Test
        Switch, test mode (nothing do)
    .NOTES
        Name           : Backup-Minecraft
        Version        : 1.4.1
        Created by     : Chucky2401
        Date Created   : 25/01/2020
        Modified by    : Chucky2401
        Date modified  : 22/04/2021
        Last change    : Modification variables message at the beginning
    .EXAMPLE
        .\Backup-Minecraft.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC
        
        Backup instance 'GoC_Multi' from 'F:\Games\Minecraft\MultiMC\instances\GoC'
    .EXAMPLE
        .\Backup-Minecraft.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC -Verbeux

        Backup instance 'GoC_Multi' from 'F:\Games\Minecraft\MultiMC\instances\GoC' and display debug message
    .EXAMPLE
        .\Backup-Minecraft.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC -Test

        Backup instance 'GoC_Multi' from 'F:\Games\Minecraft\MultiMC\instances\GoC' in test mode.
        /!\ No backup file will be created and log file will be named 'TEST.log'
    .EXAMPLE
        .\Backup-Minecraft.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC -Test -Verbeux

        Backup instance 'GoC_Multi' from 'F:\Games\Minecraft\MultiMC\instances\GoC' in test mode and display debug message
        /!\ No backup file will be created, log file will be named 'TEST.log' and cmdlets use to backup will be displayed.

### Configuration

In the script, From line **478** to **486**, there are 4 variables to modify :

- **$sBackupPath** : Folder where the backups will be store
- **$sLogPath** : Folder where the logs file will be store
- **$iKeep** : Number of backup you want to keep
- **$sTauxCompression** : Ratio rate to use. Higher ratio take more time, but the archive will be small. Here the ratio rate available (in french, english translation between parenthesis) :
  - Aucune (None)
  - Plus rapide (Faster)
  - Rapide (Fastest)
  - Normal (Normal)
  - Maximum (Best)
  - Ultra (Ultra)

# Scripts Minecraft

- [Scripts Minecraft](#scripts-minecraft)
  - [Backup Minecraft](#backup-minecraft)
    - [Détail](#détail)
    - [Configuration](#configuration)
  - [Remove Minecraft logs](#remove-minecraft-logs)
    - [Détail](#détail-1)
    - [Configuration](#configuration-1)

## Backup Minecraft

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

Dans le fichier `backup-config.ini`, il y a 4 variables à modifier :

- **$sBackupPath** : Est le dossier où sera stocker les sauvegardes
- **$sLogPath** : Est le dossier où sera stocker les logs de la sauvegarde
- **$iKeep** : Nombre de sauvegarde que vous souhaitez conserver en jours
- **$sTauxCompression** : Taux de compression à utiliser pour les archives. Plus le taux est élevé, plus la sauvegarde sera longue, mais l'archive prendra moins de place. Voici les taux possibles :
  - Aucune
  - Plus rapide
  - Rapide
  - Normal
  - Maximum
  - Ultra

## Remove Minecraft logs

### Détail

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
        /!\ Aucun fichier de logs n'est supprimés 'TEST.log', le fichier de log sera nommé 'TEST.log' et les commandes normalement exécuté sont affiché à l'écran

### Configuration

Dans le fichier `removeLogs-config.ini`, il y a 2 variables à modifier :

- **$sLogPath** : Est le dossier où sera stocker les logs de la sauvegarde
- **$iKeep** : Nombre de sauvegarde que vous souhaitez conserver en nombre de jours

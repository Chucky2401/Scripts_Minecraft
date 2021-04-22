# Backup Minecraft

Script PowerShell to backup Minecraft instance of MultiMC with use of post-stop command.

## Detailed
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
        Nom            : Backup-Minecraft
        Version        : 1.4
        Créé par       : Chucky2401
        Date Création  : 25/01/2020
        Modifié par    : Chucky2401
        Date modifié   : 22/04/2021
        Changement     : Template and update functions
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

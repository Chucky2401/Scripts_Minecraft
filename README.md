# Backup Minecraft
Script PowerShell to backup Minecraft instance of MultiMC with use of pre-launch/post-stopped command.

# Detailed
## SYNOPSIS
    Sauvegarde de l'instances Minecraft

## PARAMETERS
### PARAMETER <sNomDeLInstance>
    Nom de l'instance à sauvegarde pour le nom de l'archive

### PARAMETER <sCheminDeLInstance>
    Chemin vers le dossier de l'instance

### PARAMETER <bDebug>
    Booléen pour afficher les messages de DEBUG

### PARAMETER <bTest>
    Si on lance en mode test (rien n'est fait)

## INPUTS
    N/A

## OUTPUTS
    Archive de l'instance   - Example: D:\Jeux\Backup\nomDeLInstance_2020.01.25.7z
    Logs                    - Exemple: D:\Jeux\Backup\Logs\nomDeLInstance_2020.01.25.log

## NOTES
    Version:                1.2
    Auteur:                 Chucky2401
    Date Création:          25 Janvier 2020
    Dernière modification:  26 Janvier 2020
    Changement:             Meilleur log - Mode Test - Message/Log de DEBUG

## EXAMPLE
    .\backup.ps1 GoC_Multi F:/Games/Minecraft/MultiMC/instances/GoC

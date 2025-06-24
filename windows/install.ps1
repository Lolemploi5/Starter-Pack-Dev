# =============================================================================
# Script d'installation Windows - Starter Pack Dev
# =============================================================================
# Ce script installe et configure un environnement de développement complet
# sur Windows 10/11 avec tous les outils essentiels pour un développeur moderne.
#
# Prérequis: Windows 10/11 avec winget disponible
# Auteur: Starter Pack Dev
# Date: 20 juin 2025
# =============================================================================

#Requires -Version 5.1

# Configuration pour éviter les erreurs d'exécution
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# =============================================================================
# Configuration des couleurs et symboles
# =============================================================================

$Script:Colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Blue"
    Magenta = "Magenta"
    Cyan = "Cyan"
    White = "White"
}

$Script:Symbols = @{
    Check = "✅"
    Cross = "❌"
    Info = "ℹ️"
    Rocket = "🚀"
    Gear = "⚙️"
    Package = "📦"
    Warning = "⚠️"
}

# =============================================================================
# Fonctions utilitaires
# =============================================================================

function Write-Header {
    param([string]$Message)
    
    Write-Host ""
    Write-Host "=================================" -ForegroundColor Magenta
    Write-Host $Message -ForegroundColor White
    Write-Host "=================================" -ForegroundColor Magenta
    Write-Host ""
}

function Write-Step {
    param([string]$Message)
    Write-Host "$($Script:Symbols.Gear) $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "$($Script:Symbols.Check) $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "$($Script:Symbols.Cross) $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "$($Script:Symbols.Info) $Message" -ForegroundColor Cyan
}

function Write-Warning {
    param([string]$Message)
    Write-Host "$($Script:Symbols.Warning) $Message" -ForegroundColor Yellow
}

# Vérifier si une commande existe
function Test-CommandExists {
    param([string]$Command)
    
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Vérifier si un package winget est installé
function Test-WingetPackageInstalled {
    param([string]$PackageId)
    
    try {
        $result = winget list --id $PackageId --exact 2>$null
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

# Installer un package via winget
function Install-WingetPackage {
    param(
        [string]$PackageId,
        [string]$DisplayName
    )
    
    Write-Step "Vérification de $DisplayName..."
    
    if (Test-WingetPackageInstalled $PackageId) {
        Write-Success "$DisplayName est déjà installé"
        return $true
    }
    
    Write-Step "Installation de $DisplayName..."
    
    try {
        $result = winget install --id $PackageId --silent --accept-package-agreements --accept-source-agreements 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$DisplayName installé avec succès"
            return $true
        }
        else {
            Write-Warning "$DisplayName : installation échouée (code $LASTEXITCODE)"
            Write-Info "Sortie: $result"
            return $false
        }
    }
    catch {
        Write-Error "Erreur lors de l'installation de $DisplayName : $($_.Exception.Message)"
        return $false
    }
}

# =============================================================================
# Script principal
# =============================================================================

try {
    Write-Header "$($Script:Symbols.Rocket) STARTER PACK DEV - INSTALLATION WINDOWS"
    
    Write-Host "Ce script va installer et configurer votre environnement de développement." -ForegroundColor White
    Write-Host "Appuyez sur Entrée pour continuer ou Ctrl+C pour annuler..." -ForegroundColor Yellow
    Read-Host
    
    # =============================================================================
    # 1. Vérification des prérequis
    # =============================================================================
    
    Write-Header "$($Script:Symbols.Info) VÉRIFICATION DES PRÉREQUIS"
    
    # Vérifier que winget est disponible
    Write-Step "Vérification de winget..."
    if (-not (Test-CommandExists "winget")) {
        Write-Error "winget n'est pas disponible sur ce système"
        Write-Info "Veuillez installer winget via le Microsoft Store ou mettre à jour Windows"
        Write-Info "Lien: https://www.microsoft.com/p/app-installer/9nblggh4nns1"
        exit 1
    }
    Write-Success "winget est disponible"
    
    # Vérifier la version de PowerShell
    Write-Step "Vérification de PowerShell..."
    $psVersion = $PSVersionTable.PSVersion
    Write-Success "PowerShell $psVersion détecté"
    
    # =============================================================================
    # 2. Installation des outils de développement
    # =============================================================================
    
    Write-Header "$($Script:Symbols.Package) INSTALLATION DES OUTILS DE DÉVELOPPEMENT"
      # Liste des packages à installer
    $packages = @(
        @{ Id = "Git.Git"; Name = "Git" },
        @{ Id = "Microsoft.WindowsTerminal"; Name = "Windows Terminal" },
        @{ Id = "Microsoft.VisualStudioCode"; Name = "Visual Studio Code" },
        @{ Id = "OpenJS.NodeJS.LTS"; Name = "Node.js LTS" },
        @{ Id = "Python.Python.3.11"; Name = "Python 3.11" },
        @{ Id = "EclipseAdoptium.Temurin.21.JDK"; Name = "OpenJDK 21" },
        @{ Id = "GoLang.Go"; Name = "Go" },
        @{ Id = "Starship.Starship"; Name = "Starship" },
        @{ Id = "GitHub.cli"; Name = "GitHub CLI" },
        @{ Id = "zyedidia.micro"; Name = "Micro" }
    )
    
    Write-Info "Installation des packages: $($packages.Name -join ', ')"
    
    $failedPackages = @()
    
    foreach ($package in $packages) {
        $success = Install-WingetPackage -PackageId $package.Id -DisplayName $package.Name
        if (-not $success) {
            $failedPackages += $package.Name
        }
        Start-Sleep -Seconds 1  # Petite pause entre les installations
    }
    
    # Afficher un résumé des échecs éventuels
    if ($failedPackages.Count -gt 0) {
        Write-Warning "Packages ayant échoué: $($failedPackages -join ', ')"
        Write-Info "Vous pouvez les réinstaller manuellement plus tard"
    }
    
    # =============================================================================
    # 3. Rafraîchissement des variables d'environnement
    # =============================================================================
    
    Write-Header "$($Script:Symbols.Gear) RAFRAÎCHISSEMENT DE L'ENVIRONNEMENT"
    
    Write-Step "Rafraîchissement des variables d'environnement..."
    
    # Rafraîchir le PATH depuis le registre
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    
    Write-Success "Variables d'environnement rafraîchies"
    
    # =============================================================================
    # 4. Configuration de Starship
    # =============================================================================
    
    Write-Header "$($Script:Symbols.Gear) CONFIGURATION DE STARSHIP"
    
    # Créer le dossier .config s'il n'existe pas
    $configDir = Join-Path $env:USERPROFILE ".config"
    Write-Step "Création du dossier .config..."
    
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
        Write-Success "Dossier .config créé"
    } else {
        Write-Success "Dossier .config existe déjà"
    }
    
    # Copier le fichier de configuration Starship
    $configSource = Join-Path (Split-Path $PSScriptRoot -Parent) "config\starship.toml"
    $configDest = Join-Path $configDir "starship.toml"
    
    Write-Step "Configuration de Starship..."
    
    if (Test-Path $configSource) {
        try {
            Copy-Item $configSource $configDest -Force
            Write-Success "Configuration Starship copiée vers ~/.config/starship.toml"
        }
        catch {
            Write-Error "Erreur lors de la copie de la configuration Starship: $($_.Exception.Message)"
            exit 1
        }
    }
    else {
        Write-Info "Fichier $configSource non trouvé, création d'une configuration par défaut"
        
        # Créer une configuration Starship basique
        $defaultConfig = @"
# Configuration Starship - Starter Pack Dev
format = """
`$username\
`$hostname\
`$directory\
`$git_branch\
`$git_state\
`$git_status\
`$cmd_duration\
`$line_break\
`$python\
`$character"""

[directory]
style = "blue"

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[git_branch]
symbol = "🌱 "
style = "bold yellow"
"@
        
        try {
            $defaultConfig | Out-File -FilePath $configDest -Encoding UTF8
            Write-Success "Configuration Starship par défaut créée"
        }
        catch {
            Write-Error "Erreur lors de la création de la configuration par défaut: $($_.Exception.Message)"
            exit 1
        }
    }
    
    # =============================================================================
    # 5. Configuration du profil PowerShell
    # =============================================================================
    
    Write-Header "$($Script:Symbols.Gear) CONFIGURATION DU PROFIL POWERSHELL"
    
    Write-Step "Configuration du profil PowerShell..."
    
    # Créer le profil s'il n'existe pas
    if (-not (Test-Path $PROFILE)) {
        Write-Step "Création du profil PowerShell..."
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
        Write-Success "Profil PowerShell créé"
    }
    
    # Lire le contenu actuel du profil
    $currentProfile = ""
    if (Test-Path $PROFILE) {
        $currentProfile = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    }
    
    # Lignes à ajouter au profil
    $profileLines = @(
        "",
        "# ========================================",
        "# Configuration Starter Pack Dev",
        "# ========================================",
        "",
        "# Starship prompt",
        "Invoke-Expression (&starship init powershell)",
        "",
        "# Alias utiles",
        "Set-Alias nano micro",
        "Set-Alias -Name reload -Value 'powershell.exe'",
        "",
        "# Fonction pour recharger le profil",
        "function Reload-Profile { . `$PROFILE }",
        "Set-Alias rp Reload-Profile"
    )
    
    # Vérifier et ajouter les lignes manquantes
    $linesToAdd = @()
    foreach ($line in $profileLines) {
        if ($line -and -not $currentProfile.Contains($line)) {
            $linesToAdd += $line
        }
    }
    
    if ($linesToAdd.Count -gt 0) {
        try {
            $linesToAdd | Add-Content $PROFILE -Encoding UTF8
            Write-Success "Profil PowerShell mis à jour"
        }
        catch {
            Write-Error "Erreur lors de la mise à jour du profil: $($_.Exception.Message)"
            exit 1
        }
    }
    else {
        Write-Info "Profil PowerShell déjà configuré"
    }
    
    # =============================================================================
    # 6. Rechargement du profil
    # =============================================================================
    
    Write-Header "$($Script:Symbols.Gear) RECHARGEMENT DU PROFIL"
    
    Write-Step "Rechargement du profil PowerShell..."
    
    try {
        . $PROFILE
        Write-Success "Profil rechargé avec succès"
    }
    catch {
        Write-Info "Le rechargement nécessitera un redémarrage de PowerShell"
        Write-Info "Erreur: $($_.Exception.Message)"
    }
    
    # =============================================================================
    # 7. Vérifications finales
    # =============================================================================
    
    Write-Header "$($Script:Symbols.Check) VÉRIFICATIONS FINALES"
    
    Write-Host "Vérification des installations:" -ForegroundColor White
    
    # Commandes à vérifier
    $commandsToCheck = @(
        @{ Command = "git"; Name = "Git" },
        @{ Command = "node"; Name = "Node.js" },
        @{ Command = "python"; Name = "Python" },
        @{ Command = "go"; Name = "Go" },
        @{ Command = "java"; Name = "Java" },
        @{ Command = "micro"; Name = "Micro" },
        @{ Command = "starship"; Name = "Starship" },
        @{ Command = "gh"; Name = "GitHub CLI" }
    )
    
    foreach ($cmd in $commandsToCheck) {
        if (Test-CommandExists $cmd.Command) {
            try {
                $version = & $cmd.Command --version 2>$null | Select-Object -First 1
                if (-not $version) {
                    $version = "Installé"
                }
                Write-Success "$($cmd.Name): $version"
            }
            catch {
                Write-Success "$($cmd.Name): Installé"
            }
        }
        else {
            Write-Warning "$($cmd.Name): Non disponible (redémarrage requis)"
        }
    }
    
    # =============================================================================
    # 8. Message final
    # =============================================================================
    
    Write-Header "$($Script:Symbols.Rocket) INSTALLATION TERMINÉE"
    
    Write-Success "Votre environnement de développement est maintenant configuré !"
    Write-Host ""
    Write-Host "Outils installés:" -ForegroundColor White
    Write-Host "  • Git - Contrôle de version" -ForegroundColor Cyan
    Write-Host "  • Windows Terminal - Terminal moderne" -ForegroundColor Cyan
    Write-Host "  • Visual Studio Code - Éditeur de code" -ForegroundColor Cyan
    Write-Host "  • Node.js LTS - Développement JavaScript" -ForegroundColor Cyan
    Write-Host "  • Python 3.11 - Développement Python" -ForegroundColor Cyan
    Write-Host "  • OpenJDK 21 - Développement Java" -ForegroundColor Cyan
    Write-Host "  • Go - Développement Go" -ForegroundColor Cyan
    Write-Host "  • Starship - Prompt moderne" -ForegroundColor Cyan
    Write-Host "  • GitHub CLI - Interface GitHub en ligne de commande" -ForegroundColor Cyan
    Write-Host "  • Micro - Éditeur de texte moderne" -ForegroundColor Cyan
    Write-Host ""
    Write-Info "Pour appliquer tous les changements, redémarrez PowerShell ou Windows Terminal"
    Write-Host ""
    Write-Host "Commandes utiles:" -ForegroundColor White
    Write-Host "  • rp ou Reload-Profile - Recharger le profil PowerShell" -ForegroundColor Yellow
    Write-Host "  • nano <fichier> - Éditer un fichier avec Micro" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Happy coding! 🎉" -ForegroundColor Green
    
} catch {
    Write-Error "Une erreur inattendue s'est produite: $($_.Exception.Message)"
    Write-Info "Stack trace: $($_.ScriptStackTrace)"
    exit 1
}
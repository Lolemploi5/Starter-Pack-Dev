#!/bin/bash

# =============================================================================
# Script d'installation macOS - Starter Pack Dev
# =============================================================================
# Ce script installe et configure un environnement de développement complet
# sur macOS avec tous les outils essentiels pour un développeur moderne.
#
# Auteur: Starter Pack Dev
# Date: $(date +"%Y-%m-%d")
# =============================================================================

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour la sortie
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Symboles
CHECK="✅"
CROSS="❌"
INFO="ℹ️"
ROCKET="🚀"
GEAR="⚙️"
PACKAGE="📦"

# =============================================================================
# Fonctions utilitaires
# =============================================================================

print_header() {
    echo ""
    echo -e "${PURPLE}=================================${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${PURPLE}=================================${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}${GEAR} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

print_info() {
    echo -e "${CYAN}${INFO} $1${NC}"
}

# Vérifier si une commande existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Vérifier si un package Homebrew est installé
brew_package_installed() {
    brew list "$1" >/dev/null 2>&1
}

# =============================================================================
# Script principal
# =============================================================================

print_header "${ROCKET} STARTER PACK DEV - INSTALLATION MACOS"

echo -e "${WHITE}Ce script va installer et configurer votre environnement de développement.${NC}"
echo -e "${YELLOW}Appuyez sur Entrée pour continuer ou Ctrl+C pour annuler...${NC}"
read -r

# =============================================================================
# 1. Vérification et installation de Homebrew
# =============================================================================

print_header "${PACKAGE} INSTALLATION DE HOMEBREW"

if command_exists brew; then
    print_success "Homebrew est déjà installé"
    print_step "Mise à jour de Homebrew..."
    if brew update; then
        print_success "Homebrew mis à jour avec succès"
    else
        print_error "Erreur lors de la mise à jour de Homebrew"
        exit 1
    fi
else
    print_step "Installation de Homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        print_success "Homebrew installé avec succès"
        
        # Ajouter Homebrew au PATH pour les Mac Apple Silicon
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        print_error "Erreur lors de l'installation de Homebrew"
        exit 1
    fi
fi

# =============================================================================
# 2. Installation des outils de développement
# =============================================================================

print_header "${PACKAGE} INSTALLATION DES OUTILS DE DÉVELOPPEMENT"

# Liste des packages à installer
packages=(
    "git"
    "nvm" 
    "node"
    "python@3.12"
    "go"
    "openjdk"
    "micro"
    "starship"
    "gh"
    "wget"
)

print_info "Installation des packages: ${packages[*]}"

for package in "${packages[@]}"; do
    print_step "Vérification de $package..."
    
    if brew_package_installed "$package"; then
        print_success "$package est déjà installé"
    else
        print_step "Installation de $package..."
        if brew install "$package"; then
            print_success "$package installé avec succès"
        else
            print_error "Erreur lors de l'installation de $package"
            exit 1
        fi
    fi
done

# Configuration spéciale pour Java
print_step "Configuration de Java..."
if brew_package_installed "openjdk"; then
    # Créer le lien symbolique pour Java
    sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk 2>/dev/null || true
    print_success "Java configuré"
fi

# =============================================================================
# 3. Configuration de l'environnement
# =============================================================================

print_header "${GEAR} CONFIGURATION DE L'ENVIRONNEMENT"

# Créer le dossier ~/.config si nécessaire
print_step "Création du dossier ~/.config..."
if mkdir -p ~/.config; then
    print_success "Dossier ~/.config créé/vérifié"
else
    print_error "Erreur lors de la création du dossier ~/.config"
    exit 1
fi

# Copier le fichier de configuration Starship
config_source="../config/starship.toml"
config_dest="$HOME/.config/starship.toml"

print_step "Configuration de Starship..."
if [[ -f "$config_source" ]]; then
    if cp "$config_source" "$config_dest"; then
        print_success "Configuration Starship copiée vers ~/.config/starship.toml"
    else
        print_error "Erreur lors de la copie de la configuration Starship"
        exit 1
    fi
else
    print_info "Fichier $config_source non trouvé, création d'une configuration par défaut"
    # Créer une configuration Starship basique
    cat > "$config_dest" << 'EOF'
# Configuration Starship - Starter Pack Dev
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$cmd_duration\
$line_break\
$python\
$character"""

[directory]
style = "blue"

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[git_branch]
symbol = "🌱 "
style = "bold yellow"
EOF
    print_success "Configuration Starship par défaut créée"
fi

# =============================================================================
# 4. Configuration du shell (.zshrc)
# =============================================================================

print_header "${GEAR} CONFIGURATION DU SHELL"

zshrc_file="$HOME/.zshrc"

# Créer .zshrc s'il n'existe pas
if [[ ! -f "$zshrc_file" ]]; then
    touch "$zshrc_file"
    print_success "Fichier .zshrc créé"
fi

print_step "Configuration de .zshrc..."

# Fonction pour ajouter une ligne si elle n'existe pas déjà
add_to_zshrc() {
    local line="$1"
    if ! grep -Fxq "$line" "$zshrc_file"; then
        echo "$line" >> "$zshrc_file"
        print_success "Ajouté: $line"
    else
        print_info "Déjà présent: $line"
    fi
}

# Ajouter les configurations
echo "" >> "$zshrc_file"
echo "# ========================================" >> "$zshrc_file"
echo "# Configuration Starter Pack Dev" >> "$zshrc_file"
echo "# ========================================" >> "$zshrc_file"

# Starship
add_to_zshrc 'eval "$(starship init zsh)"'

# Alias pour micro
add_to_zshrc "alias nano='micro'"

# Configuration NVM
if [[ -d "/opt/homebrew/opt/nvm" ]]; then
    add_to_zshrc 'export NVM_DIR="$HOME/.nvm"'
    add_to_zshrc '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"'
    add_to_zshrc '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"'
fi

# Configuration Java
add_to_zshrc 'export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"'

print_success "Configuration .zshrc terminée"

# =============================================================================
# 5. Rechargement de la configuration
# =============================================================================

print_header "${GEAR} RECHARGEMENT DE LA CONFIGURATION"

print_step "Rechargement de .zshrc..."
if source "$zshrc_file" 2>/dev/null; then
    print_success "Configuration rechargée avec succès"
else
    print_info "Le rechargement nécessitera un redémarrage du terminal"
fi

# =============================================================================
# 6. Vérifications finales
# =============================================================================

print_header "${CHECK} VÉRIFICATIONS FINALES"

echo -e "${WHITE}Vérification des installations:${NC}"

# Vérifier les commandes installées
commands_to_check=("git" "node" "python3" "go" "java" "micro" "starship" "gh" "wget")

for cmd in "${commands_to_check[@]}"; do
    if command_exists "$cmd"; then
        version=$($cmd --version 2>/dev/null | head -n1 || echo "Version non disponible")
        print_success "$cmd: $version"
    else
        print_error "$cmd n'est pas disponible"
    fi
done

# =============================================================================
# 7. Message final
# =============================================================================

print_header "${ROCKET} INSTALLATION TERMINÉE"

echo -e "${GREEN}${CHECK} Votre environnement de développement est maintenant configuré !${NC}"
echo ""
echo -e "${WHITE}Outils installés:${NC}"
echo -e "${CYAN}  • Git - Contrôle de version${NC}"
echo -e "${CYAN}  • Node.js & NVM - Développement JavaScript${NC}"
echo -e "${CYAN}  • Python 3.12 - Développement Python${NC}"
echo -e "${CYAN}  • Go - Développement Go${NC}"
echo -e "${CYAN}  • OpenJDK - Développement Java${NC}"
echo -e "${CYAN}  • Micro - Éditeur de texte moderne${NC}"
echo -e "${CYAN}  • Starship - Prompt moderne${NC}"
echo -e "${CYAN}  • GitHub CLI - Interface GitHub en ligne de commande${NC}"
echo -e "${CYAN}  • Wget - Utilitaire de téléchargement${NC}"
echo ""
echo -e "${YELLOW}${INFO} Pour appliquer tous les changements, redémarrez votre terminal ou exécutez:${NC}"
echo -e "${WHITE}    source ~/.zshrc${NC}"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"
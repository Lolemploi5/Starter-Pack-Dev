# 🚀 Starter Pack Dev

> **Configuration d'environnement de développement automatisée pour macOS et Windows**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows-blue.svg)](https://github.com/Lolemploi5/Starter-Pack-Dev)
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20PowerShell-green.svg)](https://github.com/Lolemploi5/Starter-Pack-Dev)
[![Stars](https://img.shields.io/github/stars/Lolemploi5/Starter-Pack-Dev?style=social)](https://github.com/Lolemploi5/Starter-Pack-Dev/stargazers)

*Transformez une machine fraîche en environnement de développement professionnel en une seule commande* ⚡

[🎯 Installation](#-installation) • [🛠️ Outils inclus](#️-outils-inclus) • [⚙️ Configuration](#️-configuration) • [🤝 Contribution](#-contribution)

---

## 📖 À propos

**Starter Pack Dev** est une collection de scripts d'installation automatisée qui configure un environnement de développement complet et optimisé pour les développeurs modernes. Fini le temps perdu à configurer manuellement chaque outil !

### ✨ Pourquoi ce projet ?

- 🎯 **Gain de temps** : Configuration complète en une seule commande
- 🔄 **Reproductible** : Même environnement sur toutes vos machines
- 🛡️ **Fiable** : Scripts testés et robustes avec gestion d'erreurs
- 🎨 **Interface moderne** : Prompt Starship et terminal stylé
- 🌍 **Multi-plateforme** : Support macOS et Windows

## 🚀 Installation

### macOS

```bash
# Cloner le dépôt
git clone https://github.com/Lolemploi5/Starter-Pack-Dev.git
cd Starter-Pack-Dev

# Exécuter le script d'installation
chmod +x mac/install.sh
./mac/install.sh
```

### Windows

```powershell
# Cloner le dépôt
git clone https://github.com/Lolemploi5/Starter-Pack-Dev.git
cd Starter-Pack-Dev

# Exécuter le script d'installation (PowerShell en admin recommandé)
.\windows\install.ps1
```

> **Note** : Sur Windows, assurez-vous que [winget](https://docs.microsoft.com/en-us/windows/package-manager/winget/) est installé (inclus dans Windows 10 1809+ et Windows 11).

## 🛠️ Outils inclus

### 🔧 Outils de développement

- **Git** - Contrôle de version
- **Node.js** (LTS) + **NVM** - Environnement JavaScript
- **Python 3.11+** - Développement Python
- **Go** - Langage Go
- **OpenJDK 21** - Développement Java
- **GitHub CLI** - Interface GitHub en ligne de commande

### 🎨 Outils d'interface

- **Starship** - Prompt cross-platform moderne
- **Micro** - Éditeur de texte dans le terminal
- **Windows Terminal** (Windows uniquement)
- **Visual Studio Code** (Windows uniquement)
- **Wget** (macOS uniquement)

## ⚙️ Configuration

### 🎨 Personnalisation Starship

Le fichier `config/starship.toml` contient la configuration du prompt. Vous pouvez le personnaliser selon vos préférences :

```toml
# Exemple de configuration
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
```

#### 🌟 Presets officiels Starship

Pour une personnalisation avancée, Starship propose de nombreux presets prêts à l'emploi :

- **[Nerd Font Symbols](https://starship.rs/presets/nerd-font.html)** - Utilise les symboles Nerd Font
- **[No Nerd Font](https://starship.rs/presets/no-nerd-font.html)** - Sans polices spéciales
- **[Bracketed Segments](https://starship.rs/presets/bracketed-segments.html)** - Segments entre crochets
- **[Plain Text Symbols](https://starship.rs/presets/plain-text.html)** - Symboles en texte simple
- **[No Runtime Versions](https://starship.rs/presets/no-runtimes.html)** - Cache les versions des langages
- **[No Empty Icons](https://starship.rs/presets/no-empty-icons.html)** - Supprime les icônes vides
- **[Pure Preset](https://starship.rs/presets/pure-preset.html)** - Imite Pure prompt
- **[Pastel Powerline](https://starship.rs/presets/pastel-powerline.html)** - Style powerline pastel

🔗 **[Voir tous les presets officiels](https://starship.rs/presets/)** sur le site Starship

Pour utiliser un preset :

1. Copiez la configuration du preset choisi
2. Remplacez le contenu de `~/.config/starship.toml`
3. Redémarrez votre terminal

### 📁 Structure du projet

```text
starter-pack-dev/
├── 📄 README.md                 # Documentation principale
├── 📁 config/                   # Fichiers de configuration
│   └── starship.toml             # Configuration Starship
├── 📁 mac/                      # Scripts macOS
│   └── install.sh                # Script d'installation macOS
└── 📁 windows/                  # Scripts Windows
    └── install.ps1               # Script d'installation Windows
```

### 🔧 Aliases créés

#### macOS (zsh)

```bash
alias nano='micro'              # Utiliser micro au lieu de nano
eval "$(starship init zsh)"     # Initialiser Starship
```

#### Windows (PowerShell)

```powershell
Set-Alias nano micro                                    # Utiliser micro au lieu de nano
Set-Alias rp Reload-Profile                            # Recharger le profil PowerShell
Invoke-Expression (&starship init powershell)          # Initialiser Starship
```

## 🎯 Fonctionnalités avancées

### ✅ Gestion d'erreurs robuste

- Vérification des prérequis avant installation
- Gestion individuelle des échecs d'installation
- Messages d'erreur détaillés et solutions proposées

### 🎨 Interface utilisateur moderne

- Interface colorée avec émojis
- Indicateurs de progression visuels
- Messages informatifs et encourageants

### 🔄 Idempotence

- Les scripts peuvent être exécutés plusieurs fois en toute sécurité
- Détection automatique des outils déjà installés
- Pas de doublons dans les fichiers de configuration

## 🧪 Compatibilité

| Plateforme | Version | Status |
|-----------|---------|--------|
| macOS | 10.15+ (Catalina) | ✅ Testé |
| macOS | 11.0+ (Big Sur) | ✅ Testé |
| macOS | 12.0+ (Monterey) | ✅ Testé |
| Windows | 10 (1809+) | ✅ Testé |
| Windows | 11 | ✅ Testé |

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment vous pouvez aider :

### 🐛 Signaler un bug

1. Vérifiez que le bug n'a pas déjà été signalé
2. Créez une [issue](https://github.com/Lolemploi5/Starter-Pack-Dev/issues) détaillée
3. Incluez les informations système et les logs d'erreur

### 💡 Proposer une amélioration

1. Fork le projet
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/amazing-feature`)
3. Committez vos changements (`git commit -m 'Add some amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrez une Pull Request

### 📝 Code de conduite

Ce projet adhère au [Contributor Covenant](https://www.contributor-covenant.org/). En participant, vous vous engagez à respecter ce code.

## 📋 Roadmap

- [ ] 🐧 Support Linux (Ubuntu/Debian)
- [ ] 🐳 Version Docker
- [ ] 🔧 Configuration personnalisable via fichier YAML
- [ ] 📦 Support de gestionnaires de paquets additionnels
- [ ] 🎮 Mode interactif pour choisir les outils à installer
- [ ] 📊 Dashboard de statut des installations

## 📄 License

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- [Starship](https://starship.rs/) pour le prompt cross-platform
- [Homebrew](https://brew.sh/) pour le gestionnaire de paquets macOS
- [winget](https://docs.microsoft.com/en-us/windows/package-manager/winget/) pour le gestionnaire de paquets Windows
- Tous les [contributeurs](https://github.com/Lolemploi5/Starter-Pack-Dev/contributors) qui rendent ce projet possible

---

Fait avec ❤️ par la communauté des développeurs

[![GitHub](https://img.shields.io/badge/GitHub-Suivez--nous-black?logo=github)](https://github.com/Lolemploi5)
Si ce projet vous a aidé, n'hésitez pas à lui donner une ⭐ !

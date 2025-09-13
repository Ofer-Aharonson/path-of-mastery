# Path of Mastery 🏆

*A Professional World of Warcraft Addon for New Player Guidance*

[![GitHub](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/Ofer-Aharonson/path-of-mastery)
[![WoW](https://img.shields.io/badge/World%20of%20Warcraft-Retail-green)](https://worldofwarcraft.com)
[![Lua](https://img.shields.io/badge/Lua-5.1-blue)](https://www.lua.org)
[![Ace3](https://img.shields.io/badge/Ace3-Framework-orange)](https://www.wowace.com/projects/ace3)

## 📖 Overview

**Path of Mastery** is a comprehensive World of Warcraft addon designed to provide intelligent, adaptive guidance for players of all experience levels. Built with the professional Ace3 framework, it offers a modern, user-friendly interface that adapts to each player's skill level and preferences.

### 🎯 Key Features

- **🎮 Smart Experience Assessment**: Startup dialog to assess player experience level
- **📚 Adaptive Tip System**: Content tailored to beginner, intermediate, and advanced players
- **⚙️ Professional Configuration**: Advanced options panel with AceConfig integration
- **🗺️ Addon Compartment Support**: Modern WoW interface integration
- **🎵 Audio Feedback**: Optional sound effects for important notifications
- **🌍 Multi-language Support**: Localization files for multiple languages
- **📊 Minimap Integration**: Convenient access button with customizable position
- **🔧 Slash Commands**: Quick access via `/pom` commands

## 🚀 Installation

### Method 1: Git Clone (Recommended for Developers)
```bash
git clone https://github.com/Ofer-Aharonson/path-of-mastery.git
cd path-of-mastery
# Copy the entire folder to your WoW AddOns directory
```

### Method 2: Manual Download
1. Download the latest release from [GitHub Releases](https://github.com/Ofer-Aharonson/path-of-mastery/releases)
2. Extract the `Path of Mastery` folder
3. Copy it to: `World of Warcraft/_retail_/Interface/AddOns/`
4. Restart World of Warcraft or reload your UI with `/reload`

### Method 3: WoW Addon Managers
- **Twitch/CurseForge**: Search for "Path of Mastery"
- **WoWUp**: Automatic updates and installation
- **Ajour**: Cross-platform addon manager

## 🎮 Usage

### First Time Setup
1. **Login to WoW** with the addon installed
2. **Experience Assessment Dialog** will appear automatically
3. **Choose your experience level**:
   - **Just Started**: For complete beginners
   - **Played a Bit**: For players with some experience
   - **Advanced Player**: For experienced players

### Daily Usage
- **Automatic Tips**: Receive contextual guidance based on your location and level
- **Minimap Button**: Left-click to open main interface, right-click for quick menu
- **Addon Compartment**: Access via the modern WoW interface button
- **Slash Commands**: Use `/pom` for quick access

### Available Commands
```
/pom                    # Show available commands
/pom show              # Open main interface
/pom hide              # Hide main interface
/pom config            # Open configuration panel
/pom startup           # Show experience assessment dialog
/pom resetdialog       # Reset startup dialog for next login
/pom reset             # Reset all settings and reload UI
```

## ⚙️ Configuration

Access the configuration panel via:
- **WoW Interface Options** → AddOns → Path of Mastery
- **Slash Command**: `/pom config`
- **Minimap Button**: Right-click → Options

### General Settings
- **Enable Addon**: Toggle addon functionality
- **Show Tips**: Enable/disable tip notifications
- **Sound Effects**: Audio feedback for notifications
- **Experience Level**: View/change your experience level
- **Reset Startup Dialog**: Show assessment dialog again

### Minimap Settings
- **Show Minimap Button**: Toggle minimap icon visibility
- **Button Position**: Drag to reposition on minimap

### Tip Settings
- **Tip Delay**: Time between tip notifications (1-30 seconds)
- **Max Tips Per Session**: Limit tips per gaming session
- **Tip Content**: Filtered based on experience level

## 🏗️ Architecture

### Modular Design
```
Path of Mastery/
├── Path of Mastery.lua     # Main bootstrap file
├── Path of Mastery.toc     # Addon metadata and file list
├── Core.lua               # Main logic and event handling
├── UI.lua                 # User interface components
├── Config.lua             # Configuration management
├── Data.lua               # Tip data and content management
├── libs/                  # Ace3 framework libraries
├── locales/               # Localization files
└── .vscode/               # Development configuration
```

### Ace3 Integration
- **AceAddon-3.0**: Addon lifecycle management
- **AceDB-3.0**: Persistent data storage
- **AceEvent-3.0**: Event handling system
- **AceConfig-3.0**: Configuration panel
- **AceGUI-3.0**: User interface widgets
- **AceConsole-3.0**: Slash command handling
- **AceLocale-3.0**: Localization support

## 🎯 Experience-Based Features

### Beginner Mode
- **Frequent Tips**: Every 3 seconds on average
- **Basic Guidance**: Fundamental WoW concepts
- **Zone Navigation**: Starter area assistance
- **Quest Help**: Step-by-step quest guidance

### Intermediate Mode
- **Moderate Tips**: Every 5 seconds on average
- **Advanced Strategies**: Combat and questing tips
- **Efficiency Focus**: Time-saving techniques
- **Class-Specific Advice**: Role-based guidance

### Advanced Mode
- **Minimal Tips**: Every 10 seconds, level 20+ only
- **Expert Strategies**: High-level optimization
- **Achievement Help**: Difficult challenge guidance
- **Performance Tips**: Advanced gameplay techniques

## 🌍 Localization

Currently supported languages:
- **English (enUS)**: Complete translation
- **German (deDE)**: Complete translation
- **French (frFR)**: Complete translation

### Adding New Languages
1. Copy `locales/enUS.lua` to `locales/YOUR_LOCALE.lua`
2. Translate all string values
3. Update `Path of Mastery.toc` with new locale file
4. Test translations in-game

## 🔧 Development

### Prerequisites
- **World of Warcraft Retail** (latest version)
- **Git** for version control
- **VS Code** (recommended) with Lua extensions

### Development Setup
```bash
# Clone the repository
git clone https://github.com/Ofer-Aharonson/path-of-mastery.git
cd path-of-mastery

# Install development dependencies (if any)
# Copy to WoW AddOns directory for testing
cp -r . "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\"
```

### Testing
1. **Load the addon** in WoW
2. **Test all features**:
   - Startup dialog functionality
   - Experience level selection
   - Tip system behavior
   - Configuration panel
   - Slash commands
3. **Verify localization** in different languages
4. **Test edge cases** and error handling

### Code Style
- **Lua 5.1** compatible syntax
- **Ace3** framework conventions
- **Descriptive variable names**
- **Comprehensive comments**
- **Error handling** with pcall where appropriate

## 🤝 Contributing

We welcome contributions! Here's how to get involved:

### Ways to Contribute
- **🐛 Bug Reports**: Found an issue? [Open an issue](https://github.com/Ofer-Aharonson/path-of-mastery/issues)
- **💡 Feature Requests**: Have an idea? [Create a feature request](https://github.com/Ofer-Aharonson/path-of-mastery/issues)
- **📝 Documentation**: Help improve documentation
- **🌍 Translation**: Add new language support
- **🔧 Code**: Submit pull requests for bug fixes or features

### Development Workflow
1. **Fork** the repository
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes** following our coding standards
4. **Test thoroughly** in WoW
5. **Commit with clear messages**: `git commit -m "Add: Feature description"`
6. **Push to your fork**: `git push origin feature/your-feature-name`
7. **Create a Pull Request** with detailed description

### Guidelines
- **Test all changes** before submitting
- **Follow existing code style**
- **Update documentation** for new features
- **Add appropriate comments**
- **Respect the Ace3 framework** patterns

## 📊 Version History

### Version 1.0.0 (Current)
- ✅ Initial release with UI-based startup system
- ✅ Experience level assessment and adaptation
- ✅ Professional Ace3 framework integration
- ✅ Comprehensive configuration panel
- ✅ Multi-language support
- ✅ Addon Compartment integration

### Future Releases
- **Version 1.1.0**: Quest tracking system
- **Version 1.2.0**: Achievement guide integration
- **Version 2.0.0**: Advanced analytics dashboard

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Ofer Aharonson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 🙏 Acknowledgments

- **Ace3 Team**: For the incredible addon framework
- **WoW Community**: For inspiration and feedback
- **GitHub Copilot**: For development assistance
- **World of Warcraft**: For the amazing game that inspired this addon

## 📞 Contact & Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/Ofer-Aharonson/path-of-mastery/issues)
- **Discussions**: [Join community discussions](https://github.com/Ofer-Aharonson/path-of-mastery/discussions)
- **Email**: For private inquiries or business opportunities

### Support the Project
If you find this addon helpful, consider:
- ⭐ **Starring** the repository
- 🐛 **Reporting issues** you encounter
- 💡 **Suggesting improvements**
- 🤝 **Contributing code** or translations

---

**Happy adventuring in Azeroth!** 🏆⚔️</content>
<parameter name="filePath">c:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\Path of Mastery\README.md

# Z.AI ❤️ Claude Code Dual Setup

A powerful setup script that allows you to run both Claude configurations side-by-side, enabling seamless switching between the default Claude CLI and Z.AI's enhanced version without changing your settings.

## 🚀 Features

- **Dual Configuration**: Run both `claude` and `zclaude` commands simultaneously
- **Smart Shell Detection**: Automatically detects and configures your shell (bash, zsh, fish, ksh, csh)
- **MCP Server Integration**: Adds Z.AI MCP servers for enhanced functionality
- **Multi-Platform Support**: Works on Linux, macOS, and WSL
- **Safe Installation**: Creates backups of existing configurations
- **Enhanced Models**: Access to glm-4.5-air and glm-4.6 models via Z.AI

## 📋 Prerequisites

- Node.js and npm (for Claude CLI installation)
- Internet connection for downloading packages
- Your Anthropic API token

## 🛠️ Installation

### Quick Start

1. **Download the setup script:**
   ```bash
   curl -O https://your-repo/setup_zclaude.sh
   chmod +x setup_zclaude.sh
   ```

2. **Run the setup:**
   ```bash
   ./setup_zclaude.sh
   ```

3. **Follow the prompts:**
   - Enter your Anthropic Auth Token when prompted
   - The script will detect your shell and configure everything automatically

### Docker Testing

For testing in a fresh environment:

```bash
# Build and run with Docker Compose
docker-compose up --build

# Or build and run manually
docker build -t zclaude-test .
docker run -it --rm -v $(pwd):/app zclaude-test
```

## 🔧 What Gets Installed

### Claude CLI
- Installs `@anthropic-ai/claude-code` via npm
- Verifies installation and PATH configuration

### Shell Configuration
- **bash**: `~/.bashrc` or `~/.bash_profile`
- **zsh**: `~/.zshrc`
- **fish**: `~/.config/fish/config.fish`
- **ksh**: `~/.kshrc`
- **csh/tcsh**: `~/.cshrc`

### MCP Servers
- `zai-mcp-server`: Z.AI's enhanced functionality
- `web-search-prime`: Web search capabilities
- `web-reader`: Web page reading functionality

## 📖 Usage

After installation, you'll have access to both commands:

### Default Claude CLI
```bash
claude --help
claude "Help me with this code"
```

### Z.AI Enhanced Claude
```bash
zclaude --help
zclaude "Help me with this code"
```

### Switching Between Environments
- Use `claude` for the standard Anthropic experience
- Use `zclaude` for Z.AI's enhanced features and different models

## 🌟 Z.AI Enhanced Features

- **Enhanced Models**: glm-4.5-air, glm-4.6
- **Web Search**: Via web-search-prime MCP server
- **Web Reading**: Via web-reader MCP server
- **Extended Functionality**: Additional Z.AI-specific capabilities

## 🔍 Environment Variables

The `zclaude` command sets these environment variables automatically:

```bash
ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
API_TIMEOUT_MS="3000000"
ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air"
ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.6"
ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.6"
ANTHROPIC_AUTH_TOKEN="your-token"
```

## 🛠️ Shell-Specific Configurations

### Bash/ZSH/KSH
```bash
zclaude_env() {
  ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
  API_TIMEOUT_MS="3000000" \
  ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air" \
  ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.6" \
  ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.6" \
  ANTHROPIC_AUTH_TOKEN="your-token" \
  claude "$@"
}

alias zclaude="zclaude_env"
```

### Fish Shell
```fish
function zclaude_env
    set -gx ANTHROPIC_BASE_URL "https://api.z.ai/api/anthropic"
    set -gx API_TIMEOUT_MS "3000000"
    set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL "glm-4.5-air"
    set -gx ANTHROPIC_DEFAULT_SONNET_MODEL "glm-4.6"
    set -gx ANTHROPIC_DEFAULT_OPUS_MODEL "glm-4.6"
    set -gx ANTHROPIC_AUTH_TOKEN "your-token"
    claude $argv
end

alias zclaude=zclaude_env
```

### CSH/TCSH
```csh
alias zclaude_env 'setenv ANTHROPIC_BASE_URL "https://api.z.ai/api/anthropic"; \
setenv API_TIMEOUT_MS "3000000"; \
setenv ANTHROPIC_DEFAULT_HAIKU_MODEL "glm-4.5-air"; \
setenv ANTHROPIC_DEFAULT_SONNET_MODEL "glm-4.6"; \
setenv ANTHROPIC_DEFAULT_OPUS_MODEL "glm-4.6"; \
setenv ANTHROPIC_AUTH_TOKEN "your-token"; \
claude \!*'

alias zclaude zclaude_env
```

## 🔧 Troubleshooting

### Common Issues

1. **Claude CLI not found:**
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. **zclaude command not found:**
   ```bash
   # Reload your shell configuration
   source ~/.bashrc  # or ~/.zshrc, etc.
   ```

3. **MCP servers not connecting:**
   ```bash
   # Check server status
   claude mcp list

   # Verify your API token is correct
   ```

4. **Permission denied:**
   ```bash
   chmod +x setup_zclaude.sh
   ```

### Getting Help

- **Claude Documentation**: https://docs.claude.com
- **GitHub Issues**: https://github.com/anthropics/claude-code/issues
- **Z.AI Support**: Check with your Z.AI provider

## 🗑️ Uninstallation

To remove the Z.AI configuration:

### Manual Removal
1. **Remove the zclaude configuration from your shell file:**
   ```bash
   # Edit your shell configuration file and remove the
   # Z.AI Claude Configuration section
   ```

2. **Remove MCP servers:**
   ```bash
   claude mcp remove zai-mcp-server
   claude mcp remove web-search-prime
   claude mcp remove web-reader
   ```

### Clean Script
You can also run the setup script again - it will automatically remove existing configurations before installing new ones.

## 📁 File Structure

```
zclaude/
├── setup_zclaude.sh           # Main setup script
├── Dockerfile                 # Docker configuration for testing
├── docker-compose.yml         # Docker Compose configuration
├── README.md                  # This file
└── DOCKER_README.md           # Docker-specific instructions
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly using the Docker environment
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Anthropic** for the Claude CLI
- **Z.AI** for enhanced functionality and MCP servers
- The open-source community for shell compatibility solutions

---

**🚀 Enjoy using both Claude environments seamlessly!**
# Z.AI ❤️ Claude Code Dual Setup

**Tired of constantly switching between Claude Code configurations?** This script solves the common problem of having to choose between your Claude Code Pro / Max subscription and Z.AI Coding Plan. Now you can use both side-by-side with simple, separate commands - no more complicated file edits or Docker setups!

## 🎯 Problem Solved

### The Common Frustration:

- **Claude Code Pro / Max Subscription**: You have a Pro / Max subscription that you want to use for certain tasks
- **Z.AI Coding Plan**: You also have Z.AI's coding plan and want to use it for certain tasks
- **Configuration Hell**: The official documentation tells you to edit `~/.claude/settings.json` to switch between them
- **Constant Switching**: Every time you want to change providers, you have to manually edit configuration files
- **Complicated Solutions**: Docker setups and other workarounds are complex and heavy-weight

### The Simple Solution:

```bash
# Use your Claude Code Pro / Max subscription
claude "Help me with planning my project"

# Use Z.AI's coding plan with cheaper models
zclaude "Help me with debugging this code"
zclaude "Help me with building this project"
```

## 🚀 Features

- **Zero Configuration Switching**: Both commands work instantly without any file edits
- **Dual Configuration**: Run both `claude` and `zclaude` commands simultaneously
- **Smart Shell Detection**: Automatically detects and configures your shell (bash, zsh, fish, ksh, csh)
- **MCP Server Integration**: Adds Z.AI MCP servers for enhanced functionality
- **Multi-Platform Support**: Works on Linux, macOS, and WSL
- **Safe Installation**: Creates backups of existing configurations
- **Enhanced Models**: Access to glm-4.5-air and glm-4.6 models via Z.AI

## 📋 Prerequisites

- Node.js and npm (for Claude CLI installation)
- Internet connection for downloading packages
- Your Z.AI Coding Plan API token

## 🛠️ Installation

### Quick Start

1. **Download the setup script:**

   ```bash
   curl -O https://raw.githubusercontent.com/dharmapurikar/zclaude/main/setup_zclaude.sh
   chmod +x setup_zclaude.sh
   ```

2. **Run the setup:**

   ```bash
   ./setup_zclaude.sh
   ```

3. **Follow the prompts:**
   - Enter your Z.AI Coding Plan API Token when prompted
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

After installation, you'll have access to both commands without any configuration switching:

![Screenshot](https://github.com/dharmapurikar/zclaude/blob/06b4d9f2c9c5364b6224778fa6195932ce7a9618/images/Screenshot%202025-11-22%20163803.png)

### Use Your Claude Code Pro / Max Subscription

```bash
claude --help
claude "Review this professional document for quality"
claude "Help me with advanced analysis"
```

### Use Z.AI's Coding Plan

```bash
zclaude --help
zclaude "Debug this code"
zclaude "Build this project with web search capabilities"
```

### When to Use Which:

- **`claude`**: Professional tasks, document analysis, when you want to use your Claude Code Pro / Max subscription benefits
- **`zclaude`**: Coding projects, debugging, when you want Z.AI's higher limits and capable models and MCP server capabilities

## 🌟 Z.AI Features

- **Higher Limits**: glm-4.5-air, glm-4.6
- **Web Search**: Via web-search-prime MCP server
- **Web Reading**: Via web-reader MCP server

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
- **Z.AI** for generous limits on awesome models and MCP servers
- The open-source community for shell compatibility solutions

---

**🚀 Enjoy using both Claude Code Pro / Max subscription and Z.AI Coding Plan seamlessly!**

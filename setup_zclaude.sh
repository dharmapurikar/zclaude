#!/bin/bash

# zclaude Setup Script
# This script installs Claude CLI and configures it with Z.AI MCP servers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art Banner
echo -e "\033[38;5;250m"  # Silver/gray color for Z.AI
cat << "EOF"
░█████████        ░███    ░██████                ░██████  ░██                              ░██                 ░██████                    ░██
      ░██        ░██░██     ░██                 ░██   ░██ ░██                              ░██                ░██   ░██                   ░██
     ░██        ░██  ░██    ░██       ░██      ░██        ░██  ░██████   ░██    ░██  ░████████  ░███████     ░██         ░███████   ░████████  ░███████
   ░███        ░█████████   ░██     ░██████    ░██        ░██       ░██  ░██    ░██ ░██    ░██ ░██    ░██    ░██        ░██    ░██ ░██    ░██ ░██    ░██
  ░██          ░██    ░██   ░██       ░██      ░██        ░██  ░███████  ░██    ░██ ░██    ░██ ░█████████    ░██        ░██    ░██ ░██    ░██ ░█████████
 ░██           ░██    ░██   ░██                 ░██   ░██ ░██ ░██   ░██  ░██   ░███ ░██   ░███ ░██            ░██   ░██ ░██    ░██ ░██   ░███ ░██
░█████████ ░██ ░██    ░██ ░██████                ░██████  ░██  ░█████░██  ░█████░██  ░█████░██  ░███████       ░██████   ░███████   ░█████░██  ░███████
EOF
echo -e "\033[0m\033[38;5;208m"  # Orange color for Claude Code
cat << "EOF"
                                    ❤️  Claude Code
EOF
echo -e "\033[0m"

echo -e "\033[38;5;250m\033[1m                    Z.AI ❤️ Claude Code Dual Setup\033[0m"
echo

echo -e "${BLUE}🚀 Welcome to the Z.AI ❤️ Claude Dual Setup Script!${NC}"
echo -e "${YELLOW}This script allows you to run both Claude configurations side-by-side:${NC}"
echo "  1. ✅ Check if Claude CLI is installed (or install it)"
echo "  2. 🔑 Set up your Anthropic Auth Token"
echo "  3. 🐚 Configure your shell with zclaude alias alongside default claude"
echo "  4. 🌐 Add Z.AI MCP servers for enhanced functionality"
echo
echo -e "${CYAN}💡 Result: Seamlessly switch between two Claude environments without changing settings!${NC}"
echo

# Function to print colored status messages
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to detect user's actual default shell
detect_shell() {
    local detected_shell=""

    # Method 1: Check the user's SHELL environment variable (this is the user's default shell)
    if [[ -n "$SHELL" ]]; then
        case "$(basename "$SHELL")" in
            "zsh")
                detected_shell="zsh"
                ;;
            "bash")
                detected_shell="bash"
                ;;
            "fish")
                detected_shell="fish"
                ;;
            "ksh")
                detected_shell="ksh"
                ;;
            "csh"|"tcsh")
                detected_shell="csh"
                ;;
                *)
                detected_shell="unknown"
                ;;
        esac
    fi

    # Method 2: If SHELL variable is not set or unknown, check /etc/passwd for user's shell
    if [[ -z "$detected_shell" || "$detected_shell" == "unknown" ]]; then
        if command -v getent &> /dev/null; then
            local user_shell=$(getent passwd "$(whoami)" 2>/dev/null | cut -d: -f7)
            if [[ -n "$user_shell" ]]; then
                case "$(basename "$user_shell")" in
                    "zsh")
                        detected_shell="zsh"
                        ;;
                    "bash")
                        detected_shell="bash"
                        ;;
                    "fish")
                        detected_shell="fish"
                        ;;
                    "ksh")
                        detected_shell="ksh"
                        ;;
                    "csh"|"tcsh")
                        detected_shell="csh"
                        ;;
                        *)
                        detected_shell="unknown"
                        ;;
                esac
            fi
        fi
    fi

    # Method 3: Check for existing config files as last resort
    if [[ -z "$detected_shell" || "$detected_shell" == "unknown" ]]; then
        if [[ -f "$HOME/.zshrc" ]]; then
            detected_shell="zsh"
        elif [[ -f "$HOME/.bashrc" ]]; then
            detected_shell="bash"
        elif [[ -f "$HOME/.config/fish/config.fish" ]]; then
            detected_shell="fish"
        elif [[ -f "$HOME/.kshrc" ]]; then
            detected_shell="ksh"
        else
            detected_shell="bash"  # Default to bash as most common
        fi
    fi

    echo "$detected_shell"
}

# Function to get rc file path based on shell
get_rc_file() {
    local shell_type=$1
    case $shell_type in
        "zsh")
            echo "$HOME/.zshrc"
            ;;
        "bash")
            # Check for .bash_profile first, then .bashrc
            if [[ -f "$HOME/.bash_profile" ]]; then
                echo "$HOME/.bash_profile"
            elif [[ -f "$HOME/.profile" ]] && [[ ! -f "$HOME/.bashrc" ]]; then
                echo "$HOME/.profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        "fish")
            echo "$HOME/.config/fish/config.fish"
            ;;
        "ksh")
            echo "$HOME/.kshrc"
            ;;
        "csh"|"tcsh")
            echo "$HOME/.cshrc"
            ;;
        *)
            # Fallback to .profile for unknown shells
            echo "$HOME/.profile"
            ;;
    esac
}

# Function to create directory if it doesn't exist (for fish config)
ensure_config_dir() {
    local shell_type=$1
    if [[ "$shell_type" == "fish" ]]; then
        mkdir -p "$HOME/.config/fish"
    fi
}

# Function to remove existing zclaude configuration
remove_existing_zclaude_config() {
    local rc_file=$1
    if [[ -f "$rc_file" ]]; then
        print_status "Removing existing zclaude configuration..."

        # Remove the entire Z.AI Claude configuration block (works for all shells)
        sed -i '/# Z.AI Claude Configuration - Added on/,/# End Z.AI Claude Configuration/d' "$rc_file" 2>/dev/null || true

        # Remove bash/zsh/ksh style function
        sed -i '/^zclaude_env()[[:space:]]*{/,/^}/d' "$rc_file" 2>/dev/null || true

        # Remove fish shell function
        sed -i '/^function zclaude_env$/,/^end$/d' "$rc_file" 2>/dev/null || true

        # Remove csh/tcsh style aliases
        sed -i '/^alias[[:space:]]*zclaude_env[[:space:]]/d' "$rc_file" 2>/dev/null || true
        sed -i '/^alias[[:space:]]*zclaude[[:space:]]/d' "$rc_file" 2>/dev/null || true
        sed -i '/^alias zclaude_env=/d' "$rc_file" 2>/dev/null || true
        sed -i '/^alias zclaude=/d' "$rc_file" 2>/dev/null || true

        # Remove fish style aliases (alias zclaude=zclaude_env)
        sed -i '/^alias[[:space:]]*zclaude[[:space:]]*=zclaude_env/d' "$rc_file" 2>/dev/null || true

        print_success "Existing configuration removed"
    fi
}

# Function to remove existing MCP servers
remove_existing_mcp_servers() {
    print_status "Removing existing Z.AI MCP servers..."

    local servers=("zai-mcp-server" "web-search-prime" "web-reader")

    for server in "${servers[@]}"; do
        if claude mcp list 2>/dev/null | grep -q "$server"; then
            print_status "Removing existing MCP server: $server"
            if claude mcp remove "$server" 2>/dev/null; then
                print_success "✅ Removed $server"
            else
                print_warning "⚠️  Could not remove $server (may not exist)"
            fi
        fi
    done
}

# Function to attempt manual Claude installation
manual_claude_installation() {
    print_warning "npm installation failed. Attempting alternative installation methods..."

    # Check if we have curl/wget for downloading
    if command -v curl &> /dev/null || command -v wget &> /dev/null; then
        print_status "Attempting to download Claude CLI binary..."
        print_status "Please visit https://docs.claude.com for manual installation instructions"
        print_status "After manual installation, please re-run this script"
        echo
        echo -e "${YELLOW}Manual installation steps:${NC}"
        echo "1. Visit: https://docs.claude.com/en/docs/claude-code/installation"
        echo "2. Download the appropriate binary for your system"
        echo "3. Place it in your PATH (e.g., /usr/local/bin/claude)"
        echo "4. Make it executable: chmod +x /path/to/claude"
        echo "5. Re-run this script: ./setup_zclaude.sh"
        echo
        exit 0
    else
        print_error "Neither curl nor wget available. Cannot attempt manual download."
        exit 1
    fi
}

# Step 1: Check if Claude is installed
print_status "Step 1: Checking Claude CLI installation..."

if ! command -v claude &> /dev/null; then
    print_warning "Claude CLI not found in PATH. Installing now..."

    if command -v npm &> /dev/null; then
        print_status "Installing Claude CLI using npm..."
        if npm install -g @anthropic-ai/claude-code; then
            # Verify installation
            if command -v claude &> /dev/null; then
                print_success "Claude CLI installed successfully!"
            else
                print_error "Claude CLI installation completed but command not found in PATH."
                manual_claude_installation
            fi
        else
            print_error "Failed to install Claude CLI via npm."
            manual_claude_installation
        fi
    else
        print_error "npm not found. Cannot attempt automatic installation."
        manual_claude_installation
    fi
else
    print_success "Claude CLI is already installed! ✅"
fi

# Step 2: Get Anthropic Auth Token
print_status "Step 2: Setting up Anthropic Auth Token..."

MAX_ATTEMPTS=3
attempt=1

while [[ $attempt -le $MAX_ATTEMPTS ]]; do
    echo -n -e "${CYAN}Please enter your Anthropic Auth Token (attempt $attempt/$MAX_ATTEMPTS): ${NC}"
    read -r -s ANTHROPIC_TOKEN
    echo

    if [[ -z "$ANTHROPIC_TOKEN" ]]; then
        remaining_attempts=$((MAX_ATTEMPTS - attempt))
        if [[ $remaining_attempts -gt 0 ]]; then
            print_error "Auth token cannot be empty. $remaining_attempts attempts remaining."
        else
            print_error "Auth token cannot be empty. No attempts remaining."
        fi
        ((attempt++))
    else
        print_success "Auth token received! 🔑"
        break
    fi
done

if [[ $attempt -gt $MAX_ATTEMPTS ]]; then
    print_error "Maximum attempts reached. Exiting setup."
    exit 1
fi

# Step 3: Configure shell
print_status "Step 3: Configuring shell with zclaude alias..."

SHELL_TYPE=$(detect_shell)
RC_FILE=$(get_rc_file "$SHELL_TYPE")

print_status "Detected shell: $SHELL_TYPE"
print_status "Configuring file: $RC_FILE"

# Create backup of existing rc file
if [[ -f "$RC_FILE" ]]; then
    BACKUP_FILE="${RC_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$RC_FILE" "$BACKUP_FILE"
    print_status "Created backup: $BACKUP_FILE"

    # Remove existing zclaude configuration
    remove_existing_zclaude_config "$RC_FILE"
fi

# Add zclaude function and alias to rc file based on shell type
add_shell_config() {
    local shell_type=$1
    local rc_file=$2

    case "$shell_type" in
        "bash"|"zsh"|"ksh")
            cat >> "$rc_file" << EOF

# Z.AI Claude Configuration - Added on $(date)
zclaude_env() {
  ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \\
  API_TIMEOUT_MS="3000000" \\
  ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air" \\
  ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.6" \\
  ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.6" \\
  ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_TOKEN" \\
  claude "\$@"
}

alias zclaude="zclaude_env"
# End Z.AI Claude Configuration
EOF
            ;;
        "fish")
            cat >> "$rc_file" << EOF

# Z.AI Claude Configuration - Added on $(date)
function zclaude_env
    set -gx ANTHROPIC_BASE_URL "https://api.z.ai/api/anthropic"
    set -gx API_TIMEOUT_MS "3000000"
    set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL "glm-4.5-air"
    set -gx ANTHROPIC_DEFAULT_SONNET_MODEL "glm-4.6"
    set -gx ANTHROPIC_DEFAULT_OPUS_MODEL "glm-4.6"
    set -gx ANTHROPIC_AUTH_TOKEN "$ANTHROPIC_TOKEN"
    claude \$argv
end

alias zclaude=zclaude_env
# End Z.AI Claude Configuration
EOF
            ;;
        "csh"|"tcsh")
            cat >> "$rc_file" << EOF

# Z.AI Claude Configuration - Added on $(date)
alias zclaude_env 'setenv ANTHROPIC_BASE_URL "https://api.z.ai/api/anthropic"; \
setenv API_TIMEOUT_MS "3000000"; \
setenv ANTHROPIC_DEFAULT_HAIKU_MODEL "glm-4.5-air"; \
setenv ANTHROPIC_DEFAULT_SONNET_MODEL "glm-4.6"; \
setenv ANTHROPIC_DEFAULT_OPUS_MODEL "glm-4.6"; \
setenv ANTHROPIC_AUTH_TOKEN "$ANTHROPIC_TOKEN"; \
claude \!*'

alias zclaude zclaude_env
# End Z.AI Claude Configuration
EOF
            ;;
        *)
            # Generic shell configuration (POSIX compliant)
            cat >> "$rc_file" << EOF

# Z.AI Claude Configuration - Added on $(date)
zclaude_env() {
  ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
  API_TIMEOUT_MS="3000000" \
  ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air" \
  ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.6" \
  ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.6" \
  ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_TOKEN" \
  claude "\$@"
}

alias zclaude="zclaude_env"
# End Z.AI Claude Configuration
EOF
            ;;
    esac
}

# Ensure config directory exists if needed
ensure_config_dir "$SHELL_TYPE"

# Add zclaude configuration to the appropriate rc file
add_shell_config "$SHELL_TYPE" "$RC_FILE"

print_success "Shell configuration added successfully! 🐚"

# Step 4: Add MCP servers
print_status "Step 4: Configuring Z.AI MCP servers..."

# Remove existing MCP servers first
remove_existing_mcp_servers

# Add MCP servers with the user's token
print_status "Adding zai-mcp-server..."
if claude mcp add -s user zai-mcp-server --env Z_AI_API_KEY="$ANTHROPIC_TOKEN" Z_AI_MODE=ZAI -- npx -y "@z_ai/mcp-server"; then
    print_success "✅ zai-mcp-server added successfully"
else
    print_warning "⚠️  Failed to add zai-mcp-server"
fi

print_status "Adding web-search-prime MCP server..."
if claude mcp add -s user -t http web-search-prime "https://api.z.ai/api/mcp/web_search_prime/mcp" --header "Authorization: Bearer $ANTHROPIC_TOKEN"; then
    print_success "✅ web-search-prime added successfully"
else
    print_warning "⚠️  Failed to add web-search-prime MCP server"
fi

print_status "Adding web-reader MCP server..."
if claude mcp add -s user -t http web-reader "https://api.z.ai/api/mcp/web_reader/mcp" --header "Authorization: Bearer $ANTHROPIC_TOKEN"; then
    print_success "✅ web-reader added successfully"
else
    print_warning "⚠️  Failed to add web-reader MCP server"
fi

# Show final MCP server list
print_status "Current MCP servers:"
claude mcp list 2>/dev/null || print_warning "Could not list MCP servers"

# Final instructions
echo
echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
echo
echo -e "${PURPLE}=== NEXT STEPS ===${NC}"
echo -e "${YELLOW}1. Restart your terminal or run the following command to load the new configuration:${NC}"

# Shell-specific source command
case "$SHELL_TYPE" in
    "fish")
        echo -e "${CYAN}   source $RC_FILE${NC}"
        echo -e "${CYAN}   # OR: fish -C \"source $RC_FILE\"${NC}"
        ;;
    "csh"|"tcsh")
        echo -e "${CYAN}   source $RC_FILE${NC}"
        ;;
    *)
        echo -e "${CYAN}   source $RC_FILE${NC}"
        ;;
esac

echo
echo -e "${YELLOW}2. Now you can use the 'zclaude' command:${NC}"
echo -e "${CYAN}   zclaude --help${NC}"
echo -e "${CYAN}   zclaude \"Hello, world!\"${NC}"
echo
echo -e "${YELLOW}3. Check your MCP servers:${NC}"
echo -e "${CYAN}   claude mcp list${NC}"
echo
echo -e "${PURPLE}=== FEATURES ===${NC}"
echo "✨ Enhanced models: glm-4.5-air, glm-4.6"
echo "🔍 Web search capabilities via web-search-prime"
echo "📖 Web page reading via web-reader"
echo "🤖 Z.AI integration for extended functionality"
echo
echo -e "${GREEN}Enjoy using zclaude! 🚀${NC}"
echo
echo -e "${BLUE}If you encounter any issues, please:${NC}"
echo "• Check your internet connection"
echo "• Verify your API token is correct"
echo "• Ensure all dependencies are installed"
echo
echo -e "${CYAN}Documentation: https://docs.claude.com${NC}"
echo -e "${CYAN}Support: https://github.com/anthropics/claude-code/issues${NC}"
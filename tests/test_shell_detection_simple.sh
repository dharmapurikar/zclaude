#!/bin/bash

# Test the shell detection function
echo "=== Testing Shell Detection Function ==="

# Extract the detect_shell function
extract_function() {
    sed -n '/^# Function to detect user/,/^}/p' setup_zclaude.sh
}

# Create a test script with the function
cat > test_function.sh << 'EOF'
#!/bin/bash

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

# Test the function
echo "User SHELL variable: $SHELL"
echo "Detected shell: $(detect_shell)"

# Test different SHELL variables
echo -e "\n--- Testing different SHELL environments ---"

test_shell() {
    local test_shell=$1
    bash -c "SHELL='$test_shell' source test_function.sh && detect_shell"
}

echo "Testing /bin/bash: $(test_shell '/bin/bash')"
echo "Testing /bin/zsh: $(test_shell '/bin/zsh')"
echo "Testing /usr/bin/fish: $(test_shell '/usr/bin/fish')"
echo "Testing /bin/ksh: $(test_shell '/bin/ksh')"
echo "Testing /bin/csh: $(test_shell '/bin/csh')"
EOF

chmod +x test_function.sh
echo "Current environment:"
echo "SHELL=$SHELL"
echo "Detected shell: $(bash test_function.sh)"

# Test different shell environments
echo -e "\n--- Testing different SHELL environments ---"
echo "SHELL=/bin/bash: $(bash -c 'SHELL=/bin/bash source test_function.sh && detect_shell')"
echo "SHELL=/bin/zsh: $(bash -c 'SHELL=/bin/zsh source test_function.sh && detect_shell')"
echo "SHELL=/usr/bin/fish: $(bash -c 'SHELL=/usr/bin/fish source test_function.sh && detect_shell')"

# Cleanup
rm -f test_function.sh

echo -e "\n=== Test completed ==="
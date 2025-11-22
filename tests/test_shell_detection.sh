#!/bin/bash

# Extract the shell detection and configuration functions from the setup script
extract_functions() {
    # Extract just the functions we need to test
    sed -n '/^# Function to detect shell/,/^}/p' setup_zclaude.sh | head -n +100
}

test_shell_detection() {
    echo "Testing shell detection..."
    echo "========================="

    # Test in current bash
    echo "Current shell detection:"
    bash -c 'source setup_zclaude.sh > /dev/null 2>&1; echo "Bash detected as: $(detect_shell)"'

    # Test different shell environments by setting variables
    echo -e "\nTesting different shell environments:"

    # Test ZSH environment
    echo "ZSH environment:"
    bash -c '
        ZSH_VERSION="5.8"
        source setup_zclaude.sh > /dev/null 2>&1
        detect_shell
    '

    # Test Fish environment
    echo "Fish environment:"
    bash -c '
        FISH_VERSION="3.6.1"
        source setup_zclaude.sh > /dev/null 2>&1
        detect_shell
    '

    # Test SHELL variable
    echo "SHELL variable (zsh):"
    bash -c '
        SHELL="/bin/zsh"
        source setup_zclaude.sh > /dev/null 2>&1
        detect_shell
    '

    echo "SHELL variable (fish):"
    bash -c '
        SHELL="/usr/bin/fish"
        source setup_zclaude.sh > /dev/null 2>&1
        detect_shell
    '
}

test_config_file_detection() {
    echo -e "\n\nTesting config file detection..."
    echo "================================="

    shells=("bash" "zsh" "fish" "ksh" "csh" "unknown")

    for shell in "${shells[@]}"; do
        echo "Shell: $shell"
        bash -c "
            shell_type='$shell'
            $(sed -n '/^# Function to get rc file path/,/^}/p' setup_zclaude.sh)
            get_rc_file \"\$shell_type\"
        "
    done
}

test_config_generation() {
    echo -e "\n\nTesting configuration generation..."
    echo "=================================="

    # Create temp directory for test files
    test_dir=$(mktemp -d)
    trap "rm -rf $test_dir" EXIT

    shells=("bash" "zsh" "fish" "csh")

    for shell in "${shells[@]}"; do
        echo -e "\nGenerating config for: $shell"
        config_file="$test_dir/config_$shell"

        case "$shell" in
            "fish")
                config_file="$test_dir/config_fish"
                ;;
            "csh")
                config_file="$test_dir/config_csh"
                ;;
            *)
                config_file="$test_dir/config_$shell"
                ;;
        esac

        # Extract and run the configuration generation function
        bash -c "
            shell_type='$shell'
            rc_file='$config_file'
            ANTHROPIC_TOKEN='test-token-123'

            $(sed -n '/^# Add zclaude function/,/^# End Z.AI Claude Configuration/p' setup_zclaude.sh | sed '1,/add_shell_config/d')

            add_shell_config \"\$shell_type\" \"\$rc_file\"
        "

        echo "Generated config for $shell:"
        cat "$config_file"
        echo "---"
    done
}

# Run tests
echo "Shell Configuration Test Suite"
echo "=============================="

test_shell_detection
test_config_file_detection
test_config_generation

echo -e "\n\nTest completed!"
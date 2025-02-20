#!/bin/bash
# scripts/setup-vscode-env.sh

# Function to detect environment
detect_environment() {
    # Check if running in Codespaces
    if [ -n "$CODESPACES" ]; then
        # Check if mobile browser
        if [ -n "$IS_MOBILE_BROWSER" ]; then
            echo "mobile"
        else
            echo "codespaces"
        fi
    else
        echo "desktop"
    fi
}

# Function to setup VSCode configuration
setup_vscode_config() {
    local env_type=$1
    local vscode_dir=".vscode"
    local example_dir=".vscode.example"

    # Create .vscode directory if it doesn't exist
    mkdir -p "$vscode_dir"

    # Copy appropriate settings file
    case $env_type in
        "mobile")
            cp "$example_dir/mobile.json" "$vscode_dir/settings.json"
            echo "Mobile settings applied"
            ;;
        "codespaces")
            cp "$example_dir/codespaces.json" "$vscode_dir/settings.json"
            echo "Codespaces settings applied"
            ;;
        "desktop")
            cp "$example_dir/desktop.json" "$vscode_dir/settings.json"
            echo "Desktop settings applied"
            ;;
        *)
            echo "Unknown environment type"
            exit 1
            ;;
    esac
}

# Main script execution
main() {
    local env_type=$(detect_environment)
    echo "Detected environment: $env_type"
    setup_vscode_config "$env_type"
}

main "$@"

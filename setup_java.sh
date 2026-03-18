#!/bin/bash
# Install or uninstall asahi-java
# Run from the .dotfiles directory: ./setup_java.sh [uninstall]

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if [ "$1" = "uninstall" ]; then
    echo "Uninstalling asahi-java..."

    # restore default to preinstalled dnf JDK if present
    PREINSTALLED=$(find /usr/lib/jvm -mindepth 1 -maxdepth 1 -type d -name "java-*-openjdk" | sort | head -1)
    if [ -n "$PREINSTALLED" ]; then
        JDK_NAME=$(basename "$PREINSTALLED")
        echo "Restoring default -> $JDK_NAME"
        sudo ln -sfn "$JDK_NAME" /usr/lib/jvm/default
        sudo ln -sfn "$JDK_NAME" /usr/lib/jvm/default-runtime
    else
        sudo rm -f /usr/lib/jvm/default /usr/lib/jvm/default-runtime
    fi

    sudo rm -f /usr/local/bin/asahi-java
    sudo rm -f /etc/profile.d/jvm.sh

    echo "Done. Re-login for environment changes to take effect."
    exit 0
fi

echo "Installing asahi-java..."
sudo cp "$DOTFILES/bin/asahi-java" /usr/local/bin/asahi-java
sudo chmod +x /usr/local/bin/asahi-java

echo "Installing /etc/profile.d/jvm.sh..."
sudo tee /etc/profile.d/jvm.sh > /dev/null <<'EOF'
export JAVA_HOME=/usr/lib/jvm/default
export PATH="$JAVA_HOME/bin:$PATH"
EOF

echo "Detecting installed JVMs..."
sudo asahi-java fix
asahi-java status

echo ""
echo "Done. Re-login or 'source /etc/profile.d/jvm.sh' for changes to take effect."

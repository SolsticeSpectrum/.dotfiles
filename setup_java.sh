#!/bin/bash
# Install asahi-java and set up /etc/profile.d/jvm.sh
# Run from the .dotfiles directory: ./setup_java.sh

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

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

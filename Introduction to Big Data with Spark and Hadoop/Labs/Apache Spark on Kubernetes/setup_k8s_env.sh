#!/usr/bin/env bash
# -------------------------------------------------------------
# setup_k8s_env.sh
#  • Clones (or updates) the fgskh-new_horizons repo
#  • Enters the repo directory
#  • Adds a convenient alias  k = kubectl  (and makes it persistent)
#  • Captures the current K8s namespace in $my_namespace
# -------------------------------------------------------------

set -e  # exit immediately on first error

REPO_URL="https://github.com/ibm-developer-skills-network/fgskh-new_horizons.git"
REPO_DIR="fgskh-new_horizons"

echo "🔍 Checking for existing repository …"
if [ -d "$REPO_DIR/.git" ]; then
  echo "✅ Repo already present – pulling latest changes."
  git -C "$REPO_DIR" pull --quiet
else
  echo "⬇️  Cloning repository …"
  git clone "$REPO_URL"
fi

echo "📂 Changing into project directory: $REPO_DIR"
cd "$REPO_DIR" || { echo "❌ Failed to cd into $REPO_DIR"; exit 1; }

# ------------------------------------------------------------------
# Add alias k='kubectl' for the current shell *and* future sessions
# ------------------------------------------------------------------
add_alias() {
  local RC_FILE
  # Pick a startup file based on the shell
  if [ -n "$ZSH_VERSION" ]; then
    RC_FILE="$HOME/.zshrc"
  else
    RC_FILE="$HOME/.bashrc"
  fi

  # Add alias unless it already exists
  if ! grep -q "alias k='kubectl'" "$RC_FILE" 2>/dev/null; then
    echo "alias k='kubectl'" >> "$RC_FILE"
    echo "✅ Added alias k='kubectl' to $RC_FILE"
  else
    echo "ℹ️  Alias already present in $RC_FILE"
  fi
}

echo "⚙️  Setting alias k='kubectl' for this session …"
alias k='kubectl'
add_alias

# ------------------------------------------------------------------
# Capture current namespace
# ------------------------------------------------------------------
echo "📑 Detecting current Kubernetes namespace …"
my_namespace=$(kubectl config view --minify -o jsonpath='{..namespace}')
if [ -z "$my_namespace" ]; then
  my_namespace="default"
fi
echo "✅ Current namespace stored in \$my_namespace : $my_namespace"

# Export so child processes in this shell can use it
export my_namespace

echo -e "\n🎉  Environment ready.\n"
echo "➡  Next steps: you may now run 'k get pods -n \$my_namespace' or apply your manifests."



# How to use

# # 1. Save the script
# nano setup_k8s_env.sh   # paste content, save & exit

# # 2. Make executable
# chmod +x setup_k8s_env.sh

# # 3. Run
# ./setup_k8s_env.sh

# The script:

# Clones or updates the repository (fgskh-new_horizons).

# Adds the k alias to your current shell and appends it to ~/.bashrc or ~/.zshrc for future sessions.

# Stores the current namespace in my_namespace.

# Echoes friendly status messages so you know what happened.
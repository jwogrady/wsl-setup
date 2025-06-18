#!/bin/bash
set -e

echo "Organizing WSL setup project structure..."

# Create directories if they don't exist
mkdir -p scripts .scripts .ssh

# Move PowerShell scripts to scripts/
for f in *.ps1; do
  if [[ -f "$f" ]]; then
    mv "$f" scripts/
    echo "Moved $f to scripts/"
  fi
done

# Move shell scripts to .scripts/
for f in *.sh; do
  if [[ -f "$f" ]]; then
    mv "$f" .scripts/
    echo "Moved $f to .scripts/"
  fi
done

# Move SSH-related files to .ssh/ (excluding README.md)
for f in id_* *.pub; do
  if [[ -f "$f" ]]; then
    mv "$f" .ssh/
    echo "Moved $f to .ssh/"
  fi
done

# Move SSH README if it exists
if [[ -f ssh-readme.md ]]; then
  mv ssh-readme.md .ssh/README.md
  echo "Moved ssh-readme.md to .ssh/README.md"
fi

echo "WSL setup project structure organized!"
echo "scripts/:        PowerShell scripts"
echo ".scripts/:       Shell (.sh) scripts"
echo ".ssh/:           SSH keys and README"
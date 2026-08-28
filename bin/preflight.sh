#!/bin/bash

source "$HOME/.dotfiles/bin/print.sh"

# Verifies the machine is ready to run fresh.sh. Never installs or modifies anything.
preflight() {
  local dotfiles="$1"
  local passed=0
  local warned=0
  local failed=0

  echo "Preflight checks"
  echo "----------------"

  # macOS version
  local macos_version
  macos_version=$(sw_vers -productVersion 2>/dev/null || echo "0")
  local macos_major=${macos_version%%.*}
  if [ "$macos_major" -ge 12 ] 2>/dev/null; then
    print_status "macOS $macos_version"
    passed=$((passed + 1))
  else
    print_warning "macOS $macos_version is older than the tested minimum (12)"
    warned=$((warned + 1))
  fi

  # CPU architecture
  local arch
  arch=$(uname -m)
  if [ "$arch" = "arm64" ]; then
    print_status "CPU architecture: $arch (Apple Silicon)"
    passed=$((passed + 1))
  else
    print_warning "CPU architecture: $arch — Brewfile and PATH assume Apple Silicon (/opt/homebrew)"
    warned=$((warned + 1))
  fi

  # Required source files present in the repo
  local required_files=(
    "macos/Brewfile"
    "config/ghostty/config"
    "config/topgrade.toml"
    "config/open-webui/compose.yml"
    "config/open-webui/.env.example"
    "config/npmrc"
    "config/yarnrc.yml"
    "config/htop/htoprc"
    "shell/.zshrc"
  )
  local missing_files=()
  local f
  for f in "${required_files[@]}"; do
    if [ ! -e "$dotfiles/$f" ]; then
      missing_files+=("$f")
    fi
  done
  if [ ${#missing_files[@]} -eq 0 ]; then
    print_status "All required source files present"
    passed=$((passed + 1))
  else
    for f in "${missing_files[@]}"; do
      print_error "Missing required file: $f"
    done
    failed=$((failed + 1))
  fi

  # Network connectivity
  if curl -fsS --max-time 5 -o /dev/null https://github.com 2>/dev/null; then
    print_status "Network: github.com reachable"
    passed=$((passed + 1))
  else
    print_warning "Network: github.com not reachable"
    warned=$((warned + 1))
  fi

  if curl -fsS --max-time 5 -o /dev/null https://raw.githubusercontent.com 2>/dev/null; then
    print_status "Network: raw.githubusercontent.com reachable"
    passed=$((passed + 1))
  else
    print_warning "Network: raw.githubusercontent.com not reachable"
    warned=$((warned + 1))
  fi

  # Home directory writable
  if [ -w "$HOME" ]; then
    print_status "\$HOME is writable"
    passed=$((passed + 1))
  else
    print_error "\$HOME is not writable"
    failed=$((failed + 1))
  fi

  # Disk space (5GB minimum)
  local available_kb
  available_kb=$(df -k "$HOME" | awk 'NR==2 {print $4}')
  local available_gb=$((available_kb / 1024 / 1024))
  if [ "$available_gb" -ge 5 ]; then
    print_status "Disk space: ${available_gb}GB free"
    passed=$((passed + 1))
  else
    print_warning "Disk space: only ${available_gb}GB free (recommended >= 5GB)"
    warned=$((warned + 1))
  fi

  echo
  echo "Preflight: $passed passed, $warned warnings, $failed failed"

  [ "$failed" -eq 0 ]
}

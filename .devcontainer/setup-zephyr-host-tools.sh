#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/host-tools-status.log"

APT_PACKAGES=(
  git
  cmake
  ninja-build
  gperf
  ccache
  dfu-util
  device-tree-compiler
  wget
  python3-pip
  python3-setuptools
  python3-wheel
  xz-utils
  file
  make
  gcc
  gcc-multilib
  g++-multilib
  libsdl2-dev
  libmagic1
  openocd
  gcc-arm-none-eabi
  binutils-arm-none-eabi
)

REQUIRED_COMMANDS=(
  west
  cmake
  ninja
  dtc
  gperf
  openocd
  arm-none-eabi-gcc
  python3
)

log_line() {
  printf "%s\n" "$1" | tee -a "${LOG_FILE}"
}

log_header() {
  : > "${LOG_FILE}"
  log_line "Zephyr host-tools setup report"
  log_line "Generated at: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  log_line "Workspace: ${PWD}"
  log_line ""
}

log_command_status() {
  local phase="$1"
  local installed=()
  local missing=()

  for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if command -v "${cmd}" >/dev/null 2>&1; then
      installed+=("${cmd}")
    else
      missing+=("${cmd}")
    fi
  done

  log_line "${phase} command status"
  if ((${#installed[@]} > 0)); then
    log_line "Installed commands: ${installed[*]}"
  else
    log_line "Installed commands: none"
  fi

  if ((${#missing[@]} > 0)); then
    log_line "Missing commands: ${missing[*]}"
  else
    log_line "Missing commands: none"
  fi
  log_line ""
}

log_package_status() {
  local installed=()
  local missing=()

  for pkg in "${APT_PACKAGES[@]}"; do
    if dpkg -s "${pkg}" >/dev/null 2>&1; then
      installed+=("${pkg}")
    else
      missing+=("${pkg}")
    fi
  done

  log_line "APT package status after setup"
  if ((${#installed[@]} > 0)); then
    log_line "Installed packages: ${installed[*]}"
  else
    log_line "Installed packages: none"
  fi

  if ((${#missing[@]} > 0)); then
    log_line "Missing packages: ${missing[*]}"
  else
    log_line "Missing packages: none"
  fi
  log_line ""
}

log_header
log_line "VS Code extension configured in devcontainer: ac6.zephyr-workbench"
log_line ""

log_command_status "Before install"

log_line "Install phase"
log_line "Zephyr host tools are installed during image build from .devcontainer/Dockerfile."
log_line ""

log_command_status "After install"
log_package_status

log_line "Setup complete"
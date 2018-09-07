#!/usr/bin/env bash
#/ Description:
#/  Setup mac osx devops environment
#/ Usage:
#/ Options:
#/ Examples:
#/      DEBUG=true ./install.sh  (Enable debug messages)
#/      NO_COLORS=true ./install.sh (Disable colors)
#/ --------------------------------------------------------------------------------
#/ Author: Rogério Peixoto (rcbpeixoto@gmail.com)
#/ --------------------------------------------------------------------------------
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

ANSIBLE_PLAYBOOK=install-macos-pkg.yml
BASEDIR=$PWD

##################################################################
# SETUP LOGS
##################################################################

DATE=$(date "+%Y%m%dT%H%M%S")

mkdir -p "${BASEDIR}/logs"
LOG_FILE=${LOG_FILE:-"${BASEDIR}/logs/${0}-$DATE.log"}
touch "${LOG_FILE}"

##################################################################
# SOURCING LIB FUNCTIONS
##################################################################

# shellcheck source=utils/colors.sh
source "${BASEDIR}"/utils/colors.sh
# shellcheck source=utils/dependencies.sh
source "${BASEDIR}"/utils/dependencies.sh
# shellcheck source=utils/post-install.sh
source "${BASEDIR}"/utils/post-install.sh

##################################################################
# UTILITY FUNCTIONS
##################################################################

install_xcode_command_line_tools(){
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" --verbose;
} 

install_pip(){
  debug
  sudo easy_install pip
}

install_ansible(){
  debug
  sudo pip install ansible --quiet
}

ansible_playbook_setup_environment(){
  debug
  ansible-playbook $ANSIBLE_PLAYBOOK 
}

is_xcode_cli_tools_installed(){
  debug
  command -v /usr/bin/xcode-select 
}

err_cleanup(){
  debug
  error "An error as happened"
}

exit_cleanup(){
  debug
  info "Cleanup"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  SECONDS=0

  trap 'err_cleanup "$BASH_COMMAND"' ERR
  trap 'exit_cleanup' EXIT

  set -eE
  
  separator
  bump_step "SETUP MAC OSX DEVELOPMENT SCRIPT"
  separator

  bump_step "Install xcode cli tools"
  separator

  if ! is_xcode_cli_tools_installed; then
    install_xcode_command_line_tools
  fi

  bump_step "Install pip"
  separator

  install_pip

  separator
  bump_step "Install ansible"
  separator

  install_ansible

  separator
  bump_step "Running playbook"
  separator

  ansible_playbook_setup_environment

  separator
  bump_step "Configuring"
  separator

  config_iterm_scroll_with_mouse
fi

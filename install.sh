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

# import colorize and verbose utility functions
# shellcheck source=utils/colors.sh
source "${BASEDIR}"/utils/colors.sh
# import dependencies check functions
# shellcheck source=utils/dependencies.sh
source "${BASEDIR}"/utils/dependencies.sh
# import pre-installation step's funcions
# shellcheck source=utils/pre-install.sh
source "${BASEDIR}"/utils/pre-install.sh
# import post-installation step's funcions
# shellcheck source=utils/post-install.sh
source "${BASEDIR}"/utils/post-install.sh


##################################################################
# UTILITY FUNCTIONS
##################################################################

err_cleanup(){
  debug
  error "An error as happened"
}

exit_cleanup(){
  debug
  info "Cleanup"
}

##################################################################
# UTILITY FUNCTIONS
##################################################################

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  SECONDS=0

  trap 'err_cleanup "$BASH_COMMAND"' ERR
  trap 'exit_cleanup' EXIT

  set -eE
  
  if is_no_colors; then
    unset_colors
  else
    set_colors
  fi
  
  separator
  bump_step "SETUP MAC OSX DEVELOPMENT SCRIPT"
  separator

  info
  info

  separator
  bump_step "Running pre-install steps"
  separator

  bump_step "Install xcode cli tools"
  separator
  if ! is_xcode_cli_tools_installed; then
    install_xcode_command_line_tools
  else
    info "xcode cli tools already installed"
  fi

  bump_step "Install pip"
  separator
  install_pip

  bump_step "Install ansible"
  separator
  install_ansible

  info "Pre-install steps execution finished"
  info
  
  separator
  bump_step "Running brew ansible playbook"
  separator
  ansible_playbook_setup_environment

  info "Playbook execution finished"
  info

  separator
  bump_step "Post install configuration"
  separator

  change_docker_machine_driver_permission
  config_iterm_scroll_with_mouse
  install_openshift_zsh_plugin
  create_minishift_zsh_completion
  link_dotfiles_to_home

fi

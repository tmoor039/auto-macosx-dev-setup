#!/bin/bash
# shellcheck disable=SC1117

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

is_pip_installed(){
  debug
  command -v /usr/local/bin/pip
}

install_ansible(){
  debug
  sudo pip install ansible --quiet
}

is_ansible_installed(){
  debug
  command -v /usr/local/bin/ansible
}

ansible_playbook_setup_environment(){
  debug
  ansible-playbook "$ANSIBLE_PLAYBOOK" -vv 
}

is_xcode_cli_tools_installed(){
  debug
  command -v /usr/bin/xcode-select 
}

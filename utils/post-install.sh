#!/bin/bash
config_iterm_scroll_with_mouse(){
  debug
  info "enabling scrolling with mouse on man pages and less"
  defaults write com.googlecode.iterm2 AlternateMouseScroll -bool true
}

change_docker_machine_driver_permission(){
  debug
  info "Adding docker-machine-driver-xhyve to whell group"
  sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

  info "Setting owner user id for the binary"
  sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

  info "Displaying settings for docker-machine-driver-xhyve"
  brew info --installed docker-machine-driver-xhyve
}

install_openshift_zsh_plugin(){
  debug
  info "Installing openshift zsh plugin"
  git clone https://github.com/chmouel/oh-my-zsh-openshift ~/.oh-my-zsh/custom/plugins/oc
}


#!/bin/bash
PATHOGEN="~/.vim/autoload/pathogen.vim"

# https://coderwall.com/p/ctp4rw/programatically-install-vim-bundles

# First make sure pathogen isn't present
if [ ! -f "$(eval echo ${PATHOGEN})" ]; then
  echo "pathogen not found at ${PATHOGEN}"
  mkdir -pv ~/.vim/autoload ~/.vim/bundle
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
else
  echo "pathogen found at ${PATHOGEN}"
fi

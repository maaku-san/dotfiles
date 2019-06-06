#!/bin/bash

function terraform-install() {
  
  if [[ ! -x "$(command -v unzip)" ]]; then
    echo 'Error: unzip is not installed.' >&2
    exit 1
  fi

  [[ -f ${HOME}/bin/terraform ]] \
    && echo "$(${HOME}/bin/terraform version) already installed at ${HOME}/bin/terraform" \
    && return 0
  
  echo "installing terraform"

  #LATEST_URL=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'alpha|rc|beta' | egrep 'linux.*amd64' |tail -1)
  LATEST_URL=$(curl -sL https://releases.hashicorp.com/terraform/index.json \
    | ~/bin/jq '.versions[] 
      | .builds[] 
      | select((.os == "linux") and (.arch == "amd64") and (.version | contains("alpha") | not ) and  (.version | contains("beta") | not) and (.version | contains("rc") | not)) 
      | .version + " " + .url' -r  \
    | sort -t. -k 1,1n -k 2,2n -k 3,3n \
    | tail -n 1)


  curl -sS -L "${LATEST_URL##* }" -o /tmp/terraform.zip
  
  mkdir -p ${HOME}/bin
  
  (cd ${HOME}/bin && unzip -qq /tmp/terraform.zip)
  
  echo "Installed: $(${HOME}/bin/terraform version)"
  
}

function packer-install() {
  
  if [[ ! -x "$(command -v unzip)" ]]; then
    echo 'Error: unzip is not installed.' >&2
    exit 1
  fi

  [[ -f ${HOME}/bin/packer ]] \
    && echo "$(${HOME}/bin/packer version) already installed at ${HOME}/bin/packer" \
    && return 0

  echo "installing packer"

  #LATEST_URL=$(curl -sL https://releases.hashicorp.com/packer/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n | egrep -v 'rc|beta' | egrep 'linux.*amd64' |tail -1)
 
  LATEST_URL=$(curl -sL https://releases.hashicorp.com/packer/index.json \
    | ~/bin/jq '.versions[] | .builds[] | select((.os == "linux") and (.arch == "amd64")) | .version + " " + .url' -r \
    | sort -nk 1 \
    | tail -n 1)

  curl -sS -L "${LATEST_URL##* }" -o /tmp/packer.zip
  
  mkdir -p ${HOME}/bin
  
  (cd ${HOME}/bin && unzip -qq /tmp/packer.zip)
  
  echo "Installed: $(${HOME}/bin/packer version)"
}

function jq-install() {
  
  [[ -f ${HOME}/bin/jq ]] \
    && echo "$(${HOME}/bin/jq --version) already installed at ${HOME}/bin/jq" \
    && return 0

  echo "installing jq"

  LATEST_URL=$(curl -sL https://api.github.com/repos/stedolan/jq/releases/latest | jq -r '.assets[].browser_download_url' | grep 'jq-linux64')
  
  mkdir -p ${HOME}/bin
  curl -sS -L "${LATEST_URL}" -o ~/bin/jq
  chmod u+x ~/bin/jq
  echo "Installed: $(${HOME}/bin/jq --version)"

}

jq-install
terraform-install
packer-install

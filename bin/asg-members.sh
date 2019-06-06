#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="$(basename "$0")"
__base="${__file%%.*}"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# echo "__dir: ${__dir}"
# echo "__file: ${__file}"
# echo "__base: ${__base}"
# echo "__root: ${__root}"

arg1="${1:-}"


cprint() {
    # generate colored output messages
    # example: cprint <LEVEL> <MESSAGE>
    LEVEL=${1}
    MESSAGE=${2}
    case $LEVEL in
        OK)      echo -e "\033[0;32m${MESSAGE}\033[0m" ;;  # green
        OKALT)   echo -e "\033[0;35m${MESSAGE}\033[0m" ;;  # magenta
        INFO)    echo -e "\033[0;36m${MESSAGE}\033[0m" ;;  # cyan
        WARN)    echo -e "\033[0;33m${MESSAGE}\033[0m" ;;  # yellow
        ERR)     echo -e "\033[0;31m${MESSAGE}\033[0m" ;;  # red
        SUCCESS) echo -e "\033[0;32m${MESSAGE}\033[0m" ;;  # green
        FAIL)    echo -e "\033[0;31m${MESSAGE}\033[0m" ;;  # red
        *)       echo -e "${MESSAGE}" ;;  # everything else
    esac
}

ASG_NAME="${1}"
AWS_PROFILE="${2}"

get_asg_instance_ids() {
    RESULT=($(aws \
        autoscaling \
        describe-auto-scaling-groups \
        --auto-scaling-group-names ${ASG_NAME} \
        --profile ${AWS_PROFILE} \
        | jq -r '.AutoScalingGroups[].Instances[] | .InstanceId'))
    echo "${RESULT[@]}"
}

get_instance_ips() {
    RESULT=($(aws ec2 describe-instances \
        --instance-ids ${instances[@]} \
        --profile ${AWS_PROFILE} \
        | jq -r '.Reservations[].Instances[].PrivateIpAddress'))
    echo "${RESULT[@]}"

}

instances=$(get_asg_instance_ids)
instance_ips=$(get_instance_ips)

for IP in ${instance_ips[@]}; do
    printf "%s\n" ${IP}
done
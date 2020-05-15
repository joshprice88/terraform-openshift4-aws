#!/bin/bash

function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_dependencies() {
  test -f $(which aws) || error_exit "ssh-keygen command not detected in path, please install it"
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
}

function parse_input() {
  eval "$(jq -r '@sh "export ASG_A_NAME=\(.asg_a_name) ASG_B_NAME=\(.asg_b_name) ASG_C_NAME=\(.asg_c_name)"')"
}

function get_instance_ips() {
  ASG_A_IP=$(aws ec2 describe-instances --instance-ids $(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$ASG_A_NAME" --output text --query "AutoScalingGroups[0].Instances[*].InstanceId" --region us-west-2) --output text --query "Reservations[*].Instances[*].PrivateIpAddress" --region us-west-2)
  ASG_B_IP=$(aws ec2 describe-instances --instance-ids $(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$ASG_B_NAME" --output text --query "AutoScalingGroups[0].Instances[*].InstanceId" --region us-west-2) --output text --query "Reservations[*].Instances[*].PrivateIpAddress" --region us-west-2)
  ASG_C_IP=$(aws ec2 describe-instances --instance-ids $(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$ASG_C_NAME" --output text --query "AutoScalingGroups[0].Instances[*].InstanceId" --region us-west-2) --output text --query "Reservations[*].Instances[*].PrivateIpAddress" --region us-west-2)
}

function produce_output() {
  jq -n --arg asg_a "$ASG_A_IP" --arg asg_b "$ASG_B_IP" --arg asg_c "$ASG_C_IP" '{"asg_a":$asg_a,"asg_b":$asg_b,"asg_c":$asg_c}'
}

check_dependencies
parse_input
get_instance_ips
produce_output
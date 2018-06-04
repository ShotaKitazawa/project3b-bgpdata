#!/bin/bash
# Author: ShotaKitazawa

SUB_COMMAND=${1:-"create/delete"}
SCRIPT_DIR=$(cd $(dirname $0) && pwd)

if [ "$SUB_COMMAND" = "create" ]; then
  cd $SCRIPT_DIR/network
  for i in *; do
    openstack stack create -t $SCRIPT_DIR/hot-network.yaml --parameter "network-name=$i" --parameter-file "cidr=$SCRIPT_DIR/network/$i" as-$i
  done
  openstack stack create -t $SCRIPT_DIR/hot-instances.yaml instances
elif [ "$SUB_COMMAND" = "delete" ]; then
  openstack stack delete instances -y
  echo "delete instances"
  cd $SCRIPT_DIR/network
  for i in *; do
    openstack stack delete as-$i -y
    echo "delete as-$i network"
  done
fi

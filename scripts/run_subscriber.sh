#!/bin/bash

set -e 

source /opt/ros/foxy/setup.bash && \
source ./install/setup.bash && \
ros2 run cpp_pubsub listener 
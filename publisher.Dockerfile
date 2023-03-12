FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]


RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository universe
RUN apt update && apt install -y curl
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" |  tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update
RUN apt install -y ros-foxy-ros-base python3-argcomplete
RUN apt install -y ros-dev-tools

WORKDIR /ros2_ws
RUN mkdir src
RUN rosdep init && rosdep update
RUN rosdep install -i --from-path src --rosdistro foxy -y

WORKDIR /ros2_ws/src/cpp_pubsub/src
COPY ./src .

WORKDIR /ros2_ws/src/cpp_pubsub
COPY CMakeLists.txt .
COPY package.xml .

WORKDIR /ros2_ws
RUN rosdep install -i --from-path src --rosdistro foxy -y
RUN source /opt/ros/foxy/setup.bash && colcon build --packages-select cpp_pubsub

COPY ./scripts/run_publisher.sh .
COPY ./scripts/source_ros2_env.sh .


CMD ["./run_publisher.sh"]

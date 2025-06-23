# Full Guide on Visual Odometry & SLAM for mobile robotics

**Author**by SANTHOSH M

**ID**URK23RA3005

# 1) Installation of Docker engine on linux (Ubuntu)

Refer the below link for the docker engine installation although i am mentioning the cmds for installation.

[Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

## To install docker engine

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

## To check the docker version and checking if its working

```bash
docker version 
docker run hello-world # or sudo docker run hello-world
```

# 2) Building the image

## i) Create a file called “Dockerfile” and paste the below in the file.

```dockerfile
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Add repo for libjasper (needed by OpenCV)
RUN echo "deb http://security.ubuntu.com/ubuntu xenial-security main" >> /etc/apt/sources.list

# Install essential tools and libraries
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    nano \
    python3-pip \
    git \
    unzip \
    wget \
    pkg-config \
    libgtk2.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libdc1394-22-dev \
    libjasper-dev \
    libglew-dev \
    libboost-all-dev=1.71.* \
    libssl-dev \
    libeigen3-dev \
    python3-dev \
    python3-numpy python3-matplotlib \
    libx11-dev \
    x11-apps \
    xauth \
    x11-utils \
    xterm \
    dbus-x11 \
    && apt-get clean

WORKDIR /root/Dev

# Install OpenCV 4.5.5
RUN git clone https://github.com/opencv/opencv.git && \
    git clone https://github.com/opencv/opencv_contrib.git && \
    cd opencv && \
    git checkout 4.5.5 && \
    cd ../opencv_contrib && \
    git checkout 4.5.5 && \
    cd ../opencv && \
    mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=Release \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
          -D WITH_CUDA=OFF \
          -D BUILD_EXAMPLES=OFF .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# Install Pangolin
RUN cd /root/Dev && \
    git clone https://github.com/stevenlovegrove/Pangolin.git && \
    cd Pangolin && \
    git checkout 86eb4975fc4fc8b5d92148c2e370045ae9bf9f5d && \
    mkdir build && cd build && \
    cmake .. -D CMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install

# Install ORB-SLAM3
RUN cd /root/Dev && \
    git clone https://github.com/MSanthosh08/ORB_SLAM3.git && \
    cd ORB_SLAM3 && \
    sed -i 's/-std=c++17/-std=c++14/g' build.sh && \
    sed -i 's|Eigen::aligned_allocator<std::pair<const KeyFrame\*, g2o::Sim3> > > KeyFrameAndPose;|Eigen::aligned_allocator<std::pair<KeyFrame \*const, g2o::Sim3> > > KeyFrameAndPose;|' include/LoopClosing.h && \
    chmod +x build.sh && \
    ./build.sh || ./build.sh || ./build.sh

CMD ["/bin/bash"]
```

## ii) Go to the file path and run the following command to build the image

```bash
docker build -t orbslam3:v1 -f Dockerfile .
```

You will see output like the example shown...

## iii) Run container for checking/demo

```bash
xhost +local:
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -e XAUTHORITY=$XAUTHORITY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $XAUTHORITY:$XAUTHORITY \
  -v $HOME/Datasets:/root/Datasets:rw \
  --privileged \
  orbslam3:v1
```

## iv) Run persistent container for project use

```bash
xhost +local:
docker run -it \
  -e DISPLAY=$DISPLAY \
  -e XAUTHORITY=$XAUTHORITY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $XAUTHORITY:$XAUTHORITY \
  -v $HOME/Datasets:/root/Datasets:rw \
  --privileged \
  orbslam3:v1
```

## v) Check X11 Display

```bash
xeyes
```

# 3) Download test datasets in your host machine

## i) EuRoC MH01 and VH02

```bash
cd ~
mkdir -p Datasets/EuRoC
cd Datasets/EuRoC/
wget -c http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/machine_hall/MH_01_easy/MH_01_easy.zip
wget -c http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/vicon_room1/V1_02_medium/V1_02_medium.zip
mkdir MH01
mkdir V102
unzip MH_01_easy.zip -d MH01/
unzip V1_02_medium.zip -d V102/
```

## ii) TUM RGB-D

```bash
cd ~
mkdir -p Datasets/TUM_RGB-D
cd Datasets/TUM_RGB-D/
wget -c https://cvg.cit.tum.de/rgbd/dataset/freiburg3/rgbd_dataset_freiburg3_structure_texture_far.tgz
wget -c https://cvg.cit.tum.de/rgbd/dataset/freiburg3/rgbd_dataset_freiburg3_long_office_household_validation.tgz
mkdir fr3-s-t
mkdir fr3-o-s
unzip rgbd_dataset_freiburg3_structure_texture_far.tgz -d fr3-s-t/
unzip rgbd_dataset_freiburg3_long_office_household_validation.tgz -d fr3-o-s/
```

**Note:** Make sure datasets are downloaded to the correct path:

```bash
-v $HOME/Datasets:/root/Datasets:rw
```

# 4) Run Simulation

## i) EuRoC

```bash
cd ~/Dev/ORB_SLAM3
chmod +x euroc_examples.sh
./euroc_examples.sh
```

## ii) TUM RGB-D

```bash
cd ~/Dev/ORB_SLAM3
chmod +x RGB-D_examples.sh
./RGB-D_examples.sh
```

# 5) Validation: Estimate vs Ground Truth

## i) EuRoC

```bash
cd ~/Dev/ORB_SLAM3
chmod +x euroc_eval_examples.sh
./euroc_eval_examples.sh
```

Check: `MH01_stereoi.pdf`, `V102_stereoi.pdf`

## ii) TUM RGB-D

```bash
cd ~/Dev/ORB_SLAM3
chmod +x RGB-D_eval_examples.sh
./RGB-D_eval_examples.sh
```
check: `fr3_office_ate.pdf`,`fr3_strtex_ate.pdf`

Reference: [Mauhing -- ORB_SLAM3](https://github.com/Mauhing/ORB_SLAM3/tree/master)

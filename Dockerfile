FROM ubuntu:20.04
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bk
RUN cat /etc/apt/sources.list.bk | sed -e 's/archive.ubuntu.com/mirrors.aliyun.com/g' | sed -e 's/security.ubuntu/mirrors.aliyun/g' > /etc/apt/sources.list
RUN rm /etc/apt/sources.list.bk
RUN apt update && apt install git g++ gcc vim -y
RUN DEBIAN_FRONTEND=noninteractive TZ="Asia/Shanghai" apt-get -y install tzdata
RUN apt install -y build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev libopenexr-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
WORKDIR /src
#RUN git clone https://github.com/opencv/opencv.git  && git clone https://github.com/opencv/opencv_contrib.git
ADD opencv-4.5.5.tar.gz /src
ADD opencv_contrib-4.5.5.tar.gz /src
#RUN cd /src/opencv && git checkout tags/4.5.5 -b 4.5.5
#RUN cd /src/opencv_contrib && git checkout tags/4.5.5 -b 4.5.5
RUN mkdir -p /src/opencv/build
WORKDIR /src/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_EXTRA_MODULES_PATH=/src/opencv_contrib/modules -D BUILD_EXAMPLES=ON ..
RUN make -j8

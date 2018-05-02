FROM ubuntu:16.04
MAINTAINER glw <https://github.com/glw/docker-python3-opencv>

# Thanks to Josip Janzic <josip.janzic@gmail.com> for Opencv installation Dockerfile

RUN apt-get update && apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update && \
        apt-get install -y \
        build-essential \
        cmake \
        g++ \
	python3 \
	python3-dev \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libavformat-dev \
        libpq-dev \
        exiv2 \
        libexiv2-dev \
        libboost-python1.58.0 \
        libboost-python-dev \
        python-all-dev \
	gdal-bin=2.1.3+dfsg-1~xenial2 \
	libgdal-dev=2.1.3+dfsg-1~xenial2 \
	python3-gdal=2.1.3+dfsg-1~xenial2 \
	&& \

	wget https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py && \
	rm get-pip.py \
	&& \

        pip --no-cache-dir install \
        numpy \
        py3exiv2

WORKDIR /
ENV OPENCV_VERSION="3.4.1"
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip \
&& mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
&& cd /opencv-${OPENCV_VERSION}/cmake_binary \
&& cmake -DBUILD_TIFF=ON \
  -DBUILD_opencv_java=OFF \
  -DWITH_CUDA=OFF \
  -DENABLE_AVX=ON \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=$(python3.5 -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=$(which python3.5) \
  -DPYTHON_INCLUDE_DIR=$(python3.5 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python3.5 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. \
&& make install \
&& rm /${OPENCV_VERSION}.zip \
&& rm -r /opencv-${OPENCV_VERSION}


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Externally accessible data is by default put in /data
WORKDIR /data

# dont really need COPY command since the volume command puts it in your containers directory
#copy relevant files for converting tif image to jpg and NDVI calculation
#COPY NDVI-calc.sh tiff_2_jpg_convert.py write_colormap_file.py /data/

CMD ["/bin/bash"]
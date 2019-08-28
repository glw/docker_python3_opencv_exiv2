FROM alpine:3.7

MAINTAINER glw <https://github.com/glw/docker-python3-opencv>

# Thanks to Josip Janzic <josip.janzic@gmail.com> for Opencv installation
# and Cayetano Benavent <cayetano.benavent@geographica.gs> for the GDAL installation


ENV ROOTDIR /usr/local/
ENV OPENCV_VERSION="3.4.1"
ENV GDAL_VERSION="2.2.4"
ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++

# RUN apk update && apk upgrade
RUN apk add --no-cache \
        build-base \
 	python3 \
	python3-dev \
        git \
        openblas-dev \
        unzip \
        wget \
        cmake \
        gcc \
        # libtbb@testing  \
        # libtbb-dev@testing \
        libjpeg  \
        libjpeg-turbo-dev \
        libpng-dev \
        jasper-dev \
        tiff-dev \
        libwebp-dev \
        clang-dev \
        linux-headers \
        exiv2 \
        exiv2-dev \
        boost-python3 \
        boost-dev \
        #python-all-dev \
        py-pip

WORKDIR $ROOTDIR/


# install gdal 2.2.4
WORKDIR /$ROOTDIR/src
ADD http://download.osgeo.org/gdal/2.2.4/gdal-${GDAL_VERSION}.tar.xz /$ROOTDIR/src
RUN tar -xf gdal-${GDAL_VERSION}.tar.xz \
           && cd gdal-${GDAL_VERSION} \
           && ./configure --with-python --with-geos --with-geotiff --with-jpeg \
           && make && make install \
           # && ldconfig \
           # && apt-get update -y \
           # && apt-get remove -y --purge build-essential \
           #&& cd $ROOTDIR && cd src/gdal-${GDAL_VERSION}/swig/python \
           #&& python3 setup.py build \
           #&& python3 setup.py install \
           && cd $ROOTDIR && rm -Rf src/gdal*

# pip
RUN pip install \
           numpy \
           py3exiv2 \
	   GDAL==${GDAL_VERSION}


# install opencv
WORKDIR /$ROOTDIR/src
ADD https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz /$ROOTDIR/src
RUN tar -xzf ${OPENCV_VERSION}.tar.gz \
           && cd opencv-${OPENCV_VERSION} \
           && mkdir cmake_binary \
           && cd cmake_binary \
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
          && cd $ROOTDIR/src \
          && rm ${OPENCV_VERSION}.tar.gz \
          && rm -rf opencv-${OPENCV_VERSION}/


# Clean up APK when done.
 RUN rm -rf /tmp/* && \
     rm -rf /var/cache/apk/*


# set python3 as default python
# RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 \
#  && update-alternatives --install /usr/bin/python python /usr/bin/python3.5 2

# Externally accessible data is by default put in /data
WORKDIR /data

RUN wget https://raw.githubusercontent.com/glw/docker_python3_opencv_exiv2/master/NDVI-calc.sh \
 && wget https://raw.githubusercontent.com/glw/docker_python3_opencv_exiv2/master/tiff_2_jpg_convert.py \
 && wget https://raw.githubusercontent.com/glw/docker_python3_opencv_exiv2/master/write_colormap_file.py

CMD ["/bin/bash"]

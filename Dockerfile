FROM bistromath/uhd:4.0.0

ENV gr_ver v3.9.0.0
ENV volk_ver v2.4.1
ENV gr_cmake_options -DCMAKE_INSTALL_PREFIX=/usr/lib
ENV num_threads 4

MAINTAINER bistromath@gmail.com version: 0.6

#i could just do apt-get install gnuradio
#but then it'd use the older UHD, and part of the
#reason to do this is to get latest releases.
#no offense to maitland.
RUN apt-get install -y libboost-dev libfftw3-3 libfftw3-dev \
    libgsl-dev libasound2-dev python3-numpy python3-lxml \
    python3-cairo-dev libgmp10 libgmp-dev libsndfile1-dev \
    libsndfile1 python3-click python3-click-plugins python3-pyqt5.qwt \
    libqwt-qt5-6 libqwt-qt5-dev python3-pyqt5 python3-gi-cairo \
    libpangocairo-1.0-0 python3-yaml python3-cairo gir1.2-pango-1.0 \
    qtbase5-dev gir1.2-gtk-3.0 python3-pygccxml \
    liblog4cpp5-dev libzmq3-dev python3-zmq python3-pybind11

WORKDIR /opt
RUN git clone https://github.com/gnuradio/volk.git
WORKDIR /opt/volk
RUN git checkout ${volk_ver}
RUN git submodule update --init
RUN mkdir build && cd build && cmake ../ && make -j${num_threads} && make install && ldconfig

WORKDIR /opt
RUN git clone https://github.com/gnuradio/gnuradio.git
WORKDIR /opt/gnuradio
RUN git checkout ${gr_ver}
RUN mkdir build && cd build && cmake ${gr_cmake_options} ../ && make -j${num_threads} && make install && ldconfig

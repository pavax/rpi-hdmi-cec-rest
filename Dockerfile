FROM balenalib/raspberrypi3-debian:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential golang-go git cmake \
	libudev-dev libraspberrypi-dev pkg-config

# build libcec
RUN git clone https://github.com/Pulse-Eight/libcec.git /root/libcec && \
    cd /root/libcec && \
    git submodule update --init && \
    cd /root/libcec/src/platform && \
    mkdir build && cd build && cmake .. && make -j4 && make install && \
    cd /root/libcec && \
    mkdir build && cd build && cmake cmake -DRPI_INCLUDE_DIR=/opt/vc/include -DRPI_LIB_DIR=/opt/vc/lib .. && make -j4 && make install && sudo ldconfig && \
    rm -rf /root/libcec

# hdmi-cec-rest
ENV GOPATH=/go
RUN mkdir /go
RUN go get github.com/pavax/hdmi-cec-rest

# cleanup
RUN apt-get purge -y \
    libudev-dev cmake build-essential libraspberrypi-dev git && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/go/bin/hdmi-cec-rest"]

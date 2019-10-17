FROM balenalib/raspberrypi3-debian:latest

RUN apt-get update && apt-get install -y \
	build-essential golang-go git cmake \
	libudev-dev libraspberrypi-dev pkg-config

# build libcec
RUN git clone https://github.com/Pulse-Eight/libcec.git /root/libcec
WORKDIR /root/libcec
RUN git submodule update --init
WORKDIR /root/libcec/src/platform
RUN mkdir build && cd build && cmake .. && make -j4 && make install
WORKDIR /root/libcec
run mkdir build && cd build && cmake cmake -DRPI_INCLUDE_DIR=/opt/vc/include -DRPI_LIB_DIR=/opt/vc/lib .. && make -j4 && make install && sudo ldconfig

# hdmi-cec-rest
ENV GOPATH=/go
RUN mkdir /go
RUN go get github.com/pavax/hdmi-cec-rest

# cleanup
RUN apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/libcec/

CMD ["/go/bin/hdmi-cec-rest"]

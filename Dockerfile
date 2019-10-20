FROM balenalib/raspberrypi3-debian:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
	golang-go git \
	libcec-dev libp8-platform-dev cec-utils make pkg-config

# hdmi-cec-rest
ENV GOPATH=/go
RUN mkdir /go
RUN go get github.com/pavax/hdmi-cec-rest

# cleanup
RUN apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/go/bin/hdmi-cec-rest"]

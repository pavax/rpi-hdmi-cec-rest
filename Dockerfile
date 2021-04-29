FROM balenalib/raspberry-pi-debian-golang

RUN apt-get update && apt-get install --no-install-recommends -y \
	libcec-dev libp8-platform-dev cec-utils make pkg-config

# hdmi-cec-rest
WORKDIR /go
RUN go get github.com/pavax/hdmi-cec-rest

# cleanup
RUN apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/go/bin/hdmi-cec-rest"]

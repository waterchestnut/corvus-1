FROM golang:latest
MAINTAINER waterchestnut "https://github.com/waterchestnut"

RUN apt-get update && apt-get install -y autoconf && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*

# Copy the local package files to the container's workspace.
ADD . /go/src/corvus

# change workdir, build and install
WORKDIR /go/src/corvus
RUN git submodule update --init
RUN make deps
RUN make
RUN cp /go/src/corvus/src/corvus /go/bin/
RUN rm -rf /go/src/*

WORKDIR /go/bin

# Run the frontd command by default when the container starts.
ENTRYPOINT ["/go/bin/corvus","/usr/local/etc/corvus/corvus.conf"]

EXPOSE 6380

VOLUME "/usr/local/etc/corvus"

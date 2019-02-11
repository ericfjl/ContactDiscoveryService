FROM debian:stretch

RUN apt-get update && apt-get install -V -y gnupg2 devscripts

COPY docker/apt.conf docker/sources.list /etc/apt/
COPY docker/ docker/
RUN apt-get update && \
    apt-get install -V -y --allow-downgrades $(cat docker/build-deps) \
                    build-essential ca-certificates curl git cmake ninja-build \
                    devscripts debhelper fakeroot \
                    ocaml-native-compilers automake autoconf libtool wget python pkg-config \
                    libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev \
                    openjdk-8-jdk-headless

WORKDIR /home/signal
RUN chmod a+rwx /home/signal

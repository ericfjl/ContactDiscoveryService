FROM debian:buster

RUN apt-get update && apt-get install -V -y gnupg2 devscripts

COPY docker/apt.conf docker/sources.list /etc/apt/
COPY docker/ docker/
RUN apt-get update && \
    apt-get install -V -y --allow-downgrades \
                    ocaml-native-compilers ocamlbuild clang-7 gcc-7 g++-7 \
                    libssl-dev protobuf-compiler libprotobuf-dev \
                    openjdk-8-jdk-headless

WORKDIR /home/signal
RUN chmod a+rwx /home/signal

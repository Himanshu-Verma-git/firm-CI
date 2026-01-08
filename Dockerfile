FROM ubuntu:latest

WORKDIR /demo

RUN apt-get update
RUN apt-get install -y \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    libnewlib-arm-none-eabi \
    cmake \
    make \
    python3 \
    build-essential \
    git

RUN 


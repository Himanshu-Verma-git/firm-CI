FROM ubuntu:latest

WORKDIR /work

# RUN apt-get update && apt-get install -y \
#     binutils-arm-none-eabi \
#     libnewlib-arm-none-eabi \

RUN apt-get update && apt-get install -y \
    git cmake make ninja-build \
    gcc-arm-none-eabi \
    build-essential \
    python3

# ENV PICO_SDK_PATH=/work/pico-sdk
RUN echo "Made it yoo!!"
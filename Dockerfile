# x11docker with Ubuntu MATE
# 
# Run Ubuntu MATE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: docker build . -t ubuntu-mate
#           x11docker --desktop ubuntu-mate
#           x11docker ubuntu-mate caja
#
# Options:
# Persistent home folder stored on host with   --home
# Shared host file or folder with              --share PATH
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# ALSA sound support with option               --alsa
# Pulseaudio sound support with option         --pulseaudio
# Language setting with                        --lang [=$LANG]
# Printing over CUPS with                      --printer
# Webcam support with                          --webcam
#
# See x11docker --help for further options.

FROM ubuntu:focal

ADD sources.list /etc/apt/

ENV SHELL=/bin/bash

RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      dbus-x11 \
      procps \
      psmisc && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      xdg-utils \
      xdg-user-dirs \
      menu-xdg \
      mime-support \
      desktop-file-utils \
      bash-completion && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      mesa-utils-extra \
      libxv1 \
      sudo

# Language/locale settings
#   replace en_US by your desired locale setting, 
#   for example de_DE for german.
ENV LANG en_US.UTF-8
RUN echo $LANG UTF-8 > /etc/locale.gen && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
     locales && \
    update-locale --reset LANG=$LANG

# 安装一些开发工具，不需要可以注释
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential\
      git\
      unzip\ 
      curl\ 
      clang\ 
      cmake\ 
      pkg-config\
      libwayland-dev\
      weston

# Ubuntu desktop, Mate: ubuntu-mate-desktop
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ubuntu-desktop 

CMD ["mate-session"]

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
#
#
# Notes: 
#    1. Ubuntu 12.04 LTS (precise), 14.04 LTS (trusty), 16.04 LTS (xenial) can operate without systemd
#    2. Ubuntu 18.04 LTS (bionic), 20.04 LTS (focal), 20.10 (groovy) and upcoming 21.04 (hirsute) are fully-functional while using systemd.

ARG VER=focal
FROM ubuntu:$VER
ENV SHELL=/bin/bash

RUN bash -c 'if test -n "$http_proxy"; then echo "Acquire::http::proxy \"$http_proxy\";" > /etc/apt/apt.conf.d/99proxy; else echo "Using direct network connection."; fi'

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
      sudo \
      lsb-release

# Language/locale settings
#   replace en_US by your desired locale setting, 
#   for example de_DE for german.
ENV LANG en_US.UTF-8
RUN echo $LANG UTF-8 > /etc/locale.gen && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
     locales && \
    lsb_release -cs | grep -qE "precise|trusty" && locale-gen $LANG || update-locale --reset LANG=$LANG

RUN if lsb_release -cs | grep -qE "precise|xenial"; then \
    echo "Notice: it is precise or xenial, need workaround for resolvconf." && \
    echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections; \
    else true; fi

RUN if lsb_release -cs | grep -q "precise"; then \
    echo "Notice: it is precise, need workarounds and PPAs." && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y python-software-properties && \
    env DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:ubuntu-mate-dev/ppa && \
    env DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:ubuntu-mate-dev/precise-mate && \
    env DEBIAN_FRONTEND=noninteractive apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-mate-core --force-yes; \
    else true; fi

RUN if lsb_release -cs | grep -q "trusty"; then \
    echo "Notice: it is trusty, need workarounds and PPAs." && \    
    env DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
    env DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:ubuntu-mate-dev/ppa && \
    env DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:ubuntu-mate-dev/trusty-mate && \
    env DEBIAN_FRONTEND=noninteractive apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --force-yes && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-mate-core --force-yes; \
    else true; fi




# Ubuntu MATE desktop
# * package for 12.04 LTS and 14.04 LTS
# * task for 16.04 LTS and newer versions
RUN if lsb_release -cs | grep -qE "precise|trusty"; then \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ubuntu-mate-desktop --force-yes; \
    else \
      env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ubuntu-mate-desktop^; \
    fi

# 20.10 specifics
RUN if lsb_release -cs | grep -q "groovy"; then \
    echo "Warning: it is groovy, will use workarounds!" && \    
    env DEBIAN_FRONTEND=noninteractive sudo apt autopurge -y \
      acpid acpi-support sssd-common; \
    else true; fi

# 21.04 specifics
RUN if lsb_release -cs | grep -q "hirsute"; then \
    echo "Warning: it is hirsute, will use workarounds!" && \
        env DEBIAN_FRONTEND=noninteractive sudo apt autopurge -y \
      acpid acpi-support redshift-gtk; \
    else true; fi

# remove mate-screensaver
RUN env DEBIAN_FRONTEND=noninteractive apt-get purge mate-screensaver -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y

CMD ["mate-session"]

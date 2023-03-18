# 使用x11docker 在x86_64系统上运行arm64桌面系统

## 准备
1. 系统Ubuntu20+

2. 安装docker，参考 [官网指引](https://docs.docker.com/engine/install/ubuntu/)

3. x11docker，参考 [官网指引](https://github.com/mviereck/x11docker) ，安装完毕后，提前pull 它的docker镜像备用

   ```` shell
   sudo docker pull x11docker/xserver
   sudo docker pull x11docker/xfce
   ````

4. 准备用来build arm64桌面系统的 dockerfile

   [参考此处](https://github.com/N0rbert/dockerfile-x11docker-ubuntu-mate) ，这里我特意用的 Ubuntu20 ,  如需要更多的软件可以在dockerfile中添加 ，也可以安装其他Ubuntu桌面，参考[此处](https://www.makeuseof.com/install-desktop-environment-gui-ubuntu-server/)
````dockerfile
# x11docker with Ubuntu MATE
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

# Ubuntu MATE desktop
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ubuntu-mate-desktop

CMD ["mate-session"]
````

dockerfile 同目录下新建sources.list替换官方的镜像源 

````
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-backports main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-backports main restricted universe multiverse

# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-security main restricted universe multiverse
# # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-security main restricted universe multiverse

deb http://ports.ubuntu.com/ubuntu-ports/ focal-security main restricted universe multiverse
# deb-src http://ports.ubuntu.com/ubuntu-ports/ focal-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-proposed main restricted universe multiverse
# # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-proposed main restricted universe multiverse
````

5. docker buildx 工具配置，参考 [官方指引](https://docs.docker.com/build/building/multi-platform/)

6. build镜像，在dockerfile目录执行命令

   ````shell
   #此处编译后自动加载到本地docker，也可以参考官网指引编译后上传docker hub
   docker buildx build --platform linux/arm64 -t  ubuntu-mate-arm64:focal . --load
   ````

   

7. 使用x11docker 运行编译好的arm64系统镜像

   ````
   # 查看x11docker官网查询更多x11docker参数，使用 --sudouser 参数后，系统密码为 x11docker
   sudo x11docker --desktop ubuntu-mate-arm64:focal --sudouser --cap-default --ipc=host --network=host --home=$HOME
   
   ````
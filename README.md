# Ubuntu MATE with x11docker

Ubuntu MATE desktop in Docker image. Based on Ubuntu
 - Run MATE desktop in Docker.
 - Use [x11docker](https://github.com/mviereck/x11docker) to run GUI applications and desktop environments in docker images. 


# Command examples: 
 - Build container for the first time: `docker build . -t ubuntu-mate:focal`
 - Single application: `x11docker ubuntu-mate:focal caja`
 - Full desktop: `x11docker --desktop ubuntu-mate:focal`

# Options:
 - Persistent home folder stored on host with   `--home`
 - Shared host file or folder with              `--share PATH`
 - Hardware acceleration with option            `--gpu`
 - Clipboard sharing with option                `--clipboard`
 - ALSA sound support with option               `--alsa`
 - Pulseaudio sound support with option         `--pulseaudio`
 - Language locale settings with                `--lang [=$LANG]`
 - Printing over CUPS with                      `--printer`
 - Webcam support with                          `--webcam`

See `x11docker --help` for further options.

# Screenshot

![Ubuntu MATE 20.04 LTS inside Xephyr](https://ubuntu-mate.community/uploads/default/original/3X/0/b/0b59ab8454d5c40e59f02c5072b22ac172df8078.jpeg)

# Ubuntu MATE with x11docker

Ubuntu MATE desktop in Docker image. Based on Ubuntu
 - Run MATE desktop in Docker.
 - Use [x11docker](https://github.com/mviereck/x11docker) to run GUI applications and desktop environments in docker images. 


# Command examples: 
 - Build container for the first time: `docker build . -t ubuntu-mate`
 - Single application: `x11docker ubuntu-mate caja`
 - Full desktop: `x11docker --desktop ubuntu-mate`

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

sudo mkdir -p /opt/container-services/steam-headless
sudo chown -R $(id -u):$(id -g) /opt/container-services/steam-headless
sudo mkdir -p /opt/container-data/steam-headless/{home,.X11-unix,pulse}
sudo chown -R $(id -u):$(id -g) /opt/container-data/steam-headless
cat > /opt/container-services/steam-headless/docker-compose.yml <<'EOF'
---
version: "3.8"

services:
  steam-headless:
    image: josh5/steam-headless:latest
    restart: unless-stopped
    ## NOTE: This config uses privileged to access to host to be able to access the required devices
    privileged: true
    shm_size: ${SHM_SIZE}
    ipc: host # Could also be set to 'shareable'
    ulimits:
      nofile:
        soft: 1024
        hard: 524288

    # GPU PASSTHROUGH
    runtime: nvidia

    # NETWORK:
    ## NOTE:  With this configuration, if we do not use the host network, then physical device input
    ##        is not possible and your USB connected controllers will not work in steam games.
    network_mode: host
    hostname: ${NAME}
    extra_hosts:
      - "${NAME}:127.0.0.1"
    
    # ENVIRONMENT:
    ## Read all config variables from the .env file
    environment:
      # System
      - TZ=${TZ}
      - USER_LOCALES=${USER_LOCALES}
      - DISPLAY=${DISPLAY}
      # User
      - PUID=${PUID}
      - PGID=${PGID}
      - UMASK=${UMASK}
      - USER_PASSWORD=${USER_PASSWORD}
      # Mode
      - MODE=${MODE}
      # Web UI
      - WEB_UI_MODE=${WEB_UI_MODE}
      - ENABLE_VNC_AUDIO=${ENABLE_VNC_AUDIO}
      - PORT_NOVNC_WEB=${PORT_NOVNC_WEB}
      - NEKO_NAT1TO1=${NEKO_NAT1TO1}
      # Steam
      - ENABLE_STEAM=${ENABLE_STEAM}
      - STEAM_ARGS=${STEAM_ARGS}
      # Sunshine
      - ENABLE_SUNSHINE=${ENABLE_SUNSHINE}
      - SUNSHINE_USER=${SUNSHINE_USER}
      - SUNSHINE_PASS=${SUNSHINE_PASS}
      # Xorg
      - ENABLE_EVDEV_INPUTS=${ENABLE_EVDEV_INPUTS}
      - FORCE_X11_DUMMY_CONFIG=${FORCE_X11_DUMMY_CONFIG}
      # Nvidia specific config
      - NVIDIA_DRIVER_CAPABILITIES=${NVIDIA_DRIVER_CAPABILITIES}
      - NVIDIA_VISIBLE_DEVICES=${NVIDIA_VISIBLE_DEVICES}
      - NVIDIA_DRIVER_VERSION=${NVIDIA_DRIVER_VERSION}

    # VOLUMES:
    volumes:
      # The location of your home directory.
      - ${HOME_DIR}/:/home/default/:rw

      # The location where all games should be installed.
      # This path needs to be set as a library path in Steam after logging in.
      # Otherwise, Steam will store games in the home directory above.
      - ${GAMES_DIR}/:/mnt/games/:rw

      # The Xorg socket.
      - ${SHARED_SOCKETS_DIR}/.X11-unix/:/tmp/.X11-unix/:rw

      # Pulse audio socket.
      - ${SHARED_SOCKETS_DIR}/pulse/:/tmp/pulse/:rw

      # Input devices used for mouse and joypad support inside the container.
      - /dev/input/:/dev/input/:ro
EOF

cat > /opt/container-services/steam-headless/docker-compose.yml <<'EOF'#  ____            _                 
# / ___| _   _ ___| |_ ___ _ __ ___  
# \___ \| | | / __| __/ _ \ '_ ` _ \ 
#  ___) | |_| \__ \ ||  __/ | | | | |
# |____/ \__, |___/\__\___|_| |_| |_|
#        |___/                       
# 
NAME=SteamHeadless
TZ=Pacific/Auckland
USER_LOCALES=en_US.UTF-8 UTF-8
DISPLAY=:55
SHM_SIZE=2G
## HOME_DIR:
##      Description:    The path to the home directory on your host. Mounts to `/home/default` inside the container.
HOME_DIR=/opt/container-data/steam-headless/home
## SHARED_SOCKETS_DIR:
##      Description:    Shared sockets such as pulse audio and X11.
SHARED_SOCKETS_DIR=/opt/container-data/steam-headless/sockets
## GAMES_DIR:
##      Description:    The path to the games directory on your host. Mounts to `/mnt/games` inside the container.
GAMES_DIR=/mnt/games

#  ____        __             _ _     _   _               
# |  _ \  ___ / _| __ _ _   _| | |_  | | | |___  ___ _ __ 
# | | | |/ _ \ |_ / _` | | | | | __| | | | / __|/ _ \ '__|
# | |_| |  __/  _| (_| | |_| | | |_  | |_| \__ \  __/ |   
# |____/ \___|_|  \__,_|\__,_|_|\__|  \___/|___/\___|_|   
#                                                         
# 
PUID=1000
PGID=1000
UMASK=000
USER_PASSWORD=password

#  __  __           _      
# |  \/  | ___   __| | ___ 
# | |\/| |/ _ \ / _` |/ _ \
# | |  | | (_) | (_| |  __/
# |_|  |_|\___/ \__,_|\___|
#
#
## MODE:
##      Options:            ['primary', 'secondary']
##      Description:        Steam Headless containers can run in a secondary mode that will only start
##                          a Steam process that will then use the X server of either the host or another
##                          Steam Headless container running in 'primary' mode.
MODE=primary

#  ____                  _               
# / ___|  ___ _ ____   _(_) ___ ___  ___ 
# \___ \ / _ \ '__\ \ / / |/ __/ _ \/ __|
#  ___) |  __/ |   \ V /| | (_|  __/\__ \
# |____/ \___|_|    \_/ |_|\___\___||___/
#                                        
#
# Web UI
## WEB_UI_MODE: 
##      Options:            ['vnc', 'neko', 'none']
##      Description:        Configures the WebUI to use for accessing the virtual desktop.
##      Supported Modes:    ['primary']
WEB_UI_MODE=none
## ENABLE_VNC_AUDIO: 
##      Options:            ['true', 'false']
##      Description:        Enables audio over for the VNC Web UI if 'WEB_UI_MODE' is set to 'vnc'.
ENABLE_VNC_AUDIO=true
## PORT_NOVNC_WEB:
##      Description:        Configure the port to use for the WebUI.
PORT_NOVNC_WEB=8083
## NEKO_NAT1TO1:
##      Description:        Configure nat1to1 for the neko WebUI if it is enabled by setting 'WEB_UI_MODE' to 'neko'.
##                          This will need to be the IP address of the host.
NEKO_NAT1TO1=

# Steam
## ENABLE_STEAM:
##      Options:            ['true', 'false']
##      Description:        Enable Steam to run on start. This will also cause steam to restart automatically if closed.
##      Supported Modes:    ['primary', 'secondary']
ENABLE_STEAM=true
## STEAM_ARGS:
##      Description:        Additional steam execution arguments.
STEAM_ARGS=-silent

# Sunshine
## ENABLE_SUNSHINE:
##      Options:            ['true', 'false']
##      Description:        Enable Sunshine streaming service.
##      Supported Modes:    ['primary']
ENABLE_SUNSHINE=true
## SUNSHINE_USER:
##      Description:        Set the Sunshine service username.
SUNSHINE_USER=admin
## SUNSHINE_PASS:
##      Description:        Set the Sunshine service password.
SUNSHINE_PASS=admin

# Xorg
## ENABLE_EVDEV_INPUTS:
##      Available Options:  ['true', 'false']
##      Description:        Enable Keyboard and Mouse Passthrough. This will configure the Xorg server to catch all
##                          evdev events for Keyboard, Mouse, etc.
##                          In restricted container runtimes that use a private /dev (for example Docker-in-LXC),
##                          virtual Sunshine input devices may require the fallback udev path to materialize
##                          /dev/input/event* nodes before Xorg can attach them.
##      Supported Modes:    ['primary']
ENABLE_EVDEV_INPUTS=true
## FORCE_X11_DUMMY_CONFIG:
##      Available Options:  ['true', 'false']
##      Description:        Forces the installation of xorg.dummy.conf. This should be used when your output device does not have a monitor connected.
##      Supported Modes:    ['primary']
FORCE_X11_DUMMY_CONFIG=false

# Nvidia specific config (not required for non Nvidia GPUs)
## NVIDIA_DRIVER_CAPABILITIES:
##      Options:                ['all', 'compute', 'compat32', 'graphics', 'utility', 'video', 'display']
##      Description:            Controls which driver libraries/binaries will be mounted inside the container.
##      Supported Modes:        ['primary', 'secondary']
NVIDIA_DRIVER_CAPABILITIES=all
## NVIDIA_DRIVER_CAPABILITIES:
##      Available Options:      ['all', 'none', '<GPU UUID>']
##      Description:            Controls which GPUs will be made accessible inside the container.
##      Supported Modes:        ['primary', 'secondary']
NVIDIA_VISIBLE_DEVICES=all
## NVIDIA_DRIVER_VERSION:
##      Description:            Specify a driver version to force installation.
##                              Not meant to be used if nvidia container toolkit is installed.
##                              Detect current host driver installed with `nvidia-smi 2> /dev/null | grep NVIDIA-SMI | cut -d ' ' -f3`
##      Supported Modes:        ['primary', 'secondary']
NVIDIA_DRIVER_VERSION=

EOF

cd /opt/container-services/steam-headless
sudo docker-compose up -d --force-recreate


echo ssh -L 47990:127.0.0.1:47990 matt@$(curl -s https://ipinfo.io/ip)

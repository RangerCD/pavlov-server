# Pavlov Dedicated Server
# Reference: http://wiki.pavlov-vr.com/index.php?title=Dedicated_server

FROM ubuntu:20.04

# Install dependencies
RUN apt update && \
    apt install -y gdb curl lib32gcc1 && \
    useradd -m steam

# Switch user
USER steam

# Install SteamCmd
RUN mkdir ~/Steam && \
    cd ~/Steam && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Install Pavlov Server
RUN cd ~/Steam && \
    ./steamcmd.sh +login anonymous +force_install_dir /home/steam/pavlovserver +app_update 622970 +exit

# Postprocess
RUN chmod +x ~/pavlovserver/PavlovServer.sh && \
    ln -s ~/Steam/linux64/steamclient.so ~/pavlovserver/Pavlov/Binaries/Linux/ && \
    mkdir -p ~/pavlovserver/Pavlov/Saved/Logs && \
    mkdir -p ~/pavlovserver/Pavlov/Saved/Config/LinuxServer

# Run
ENTRYPOINT [ "cd ~/pavlovserver && ./PavlovServer.sh" ]

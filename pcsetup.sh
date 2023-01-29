echo Matta PC dinges V0.1
echo
echo Installing Ventoy...
wget https://github.com/ventoy/Ventoy/releases/download/v1.0.88/ventoy-1.0.88-linux.tar.gz
tar -xzf ventoy-1.0.88-linux.tar.gz
cd ventoy-1.0.88
sh Ventoy2Disk.sh -i -g /dev/vdb
echo
echo Installing Win10Fix.iso...
wget https://dl.dropboxusercontent.com/s/0pk3m8r2svisf8k/Win10fix.iso

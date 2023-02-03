apt update
apt install python3-pip -y
pip install gdown
cd /
echo Installing Ventoy...
wget https://github.com/ventoy/Ventoy/releases/download/v1.0.88/ventoy-1.0.88-linux.tar.gz -q --show-progress
tar -xzf ventoy-1.0.88-linux.tar.gz
cd ventoy-1.0.88
sh Ventoy2Disk.sh -i -g /dev/vdb
echo
cd ..
wget thijs.tk/pcsetup2.sh -q --show-progress
mv pcsetup2.sh /etc/init.d/
chmod +x /etc/init.d/pcsetup2.sh
echo Installing Win10Fix.iso...
gdown https://drive.google.com/uc?id=1Ocm44p6t6M2U06-CmDisScgN0ODnwt7F

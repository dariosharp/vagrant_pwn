# !/bin/bash

# Updates
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install python3-pip
sudo apt-get -y install tmux
sudo apt-get -y install gdb gdb-multiarch
sudo apt-get -y install unzip
sudo apt-get -y install foremost
sudo apt-get -y install emacs24
sudo apt-get -y install git
sudo apt-get -y install socat

# Exec 32 bit
sudo dpkg --add-architecture i386
sudo apt-get -y update
sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386

# QEMU with MIPS/ARM - http://reverseengineering.stackexchange.com/questions/8829/cross-debugging-for-mips-elf-with-qemu-toolchain
sudo apt-get -y install qemu qemu-user qemu-user-static
sudo apt-get -y install 'binfmt*'
sudo apt-get -y install libc6-armhf-armel-cross
sudo apt-get -y install debian-keyring
sudo apt-get -y install debian-archive-keyring
sudo apt-get -y install emdebian-archive-keyring
tee /etc/apt/sources.list.d/emdebian.list << EOF
deb http://mirrors.mit.edu/debian squeeze main
deb http://www.emdebian.org/debian squeeze main
EOF
sudo apt-get -y install libc6-mipsel-cross
sudo apt-get -y install libc6-arm-cross
mkdir /etc/qemu-binfmt
ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel 
ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm
rm /etc/apt/sources.list.d/emdebian.list
sudo apt-get update

cd
mkdir tools
cd tools

# Install radare2
git clone https://github.com/radare/radare2
cd radare2
./sys/install.sh

# Install binwalk
cd /home/vagrant/tools
git clone https://github.com/devttys0/binwalk
cd binwalk
sudo python setup.py install
cd /home/vagrant
                                                                             
# Install Firmware-Mod-Kit
sudo apt-get -y install git build-essential zlib1g-dev liblzma-dev python-magic
cd /home/vagrant/tools
wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz
tar xvf fmk_099.tar.gz
rm fmk_099.tar.gz
cd fmk_099/src
./configure
make

# Uninstall capstone
sudo pip2 uninstall capstone -y

# Install correct capstone
cd /home/vagrant/tools/capstone/bindings/python
sudo python setup.py install

# Personal config
cd /home/vagrant 
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh
cd .bash_it/themes/

# Install Angr
cd /home/vagrant
cd tools
sudo apt-get -y install python-dev libffi-dev build-essential virtualenvwrapper
sudo pip install virtualenv
virtualenv angr
source angr/bin/activate
pip install angr --upgrade
export BASH_IT_THEME='Bakke'

# gdbpeda
cd /home/vagrant/tools
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

# z3
cd /home/vagrant/tools
git clone https://github.com/Z3Prover/z3
cd z3
virtualenv venv
source venv/bin/activate
python scripts/mk_make.py --python
cd build
make
make install

# ROPgadget
cd /home/vagrant/tools
git clone https://github.com/JonathanSalwan/ROPgadget
cd ROPgadget
sudo python setup.py install

# Pwntool
pip install pwntools

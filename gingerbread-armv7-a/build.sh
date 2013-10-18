# Build sequence as a shell script

sudo apt-get update
sudo apt-get install -y python-software-properties
sudo add-apt-repository "deb http://archive.canonical.com/ precise partner"
sudo add-apt-repository "deb http://ca.archive.ubuntu.com/ubuntu/ precise universe"
sudo add-apt-repository "deb http://ca.archive.ubuntu.com/ubuntu/ precise-updates universe"
sudo add-apt-repository "deb http://ca.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse"
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu precise-security universe"

sudo apt-get update

# AOSP build dependencies
sudo apt-get install -y openjdk-6-jdk
sudo apt-get install -y git gnupg flex bison gperf zip curl
sudo apt-get install -y mingw32 tofrodos
sudo apt-get install -y build-essential gcc-4.4-multilib g++-4.4-multilib
sudo apt-get install -y python-markdown libxml2-utils xsltproc
sudo apt-get install -y x11proto-core-dev:i386 libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 libgl1-mesa-dev:i386
sudo apt-get install -y libc6-dev:i386 libncurses5-dev:i386 zlib1g-dev:i386
sudo apt-get install -y zlib1g-dev
sudo apt-get install -y gcc g++

# Fetch cross-toolchain for kernel
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6
export PATH=`pwd`/arm-eabi-4.6/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Fetch kernel
git clone https://android.googlesource.com/kernel/goldfish.git
pushd goldfish
git checkout origin/android-goldfish-2.6.29

# Build kernel
export ARCH=arm
export SUBARCH=armv7
export CROSS_COMPILE=arm-eabi-
make goldfish_armv7_defconfig
make -j 16
popd

# Fetch AOSP gingerbread and update qemu to R12
mkdir -p ~/bin
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo >~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

mkdir aosp
pushd aosp
repo init -u https://android.googlesource.com/platform/manifest -b android-2.3.7_r1
repo sync -j 16
repo forall platform/external/qemu -c git checkout aosp/tools_r12

# Build gingerbread
. build/envsetup.sh
lunch 1
make -j 16 TARGET_ARCH_VARIANT=armv7-a CC=gcc-4.4 CXX=g++-4.4
popd

# Run emulator
aosp/out/host/linux-x86/bin/emulator -no-window -show-kernel -kernel goldfish/arch/arm/boot/zImage -qemu -cpu cortex-a8

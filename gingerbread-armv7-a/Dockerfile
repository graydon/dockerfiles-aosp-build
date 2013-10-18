FROM ubuntu:precise
MAINTAINER Graydon Hoare "graydon@mozilla.com"

RUN apt-get update
RUN apt-get install -y python-software-properties
RUN add-apt-repository "deb http://archive.canonical.com/ precise partner"
RUN add-apt-repository "deb http://ca.archive.ubuntu.com/ubuntu/ precise universe"
RUN add-apt-repository "deb http://ca.archive.ubuntu.com/ubuntu/ precise-updates universe"
RUN add-apt-repository "deb http://ca.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse"
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu precise-security universe"

RUN apt-get update

# AOSP build dependencies
RUN apt-get install -y openjdk-6-jdk
RUN apt-get install -y git gnupg flex bison gperf zip curl
RUN apt-get install -y mingw32 tofrodos
RUN apt-get install -y build-essential gcc-4.4-multilib g++-4.4-multilib
RUN apt-get install -y python-markdown libxml2-utils xsltproc
RUN apt-get install -y x11proto-core-dev:i386 libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 libgl1-mesa-dev:i386
RUN apt-get install -y libc6-dev:i386 libncurses5-dev:i386 zlib1g-dev:i386

# Fetch cross-toolchain for kernel
RUN git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6
ENV PATH /arm-eabi-4.6/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Fetch kernel
RUN git clone https://android.googlesource.com/kernel/goldfish.git
RUN cd goldfish && git checkout origin/android-goldfish-2.6.29

# Build kernel
ENV ARCH arm
ENV SUBARCH armv7
ENV CROSS_COMPILE arm-eabi-
RUN apt-get install -y gcc g++
RUN make -C goldfish goldfish_armv7_defconfig
RUN make -C goldfish -j 16

# Fetch AOSP gingerbread and update qemu to R12
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo
RUN mkdir /aosp
RUN cd /aosp && repo init -u https://android.googlesource.com/platform/manifest -b android-2.3.7_r1
RUN cd /aosp && repo sync -j 16
RUN cd /aosp && repo forall platform/external/qemu -c git checkout aosp/tools_r12

# if trying to minimize space in a layer, replace previous two lines with this:
# RUN cd /aosp && repo sync -j 16 && repo forall platform/external/qemu -c git checkout aosp/tools_r12 && rm -Rf .repo prebuilt/darwin* prebuilt/windows*

# Build gingerbread
RUN apt-get install -y zlib1g-dev
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /bin/bash -c 'cd /aosp && . build/envsetup.sh && lunch 1 && make -j 16 TARGET_ARCH_VARIANT=armv7-a CC=gcc-4.4 CXX=g++-4.4'

# Run emulator by default
CMD aosp/out/host/linux-x86/bin/emulator -no-window -show-kernel -kernel goldfish/arch/arm/boot/zImage -qemu -cpu cortex-a8

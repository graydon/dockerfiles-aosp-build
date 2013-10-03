FROM graydon/aosp-build:base
MAINTAINER Graydon Hoare "graydon@mozilla.com"

# Temporarily disabled due to incorrect repo command uploaded to googlesource
#
#   RUN curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo >/usr/local/bin/repo
#
# Fixed one:
#
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo >/usr/local/bin/repo

RUN chmod a+x /usr/local/bin/repo
RUN mkdir /aosp-mirror
ADD aosp.key /tmp/aosp.key
RUN gpg --import </tmp/aosp.key

RUN cd /aosp-mirror && repo init -u https://android.googlesource.com/mirror/manifest --mirror
RUN cd /aosp-mirror && repo sync

RUN mkdir /aosp-build
ENV OUT_DIR_COMMON_BASE /aosp-build

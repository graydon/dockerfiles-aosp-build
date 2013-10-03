FROM graydon/aosp-build:mirrored
MAINTAINER Graydon Hoare "graydon@mozilla.com"

RUN mkdir /aosp-gingerbread
RUN cd /aosp-gingerbread && repo init -u /aosp-mirror -b android-2.3.7_r1
RUN cd /aosp-gingerbread && repo sync

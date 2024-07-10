# syntax=docker/dockerfile:1
FROM ubuntu:18.04 as base

RUN apt-get update

RUN apt-get install git -y

RUN apt-get install curl -y

RUN apt-get install wget -y

RUN apt-get install bzip2 -y

RUN apt-get install build-essential -y

RUN apt-get install unzip -y

RUN wget https://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/6_00_00_900/exports/msp430-gcc-7.3.0.9_linux64.tar.bz2
RUN mkdir /opt/ti/
RUN tar -xjf msp430-gcc-7.3.0.9_linux64.tar.bz2 -C /opt/ti/
RUN rm -f msp430-gcc-7.3.0.9_linux64.tar.bz2
RUN mv /opt/ti/msp430-gcc-7.3.0.9_linux64/ /opt/ti/mspgcc/

RUN wget https://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/6_00_00_900/exports/msp430-gcc-support-files-1.204.zip
RUN mkdir /msp430-gcc-support-files-1.204/
RUN unzip msp430-gcc-support-files-1.204.zip -d /msp430-gcc-support-files-1.204/
RUN mv /msp430-gcc-support-files-1.204/msp430-gcc-support-files/include/* /opt/ti/mspgcc/include
RUN rm -f msp430-gcc-support-files-1.204.zip
RUN rm -rf /msp430-gcc-support-files-1.204/

# fix the lack of stdbool.h include in msp430.h
RUN sed -i '1s/^/#include <stdbool.h>/' /opt/ti/mspgcc/lib/gcc/msp430-elf/7.3.0/plugin/include/config/msp430/msp430.h


RUN git clone --recursive https://github.com/wpineth/SONIC


# RUN export CPATH="/opt/ti/mspgcc/lib/gcc/msp430-elf/7.3.0/plugin/include/config/msp430/:$CPATH"

# RUN cd ./SONIC

# RUN CPATH="/opt/ti/mspgcc/lib/gcc/msp430-elf/7.3.0/plugin/include/config/msp430/:$CPATH" make apps/mnist/bld/gcc/depclean
# RUN CPATH="/opt/ti/mspgcc/lib/gcc/msp430-elf/7.3.0/plugin/include/config/msp430/:$CPATH" make apps/mnist/bld/gcc/dep
# RUN CPATH="/opt/ti/mspgcc/lib/gcc/msp430-elf/7.3.0/plugin/include/config/msp430/:$CPATH" make apps/mnist/bld/gcc/all BACKEND=sonic

# RUN gcc -v

# docker build -t sonic .
# docker run -it sonic
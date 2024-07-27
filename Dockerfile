# syntax=docker/dockerfile:1
FROM ubuntu:18.04 as base

RUN apt-get update
RUN apt-get install git -y
RUN apt-get install curl -y
RUN apt-get install wget -y
RUN apt-get install bzip2 -y
RUN apt-get install build-essential -y
RUN apt-get install unzip -y
RUN apt-get install bc -y
RUN apt-get install screen -y
RUN apt-get install libusb-0.1-4 -y
RUN apt-get install libc6 -y

RUN wget http://security.ubuntu.com/ubuntu/pool/main/n/ncurses/libtinfo6_6.2-0ubuntu2.1_amd64.deb
RUN dpkg -i libtinfo6_6.2-0ubuntu2.1_amd64.deb
RUN rm -f libtinfo6_6.2-0ubuntu2.1_amd64.deb

RUN wget http://mirrors.kernel.org/ubuntu/pool/main/r/readline/libreadline8_8.0-4_amd64.deb
RUN dpkg -i libreadline8_8.0-4_amd64.deb
RUN rm -f libreadline8_8.0-4_amd64.deb

RUN wget https://mirrors.edge.kernel.org/ubuntu/pool/universe/m/mspdebug/mspdebug_0.22-2build2_amd64.deb
RUN dpkg -i mspdebug_0.22-2build2_amd64.deb
RUN rm -f mspdebug_0.22-2build2_amd64.deb

RUN wget https://dr-download.ti.com/software-development/software-programming-tool/MD-szn5bCveqt/1.03.20.00/MSPFlasher-1_03_20_00-linux-x64-installer.zip
RUN unzip MSPFlasher-1_03_20_00-linux-x64-installer.zip -d /MSPFlasher-1_03_20_00-linux-x64-installer/
RUN chmod +x /MSPFlasher-1_03_20_00-linux-x64-installer/MSPFlasher-1.3.20-linux-x64-installer.run
RUN ./MSPFlasher-1_03_20_00-linux-x64-installer/MSPFlasher-1.3.20-linux-x64-installer.run --mode unattended
RUN mv /root/ti/MSPFlasher_1.3.20/libmsp430.so /usr/lib/
RUN rm -f MSPFlasher-1_03_20_00-linux-x64-installer.zip
RUN rm -rf /MSPFlasher-1_03_20_00-linux-x64-installer/
RUN rm -rf /root/ti/

RUN wget https://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/6_00_00_900/exports/msp430-gcc-7.3.0.9_linux64.tar.bz2
RUN mkdir /opt/ti/
RUN tar -xjf msp430-gcc-7.3.0.9_linux64.tar.bz2 -C /opt/ti/
RUN rm -f msp430-gcc-7.3.0.9_linux64.tar.bz2
RUN mv /opt/ti/msp430-gcc-7.3.0.9_linux64/ /opt/ti/mspgcc/

RUN wget https://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/6_00_00_900/exports/msp430-gcc-support-files-1.204.zip
RUN unzip msp430-gcc-support-files-1.204.zip -d /msp430-gcc-support-files-1.204/
RUN mv /msp430-gcc-support-files-1.204/msp430-gcc-support-files/include/* /opt/ti/mspgcc/include
RUN rm -f msp430-gcc-support-files-1.204.zip
RUN rm -rf /msp430-gcc-support-files-1.204/

# fix the lack of stdbool.h include in msp430.h
# RUN sed -i '1s/^/#include <stdbool.h>/' /opt/ti/mspgcc/lib/gcc/msp430-elf/7.3.0/plugin/include/config/msp430/msp430.h

RUN echo $'/opt/ti/mspgcc/libexec/gcc/msp430-elf/7.3.0/\n\
/opt/ti/mspgcc/lib/gcc/msp430-elf/7.3.0/plugin/\n\
/opt/ti/mspgcc/lib64/' > /etc/ld.so.conf.d/ti.conf


RUN echo $'\n\
\n\
export CPATH="/opt/ti/mspgcc/lib/gcc/msp430-elf/7.3.0/plugin/include/config/msp430/:$CPATH"' > ~/.bashrc

RUN git clone --recursive https://github.com/wpineth/SONIC




# util
RUN apt-get install usbutils -y




# RUN cd ./SONIC

# RUN make apps/mnist/bld/gcc/depclean
# RUN make apps/mnist/bld/gcc/dep
# RUN make apps/mnist/bld/gcc/all BACKEND=sonic


# make apps/mnist/bld/gcc/depclean
# make apps/mnist/bld/gcc/dep
# make apps/mnist/bld/gcc/all BACKEND=sonic

# make apps/mnist/bld/gcc/depclean CONSOLE=1
# make apps/mnist/bld/gcc/dep CONSOLE=1
# make apps/mnist/bld/gcc/all BACKEND=sonic CONSOLE=1





# Terminal 1

# sudo docker build -t sonic . && sudo docker run --privileged -it sonic

# cd ./SONIC
# make apps/mnist/bld/gcc/depclean CONSOLE=1
# make apps/mnist/bld/gcc/dep CONSOLE=1
# make apps/mnist/bld/gcc/all BACKEND=sonic CONSOLE=1
# mspdebug -v 3300 -d /dev/ttyACM1 tilib

# prog apps/mnist/bld/gcc/mnist.out
# run

# Terminal 2

# sudo docker ps
# sudo docker exec -it <container> bash
# screen /dev/ttyACM1 115200
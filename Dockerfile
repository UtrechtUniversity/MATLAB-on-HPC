FROM ubuntu:16.04

# install software
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
        -y openssh-server \
        -y vim \
        -y unzip \
        -y xorg \
		-y libfuse2 \
		-y cifs-utils \
		-y wget libcurl4-gnutls-dev \
	-y net-tools \
	-y sudo

# allow root login 
RUN echo 'root:wijzigen' | chpasswd

# setup and ssh server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22

# add user profile
ENV user user
RUN useradd --create-home --shell /bin/bash ${user} 
WORKDIR /home/${user} 
RUN echo 'user:user' | chpasswd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# create matlab folder with matlab installer
RUN mkdir /home/user/matlab 
COPY matlab_R2018a_glnxa64.zip /home/user/matlab
RUN cd /home/user/matlab \
 && unzip matlab_R2018a_glnxa64.zip \
 && chown -R user /home/user
COPY install_matlab.sh /home/user/matlab
RUN chown root:root /home/user/matlab/install_matlab.sh \
 && chmod o=rx /home/user/matlab/install_matlab.sh

# install icommands
RUN wget https://files.renci.org/pub/irods/releases/4.1.12/ubuntu14/irods-icommands-4.1.12-ubuntu14-x86_64.deb -O /tmp/icommands.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y `dpkg -I /tmp/icommands.deb | sed -n 's/^ Depends: //p' | sed 's/,//g'`
RUN dpkg -i /tmp/icommands.deb \
 && rm /tmp/icommands.deb
RUN mkdir /home/user/.irods \
 && chown user:user /home/user/.irods \
 && chmod +w /home/user/.irods
 
# create folder for mounting local folder
RUN mkdir /home/user/mnt

# give sudo rights for installer file
RUN echo "${user} ALL=(ALL:ALL) NOPASSWD: /home/user/matlab/install_matlab.sh" >> /etc/sudoers

# expose irods port
EXPOSE 1247

# run command at startup
CMD ["/usr/sbin/sshd", "-D"]

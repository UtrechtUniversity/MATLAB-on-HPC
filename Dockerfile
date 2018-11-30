FROM ubuntu:16.04

# install software
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
        -y openssh-server \
        -y vim \
        -y unzip \
        -y xorg \
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
# && chown -R user /home/${user}
WORKDIR /home/${user} 
# USER ${user} 
RUN echo 'user:user' | chpasswd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# add superuser profile
#ENV user superuser
#RUN useradd --shell /bin/bash ${user} 
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

# create matlab folder with matlab installer
RUN mkdir /home/user/matlab 
COPY matlab_R2018a_glnxa64.zip /home/user/matlab
RUN cd /home/user/matlab \
 && unzip matlab_R2018a_glnxa64.zip \
 && chown -R user /home/user
COPY install_matlab.sh /home/user/matlab
RUN chown root:root /home/user/matlab/install_matlab.sh \
 && chmod o=rx /home/user/matlab/install_matlab.sh


# give sudo rights for installer file
RUN echo "${user} ALL=(ALL:ALL) NOPASSWD: /home/user/matlab/install_matlab.sh" >> /etc/sudoers

# run command at startup
CMD ["/usr/sbin/sshd", "-D"]


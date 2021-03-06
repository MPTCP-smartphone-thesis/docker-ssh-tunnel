# ssh-tunnel
#
# VERSION  0.0.1

FROM       ubuntu:14.04
MAINTAINER Matthieu Baerts "matttbe@gmail.com"

# Install SSH server (without root login)
RUN apt-get update && apt-get install -y openssh-server

# /var/run/sshd dir is needed
RUN mkdir /var/run/sshd

# Port 22 by default (use -p 0.0.0.0:XXXX:22 to use another one)
EXPOSE 22

# Create user 'tunnel' without access to a prompt
RUN useradd -m tunnel
RUN echo 'tunnel:tunnel' | chpasswd
RUN chsh -s /bin/false tunnel
RUN printf "\nMatch User tunnel\n   AllowTcpForwarding yes\n   X11Forwarding no\n" >> /etc/ssh/sshd_config

# If you want to connect to this user only with a RSA key, remove the previous block, uncomment the following and create an authorized_key file:
# RUN useradd -m tunnel -d /home/tunnel && mkdir /home/tunnel/.ssh
# RUN printf "\nMatch User tunnel\n   AllowTcpForwarding yes\n   X11Forwarding no\n   PasswordAuthentication no\n" >> /etc/ssh/sshd_config
# ADD authorized_key /home/tunnel/.ssh/authorized_key
# RUN chown tunnel:tunnel -R /home/tunnel/.ssh && chmod 700 /home/tunnel/.ssh && chmod 600 /home/tunnel/.ssh/*

CMD ["/usr/sbin/sshd", "-D"]

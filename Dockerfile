FROM ubuntu:20.04

#install sudo
RUN apt-get update && \
    apt-get -y install sudo

#install ssh
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN sudo apt-get -y install  openssh-server
RUN service ssh start

#create user environement
ENV user ubuntu
RUN useradd -m -d /home/${user} ${user} && \
    chown -R ${user} /home/${user} && \
    adduser ${user} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ${user}
WORKDIR /home/${user}

#intstall python & pip
RUN sudo apt-get -y install curl && \
    sudo apt-get -y install python3-pip

#install ansible via pip
RUN pip install ansible==3.2.0 --user

ENV PATH="/home/${user}/.local/bin:$PATH"

#add playbooks to container
COPY ./entrypoint.sh /home/${user}/entrypoint.sh
COPY playbook /home/${user}/playbooks

#make entrypoint executable
RUN sudo chmod +x /home/${user}/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
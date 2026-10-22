FROM lcos:latest

ARG USER=guest

RUN apt update --no-install-recommends -y
RUN apt install systemctl net-tools openssh-server x11vnc xvfb xauth git zenity

RUN mkdir -p /run/sshd
RUN systemctl enable ssh
ENV PYTHONWARNINGS=ignore::SyntaxWarning

RUN useradd -m ${USER}
RUN usermod -aG root ${USER}
RUN usermod -aG sudo ${USER}
RUN echo "${USER}:password" | chpasswd

RUN git clone http://github.com/egrissino/photoc.git /tmp/photoc && cd /tmp/photoc && ./native-setup.sh && ./build.sh

RUN cp /tmp/photoc/build/src/apps/photoc/photoc /usr/local/bin/
RUN cp /tmp/photoc/build/src/apps/photoc-cli/photoc-cli /usr/local/bin/

RUN mkdir -p /home/${USER}/.local/share/icons/hicolor/256x256/apps
RUN cp /tmp/photoc/assets/photoc.png /home/${USER}/.local/share/icons/hicolor/256x256/apps

RUN mkdir -p /home/${USER}/.local/share/applications
RUN cp /tmp/photoc/assets/photoc.desktop /home/${USER}/.local/share/applications

RUN chmod +x /usr/local/bin/photoc
RUN chmod +x /usr/local/bin/photoc-cli
RUN chown ${USER}:${USER} /usr/local/bin/photoc
RUN chown ${USER}:${USER} /usr/local/bin/photoc-cli

COPY startup.sh /home/${USER}/
RUN chmod +x /home/${USER}/startup.sh

USER ${USER}
WORKDIR /home/${USER}

CMD [ "./startup.sh" ]

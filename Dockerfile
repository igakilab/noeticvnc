FROM ros:noetic-ros-base
LABEL maintainer="IGK"

ENV DEBIAN_FRONTEND noninteractive

RUN echo "Set disable_coredump false" >> /etc/sudo.conf

ADD ./setup /root/setup
WORKDIR /root/setup
RUN ./stop_update.sh
RUN ./install_basic_packages.sh
RUN ./install_python_packages.sh
#RUN ./install_chrome.sh

RUN useradd --create-home --home-dir /home/ubuntu --shell /bin/bash --user-group --groups adm,sudo ubuntu \
    && echo ubuntu:ubuntu | chpasswd \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# tini to fix subreap
ARG TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN sudo chmod +x /bin/tini

#ros Packages
RUN sudo apt-get install -y --no-install-recommends ros-noetic-cv-camera \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-image-transport \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-image-transport-plugins \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-joint-state-publisher-gui \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-joy \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-laser-filters \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-laser-pipeline \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-map-server \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-mouse-teleop \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-navigation \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-robot-state-publisher \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-rosbash \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-rviz \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-slam-gmapping \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-stage-ros \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-rosbridge-suite \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-teleop-twist-joy \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-teleop-twist-keyboard \
	&& sudo apt-get install -y --no-install-recommends ros-noetic-xacro
RUN sudo apt-get install -y --no-install-recommends ros-noetic-rqt-graph
RUN sudo apt-get install -y --no-install-recommends ros-noetic-rqt-image-view


# Install noVNC
RUN mkdir -p /opt/noVNC/utils/websockify && \
    wget -qO- "http://github.com/novnc/noVNC/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC && \
    wget -qO- "https://github.com/novnc/websockify/tarball/master" | tar -zx --strip-components=1 -C /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

RUN curl -sSL "https://update.code.visualstudio.com/latest/server-linux-x64/stable" -o /tmp/vscode-server-linux-x64.tar.gz

RUN sudo mkdir -p /home/ubuntu/.vscode-server/bin/latest
# assume that you upload vscode-server-linux-x64.tar.gz to /tmp dir
RUN tar zxvf /tmp/vscode-server-linux-x64.tar.gz -C /home/ubuntu/.vscode-server/bin/latest --strip 1
RUN touch /home/ubuntu/.vscode-server/bin/latest/0

RUN sudo chown -R ubuntu:ubuntu /home/ubuntu/.vscode-server/



RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN apt-get update
RUN apt-get install -y --no-install-recommends google-chrome-stable \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*


ADD ./app /app
RUN chown ubuntu:ubuntu /app/startup.sh;sudo chmod +x /app/startup.sh

RUN curl -fOL https://github.com/coder/code-server/releases/download/v4.2.0/code-server_4.2.0_amd64.deb
RUN dpkg -i code-server_4.2.0_amd64.deb
RUN code-server --extensions-dir /home/ubuntu/.vscode-server/extensions --install-extension xyz.local-history
RUN code-server --extensions-dir /home/ubuntu/.vscode-server/extensions --install-extension 	/app/vscode/saikou9901.evilinspector-1.0.8.vsix
#RUN code-server --extensions-dir /home/ubuntu/.vscode-server/extensions --install-extension ms-python.python
RUN code-server --extensions-dir /home/ubuntu/.vscode-server/extensions --install-extension /app/vscode/ms-python.vscode-pylance-2022.3.3.vsix
RUN dpkg -r code-server;rm -f code-server_4.2.0_amd64.deb

RUN sudo apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN sudo ln -s /usr/bin/python3 /usr/bin/python

ADD ./app/vscode/settings.json /home/ubuntu/.vscode-server/data/Machine/
RUN chown ubuntu:ubuntu -R /home/ubuntu/.vscode-server;chmod 644 /home/ubuntu/.vscode-server/data/Machine/settings.json
RUN rm -rf /app/vscode/

USER ubuntu
WORKDIR /home/ubuntu/


ENTRYPOINT ["/app/startup.sh"]

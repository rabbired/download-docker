FROM rabbired/ubuntu-baseimage:latest
MAINTAINER Red Z rabbired@outlook.com

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

# add repo and install qbitorrent
RUN \
echo "***** add qbitorrent repositories ****" && \
  apt update && apt upgrade -y && \
  apt install -y gnupg && \
  gpg --keyserver keyserver.ubuntu.com --recv D35164147CA69FC4 && \
  gpg --export --armor D35164147CA69FC4 | apt-key add - && \
  bash -l -c 'echo "deb http://ppa.launchpad.net/qbittorrent-team/qbittorrent-unstable/ubuntu focal main" \
  >> /etc/apt/sources.list.d/qbittorrent.list' && \
  bash -l -c 'echo "deb-src http://ppa.launchpad.net/qbittorrent-team/qbittorrent-unstable/ubuntu focal main" \
  >> /etc/apt/sources.list.d/qbittorrent.list' && \
  apt update && \
  apt install -y \
#	qbittorrent-nox=4.4.0~* \
	qbittorrent-nox \
	unrar \
	geoip-bin \
	unzip

# add autoremove-torrents flexget subfinder aria2
RUN apt update && \
  apt install -y \
  python3 \
  python3-pip \
  aria2 && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    pip3 install pip -U && \
    pip install flexget && \
    pip install autoremove-torrents && \
    pip install subfinder && \
    pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U && \
    apt clean && \
    apt autoremove --purge -y && \
    rm -rf \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/tmp/*

ENV HOME="/config" \
XDG_CONFIG_HOME="/config" \
XDG_DATA_HOME="/config"

# add local files
COPY root/ /

# ports and volumes
EXPOSE 6881 6881/udp 8080 8081
#VOLUME /config /downloads

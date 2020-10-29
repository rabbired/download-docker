FROM rabbired/ubuntu-baseimage:latest
MAINTAINER Red Z rabbired@outlook.com

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

# add repo and install qbitorrent
RUN \
 echo "***** add qbitorrent repositories ****" && \
 apt update && \
 apt install -y \
	gnupg \
	python3 && \
 gpg --keyserver keyserver.ubuntu.com --recv D35164147CA69FC4 && \
 gpg --export --armor D35164147CA69FC4 | apt-key add - && \
 echo "deb http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu focal main" >> /etc/apt/sources.list.d/qbitorrent.list && \
 echo "deb-src http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu focal main" >> /etc/apt/sources.list.d/qbitorrent.list && \
 apt update && \
 apt install -y \
	qbittorrent-nox \
	unrar \
	geoip-bin \
	unzip

# add autoremove-torrents flexget subfinder aria2 ariang
RUN apt update && apt upgrade --yes && \
  apt install --yes \
  python3-pip \
  aria2 && \
    ln -s /usr/bin/pip3 /bin/pip && \
    pip3 install pip -U && \
    pip install autoremove-torrents && \
    pip install flexget && \
    pip install subfinder && \
    curl -fLO https://glare.now.sh/mayswind/AriaNg/AllInOne.zip && \
    unzip AllInOne.zip -d /ariang && \
    apt clean && \
    apt autoremove --purge -y && \
    rm -rf \
      AriaNg-1.1.7-AllInOne.zip \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/tmp/*

ENV HOME="/config" \
XDG_CONFIG_HOME="/config" \
XDG_DATA_HOME="/config"


# add local files
COPY root/ /

# ports and volumes
EXPOSE 6881 6881/udp 8080
VOLUME /config /downloads

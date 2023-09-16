FROM debian
RUN mkdir -p /config/logs
VOLUME /config
VOLUME /mnt
ENV USERID=1000
ENV UNSYNCED=Cache
ENV UPLOADCACHE=UploadCache
ENV DIRCACHE=96h
ENV MERGEMOUNT=Cloud
ENV MEDIA=Media
ENV TURBOMAX=20
RUN apt update &&  apt install curl procps fuse3 jq vnstat unzip -y &&  apt upgrade -y &&  sed -i 's/^#user_allow_other/user_allow_other/g' /etc/fuse.conf &&  sed -i 's/^DatabaseDir \"\/var\/lib\/vnstat\"/DatabaseDir=\"\/config\"/g' /etc/vnstat.conf
RUN curl https://rclone.org/install.sh | bash
COPY omni-rclone omni-merger rstats startup turbosync mergerfs.deb /root/
WORKDIR /root
RUN dpkg -i mergerfs.deb && rm -r mergerfs.deb && apt autoclean -y
# RUN rm -rf /var/cache/apt /var/lib/apt/lists/*
CMD "/root/startup"

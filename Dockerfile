FROM debian
RUN mkdir -p /config/logs
# Create volumes.
#
#	/config - stores user-specific settings
#	/mnt - where remote drives will be mounted
#
VOLUME /config
VOLUME /mnt
#
# Default environmental settings
#
ENV USERID=1000
ENV UNSYNCED=Cache
ENV UPLOADCACHE=UploadCache
ENV DIRCACHE=96h
ENV MERGEMOUNT=Cloud
ENV MEDIA=Media
ENV TURBOMAX=20
#
# Install additional files
#
RUN apt update &&  apt install curl procps fuse3 jq vnstat unzip -y &&  apt upgrade -y &&  sed -i 's/^#user_allow_other/user_allow_other/g' /etc/fuse.conf &&  sed -i 's/^DatabaseDir \"\/var\/lib\/vnstat\"/DatabaseDir=\"\/config\"/g' /etc/vnstat.conf
#
# Install Rclone from repository
#
RUN curl https://rclone.org/install.sh | bash
#
# Bring in scripts and binaries
#
COPY omni-rclone omni-merger rstats startup turbosync mergerfs.deb /root/
WORKDIR /root
#
# Install MergerFS
#
RUN dpkg -i mergerfs.deb && rm -r mergerfs.deb && apt autoclean -y
# RUN rm -rf /var/cache/apt /var/lib/apt/lists/*
CMD "/root/startup"

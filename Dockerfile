FROM alpine:3.12

# Install packages
RUN \
 apk upgrade --no-cache --available && \
 apk add --no-cache tzdata shadow curl ffmpeg mediainfo

# Change nobody's uid, gid, and shell
RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -s /bin/ash nobody

# Add scripts to /bin
COPY convert.sh /bin/convert.sh
COPY notify.sh /bin/notify.sh
COPY watchfolder.sh /bin/watchfolder.sh
RUN \
 chmod +x /bin/convert.sh && \
 chmod +x /bin/notify.sh && \
 chmod +x /bin/watchfolder.sh

VOLUME ["/config", "/data"]

USER nobody
ENTRYPOINT ["/bin/watchfolder.sh"]

FROM alpine:edge
MAINTAINER silverbolt28

# Install packages
RUN \
 apk upgrade --no-cache --available && \
 apk add --no-cache tzdata shadow curl ffmpeg mediainfo

# Change nobody's uid, gid, and shell
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody
RUN usermod -s /bin/ash nobody

# Add scripts to /bin
ADD convert.sh /bin/convert.sh
RUN chmod +x /bin/convert.sh
ADD pushbullet.sh /bin/pushbullet.sh
RUN chmod +x /bin/pushbullet.sh
ADD watchfolder.sh /bin/watchfolder.sh
RUN chmod +x /bin/watchfolder.sh

VOLUME ["/config", "/data"]

USER nobody
ENTRYPOINT ["/bin/watchfolder.sh"]

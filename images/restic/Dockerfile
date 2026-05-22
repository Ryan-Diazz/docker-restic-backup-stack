FROM restic/restic:latest

RUN apk add --no-cache \
    bash \
    curl \
    tzdata \
    nfs-utils

ADD https://github.com/aptible/supercronic/releases/latest/download/supercronic-linux-amd64 /usr/local/bin/supercronic

RUN chmod +x /usr/local/bin/supercronic

COPY run-restic.sh /run-restic.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /run-restic.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

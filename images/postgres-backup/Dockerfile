FROM alpine:3.22

RUN apk add --no-cache \
    postgresql17-client \
    bash \
    curl \
    tzdata

ADD https://github.com/aptible/supercronic/releases/latest/download/supercronic-linux-amd64 /usr/local/bin/supercronic

RUN chmod +x /usr/local/bin/supercronic

COPY backup.sh /backup.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /backup.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

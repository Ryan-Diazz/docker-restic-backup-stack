FROM mongo:7

RUN apt-get update && apt-get install -y \
    curl \
    tzdata \
 && rm -rf /var/lib/apt/lists/*

ADD https://github.com/aptible/supercronic/releases/latest/download/supercronic-linux-amd64 /usr/local/bin/supercronic

RUN chmod +x /usr/local/bin/supercronic

COPY backup.sh /backup.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /backup.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

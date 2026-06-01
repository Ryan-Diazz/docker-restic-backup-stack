FROM restic/restic:0.17.3

RUN apk add --no-cache \
    bash \
    curl \
    tzdata 

ADD https://github.com/aptible/supercronic/releases/latest/download/supercronic-linux-amd64 /usr/local/bin/supercronic

RUN chmod +x /usr/local/bin/supercronic

WORKDIR /app
COPY --chmod=755 run-restic.sh run-check.sh entrypoint.sh health.sh ./

HEALTHCHECK --interval=5m --timeout=60s --start-period=30s --retries=2 CMD "/app/health.sh" || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]

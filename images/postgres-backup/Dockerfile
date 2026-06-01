FROM alpine:3.22

RUN mkdir -p /backup /triggers

RUN apk add --no-cache \
    postgresql17-client \
    bash \
    tzdata \
    file

WORKDIR /app
COPY --chmod=755 backup.sh entrypoint.sh ./

ENTRYPOINT ["/app/entrypoint.sh"]

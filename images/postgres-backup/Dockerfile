FROM alpine:3.22

RUN mkdir -p /backup

RUN apk add --no-cache \
    postgresql17-client \
    bash \
    tzdata


RUN apk add --no-cache curl \
  && curl -fsSL https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
      -o /usr/local/bin/supercronic \
  && echo "a2e2d47078a8dafc5949491e5a8dc0b3da7cd436feabd6e11be965b7e84ee7d6  /usr/local/bin/supercronic" \
      | sha256sum -c - \
  && chmod +x /usr/local/bin/supercronic \
  && apk del curl

WORKDIR /app
COPY --chmod=755 backup.sh entrypoint.sh ./

ENTRYPOINT ["/app/entrypoint.sh"]

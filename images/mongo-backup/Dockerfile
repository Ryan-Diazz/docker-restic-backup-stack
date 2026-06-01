FROM mongo:7

RUN apt-get update && apt-get install -y \
    tzdata \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
    -o /usr/local/bin/supercronic \
  && echo "a2e2d47078a8dafc5949491e5a8dc0b3da7cd436feabd6e11be965b7e84ee7d6  /usr/local/bin/supercronic" \
    | sha256sum -c - \
  && chmod +x /usr/local/bin/supercronic

WORKDIR /app
COPY --chmod=755 backup.sh entrypoint.sh ./

ENTRYPOINT ["/app/entrypoint.sh"]
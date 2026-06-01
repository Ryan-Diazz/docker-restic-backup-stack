FROM mongo:7

RUN mkdir -p /backup /triggers

RUN apt-get update && apt-get install -y \
    tzdata \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /app
COPY --chmod=755 backup.sh entrypoint.sh ./

ENTRYPOINT ["/app/entrypoint.sh"]
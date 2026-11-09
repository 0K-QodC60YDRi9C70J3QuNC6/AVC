FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends g++ python3 python3-matplotlib && rm -rf /var/lib/apt/lists/*
WORKDIR /work
CMD ["sh", "run.sh"]

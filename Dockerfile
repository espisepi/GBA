FROM --platform=linux/amd64 debian:bookworm

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tools

RUN wget https://arm.flatassembler.net/FASMARM_full.ZIP -O fasmarm.zip \
    && unzip fasmarm.zip \
    && chmod +x fasmarm

WORKDIR /work

ENTRYPOINT ["/tools/fasmarm"]
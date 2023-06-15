FROM --platform=linux/amd64 ubuntu:22.04 

ARG DEBIAN_FRONTEND=noninteractive

ARG TZ=Australia/Sydney

ENV LD_LIBRARY_PATH=/usr/local/lib

WORKDIR /

RUN apt update -y               \
        && apt upgrade -y       \
        && apt install wget unzip rsync libssl-dev libuv1-dev libnghttp2-dev libtool libcap-dev libnetfilter-queue-dev iptables -y

RUN wget https://github.com/nirajsapkota/pqc-bind/releases/latest/download/pqc-bind.zip \
        && mkdir pqc-bind                                                               \
        && unzip pqc-bind.zip -d pqc-bind                                               \
        && rsync -a pqc-bind/* /usr/local/                                              \
        && rm -rf pqc-bind pqc-bind.zip

RUN wget https://github.com/nirajsapkota/pqc-dns-sidecar/releases/latest/download/pqc-dns-sidecar-linux-amd64       \
        && chmod +x pqc-dns-sidecar-linux-amd64                                                                     \
        && mv pqc-dns-sidecar-linux-amd64 /usr/local/bin

CMD iptables -A INPUT -p ip -j NFQUEUE --queue-num 0            \
        && iptables -A OUTPUT -p ip -j NFQUEUE --queue-num 0    \
        && pqc-dns-sidecar-linux-amd64                          \
        && named -g -d 3

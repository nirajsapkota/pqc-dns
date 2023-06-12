FROM --platform=linux/amd64 ubuntu:22.04 

ARG DEBIAN_FRONTEND=noninteractive

ARG TZ=Australia/Sydney

WORKDIR /

RUN apt update -y               \
        && apt upgrade -y       \
        && apt install wget unzip rsync libssl-dev libuv1-dev libnghttp2-dev libtool libcap-dev libnetfilter-queue-dev -y

RUN wget https://github.com/nirajsapkota/pqc-bind/releases/latest/download/pqc-bind.zip \
        && mkdir pqc-bind                                                               \
        && unzip pqc-bind.zip -d pqc-bind                                               \
        && rsync -a pqc-bind/* /usr/local/                                              \
        && rm -rf pqc-bind pqc-bind.zip                                                 \
        && ldconfig      

RUN wget https://github.com/nirajsapkota/pqc-dns-sidecar/releases/latest/download/pqc-dns-sidecar       \
        && chmod +x pqc-dns-sidecar                                                                     \
        && mv pqc-dns-sidecar /usr/local/bin

# Todo: Run the pqc-dns-sidecar
# Todo: Configure iptables

CMD [ "named", "-g", "-d", "3" ]

FROM iron/node
WORKDIR /app

# Ensure nodejs is at a specific version
# Also install expect and bash
RUN apk add --update nodejs=5.10.1-r0
RUN apk add --update expect bash

# Magic commands to get glibc for stockfish
ENV \
    ALPINE_GLIBC_URL="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/" \
    GLIBC_PKG="glibc-2.21-r2.apk" \
    GLIBC_BIN_PKG="glibc-bin-2.21-r2.apk"
RUN \
    apk add --update -t deps wget ca-certificates openssl \
    && apk add -t openssl \
    && cd /tmp \
    && wget ${ALPINE_GLIBC_URL}${GLIBC_PKG} ${ALPINE_GLIBC_URL}${GLIBC_BIN_PKG} \
    && apk add --allow-untrusted ${GLIBC_PKG} ${GLIBC_BIN_PKG} \
    && /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && apk del --purge deps \
    && rm -f /tmp/* /var/cache/apk/*

COPY chess-server.js /app/
COPY settings.json /app/
COPY move.sh /app/
COPY stockfish-6-linux/Linux/stockfish_6_x64 /app/stockfish-6-linux/Linux/stockfish_6_x64
COPY node_modules/ /app/node_modules/

# Expose node port
EXPOSE 80

# Run node
ENTRYPOINT [ "node", "chess-server.js" ]

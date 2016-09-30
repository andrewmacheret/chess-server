FROM mhart/alpine-node 
WORKDIR /app

# download and install glibc
ENV GLIBC_VERSION 2.23-r3
RUN apk add --update curl && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  apk add glibc.apk && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf &&\
  apk del curl &&\
  rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*

# install node, bash, expect
RUN apk add --update nodejs bash expect &&\
  rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*

WORKDIR /app

# download stockfish
RUN apk add --update openssl &&\
  wget 'https://stockfish.s3.amazonaws.com/stockfish-6-linux.zip' &&\
  unzip stockfish-6-linux.zip &&\
  rm stockfish-6-linux.zip &&\
  rm -r __MACOSX/ &&\
  apk del openssl &&\
  rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*

ADD app .

# Expose node port
EXPOSE 80

# Run node
CMD [ "node", "chess-server.js" ]

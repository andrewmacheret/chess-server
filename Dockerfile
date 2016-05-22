FROM ubuntu:latest

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y nodejs npm
RUN apt-get install -y wget unzip expect

# Add user noder and go into home directory
RUN useradd -m -s /usr/bin/false noder
ADD . /home/noder/server
WORKDIR /home/noder/server

# Setup gtfs
RUN ./setup.sh

# Expose node port
EXPOSE 8103

# Run node
CMD /usr/bin/nodejs /home/noder/server/chess-server.js


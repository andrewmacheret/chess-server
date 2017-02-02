FROM mhart/alpine-node 

WORKDIR /app

ADD app .

# Expose node port
EXPOSE 80

# Run node
CMD [ "node", "chess-server.js" ]

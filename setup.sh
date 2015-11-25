#!/bin/bash

# setup node packages
npm install express
npm install compression

# download stockfish
wget 'https://stockfish.s3.amazonaws.com/stockfish-6-linux.zip'
unzip stockfish-6-linux.zip 
rm stockfish-6-linux.zip 
rm -rf __MACOSX/



#!/bin/bash

# download stockfish
wget 'https://stockfish.s3.amazonaws.com/stockfish-6-linux.zip'

# unzip it
unzip stockfish-6-linux.zip

# remove the zip
rm stockfish-6-linux.zip

# remove the unnecessary __MACOSX directory
rm -r __MACOSX/

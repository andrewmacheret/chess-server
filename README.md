# chess-server

[![Build Status](https://travis-ci.org/andrewmacheret/chess-server.svg?branch=master)](https://travis-ci.org/andrewmacheret/chess-server) [![Docker Stars](https://img.shields.io/docker/stars/andrewmacheret/chess-server.svg)](https://hub.docker.com/r/andrewmacheret/chess-server/) [![Docker Pulls](https://img.shields.io/docker/pulls/andrewmacheret/chess-server.svg)](https://hub.docker.com/r/andrewmacheret/chess-server/) [![License](https://img.shields.io/badge/license-MIT-lightgray.svg)](https://github.com/andrewmacheret/chess-server/blob/master/LICENSE.md)

A simple REST wrapper around the [Stockfish chess engine](https://stockfishchess.org/) to find the best move given a chess position in [FEN notation](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) and the requested move depth.

Intended to be used by [andrewmacheret/chess](https://github.com/andrewmacheret/chess).

Usage:

```bash
docker pull andrewmacheret/chess-server

docker up -d -p 9999:80 andrewmacheret/chess-server

curl 'http://localhost:9999/moves/?fen=rnbqkbnr%2Fpppppppp%2F8%2F8%2F8%2F8%2FPPPPPPPP%2FRNBQKBNR+w+KQkq+-+0+1&depth=15'
```

Note that forward slashes (`/`) in the FEN need to be escaped as `%2F`.

You should get a response that looks like `{"bestmove":"g1f3","depth":15}` (the actual best move may differ).

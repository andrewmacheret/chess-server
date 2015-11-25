A simple REST wrapper around the stockfish chess engine to find the best move given a chess position in FEN notation and the requested move depth.

Intended to be used by [andrewmacheret/chess](https://github.com/andrewmacheret/chess).

Prereqs:
* Node.js on a linux server

Installation steps:
* `git clone <clone url>`
* `cd chess-server/`
* `./setup.sh`
* modify the port in `settings.json` as needed
* `node chess-server.js`

Test it:
* `curl 'http://localhost:8103/moves/?fen=rnbqkbnr%2Fpppppppp%2F8%2F8%2F8%2F8%2FPPPPPPPP%2FRNBQKBNR+w+KQkq+-+0+1&depth=15'`
* You should get a response that looks like `{"bestmove":"g1f3","depth":15}`


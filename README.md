# chess-server

A simple REST wrapper around the [Stockfish chess engine](https://stockfishchess.org/) to find the best move given a chess position in [FEN notation](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) and the requested move depth.

Intended to be used by [andrewmacheret/chess](https://github.com/andrewmacheret/chess).

Prereqs:
* [Node.js](https://nodejs.org/) on a linux server

Installation steps:
* `git clone <clone url>`
* `cd chess-server/`
* `./setup.sh`
* Modify the port in `settings.json` as needed
* `node chess-server.js`

Test it:
* `curl 'http://localhost:8103/moves/?fen=rnbqkbnr%2Fpppppppp%2F8%2F8%2F8%2F8%2FPPPPPPPP%2FRNBQKBNR+w+KQkq+-+0+1&depth=15'`.
 * This requests an opening move for white from the standard starting position.
 * Note that forward slashes (`/`) in the FEN need to be escaped as `%2F`.
 * You should get a response that looks like `{"bestmove":"g1f3","depth":15}` (the chosen best move may differ).



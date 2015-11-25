#!/bin/bash

fen="$1"
depth="$2"

error() {
  echo "ERROR: $1" 1>&2
  exit 1
}

[[ $fen != "" ]] || error "A position in FEN notation is required"
[[ $depth != "" ]] || depth=15

binary='stockfish-6-linux/Linux/stockfish_6_x64'
position="position fen $fen"
go="go maxdepth $depth"
timeout=20000

#fen='rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
#depth='15'

output="$(
  expect <<DONE
    spawn "$binary"
    match_max 100000
    expect "Stockfish*"
    send -- "$position\r"
    send -- "$go\r"
    expect "bestmove *"
    send -- "quit\r"
    expect eof
DONE
)"

bestmove="$( echo "$output" | tail -n 2 | head -n 1 | grep '^bestmove ' | tr -d '\r' | tr -d '\n' | awk '{print $2}' )"
[[ $bestmove != "" ]] || error "The underlying chess engine did not output a best move"

echo -n "$bestmove"



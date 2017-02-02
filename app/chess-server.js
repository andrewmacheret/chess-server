var express = require('express');
var compression = require('compression');
//var apicache = require('apicache').options({ debug: true }).middleware;
//var bodyParser = require('body-parser');
var app = express();
var path = require('path');
var urlencode = require('urlencode');
//app.use(bodyParser.urlencoded({extended: true}));

var stockfish = require("stockfish");

var fs = require('fs');
var settings = JSON.parse(fs.readFileSync(path.resolve(__dirname, './settings.json'), 'utf8'));

function getBestMove(options, callback) {
  var instance = stockfish();

  // set the callback for each message
  instance.onmessage = function(event) {
    var message = event.data || event;
    
    console.log(typeof event, event);
    
    if (typeof message === 'string') {
      //'bestmove g1f3 ponder g8f6'
      var split = message.split(/ +/);
      if (split[0] == 'bestmove') {
        callback(split[1]);
      }
    }
  };

  // set the fen, then perform the search with the given depth
  instance.postMessage('position fen ' + options.fen);
  instance.postMessage('go depth ' + options.depth);
}

//app.use(compression());
app.use(compression({
  threshold : 0, // or whatever you want the lower threshold to be
  filter    : function(req, res) {
    return true;
  }
}));

console.log('registering /');
app.get('/' /*, apicache('5 minutes')*/, function(req, res) {
  console.log('GET ' + req.originalUrl);
  //res.setHeader('Access-Control-Allow-Origin', 'https://andrewmacheret.com');

  res.set({
    'Content-Type': 'application/json'
  });

  res.status(200);
  res.send({"apis": ['/moves']});
});

console.log('registering /moves');
app.get('/moves' /*, apicache('5 minutes')*/, function(req, res) {
  console.log('GET ' + req.originalUrl);
  //res.setHeader('Access-Control-Allow-Origin', 'https://andrewmacheret.com');

  res.set({
    'Content-Type': 'application/json'
  });

  var fen = req.query.fen;
  if (!fen) {
    res.status(500);
    res.send({
      "error": "Parameter 'fen' is required.",
      "suggestion": '/moves?fen=' + urlencode('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1') + '&depth=15'
    });
    return;
  }

  var depth = parseInt(req.query.depth, 10) || 15;
  depth = Math.min(depth, 20);

  getBestMove({fen: fen, depth: depth}, function(moveResponse, err) {
    if (err) {
      console.error(err);
      res.status(500);
      res.send({"error": err});
      return;
    }

    res.status(200);
    res.send({"bestmove": moveResponse, "depth": depth});
  });

  //res.send(JSON.stringify({apis: apis}, 0, 4));
});

var port = settings.port;
app.listen(port);
console.log('listening on ' + port);


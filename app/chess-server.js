var express = require('express');
var compression = require('compression');
//var apicache = require('apicache').options({ debug: true }).middleware;
//var bodyParser = require('body-parser');
var app = express();
var spawn = require('child_process').spawn;
var path = require('path');
var urlencode = require('urlencode');
//app.use(bodyParser.urlencoded({extended: true}));

var fs = require('fs');
var settings = JSON.parse(fs.readFileSync(path.resolve(__dirname, './settings.json'), 'utf8'));

var move_binary = path.resolve(__dirname, './move.sh');

function run(command, args, callback) {
  console.log(command, args);
  var child = spawn(command, args);
  var response = '';
  var error = '';
  child.stdout.on('data', function(buffer) {
    response += buffer.toString();
  });
  child.stderr.on('data', function(buffer) {
    error += buffer.toString();
  });
  child.on('close', function(code) {
    if (code === 0) {
      callback(response);
    } else {
      callback(null, error);
    }
  });
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
  res.setHeader('Access-Control-Allow-Origin', 'andrewmacheret.com');

  res.set({
    'Content-Type': 'application/json'
  });

  res.status(200);
  res.send({"apis": ['/moves']});
});

console.log('registering /moves');
app.get('/moves' /*, apicache('5 minutes')*/, function(req, res) {
  console.log('GET ' + req.originalUrl);
  res.setHeader('Access-Control-Allow-Origin', 'andrewmacheret.com');

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

  run(move_binary, [fen, depth.toString()], function(moveResponse, err) {
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


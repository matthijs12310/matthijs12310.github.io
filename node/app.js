const http = require('http');
const fs = require('fs');


http.createServer(function (req, res) {
  res.writeHead(200);
  res.end("This is only setup for the mc server :)");
  console.log("WOWOWOWOWWO");
}).listen(8080);
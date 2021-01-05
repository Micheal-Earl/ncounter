"use strict";

let express = require('express');
let app = express();
let server = require('http').createServer(app);
let io = require('socket.io')(server);
let players = {};

// Set up shorcut routes for other files in the project
app.use('/css', express.static(__dirname + '/css'));
app.use('/src', express.static(__dirname + '/src'));
app.use('/assets', express.static(__dirname + '/assets'));

app.get('/', function(request, response) {
    response.sendFile(__dirname+'/index.html');
});

// Listen on port 8080
server.listen(8080, function() {
    console.log('Listening on ' + server.address().port);
});

// Socket io stuff

io.on('connection', function (socket) {
    console.log('a user connected');

    players[socket.id] = {
        
    };

    socket.on('disconnect', function () {
        console.log('user disconnected');
    });
});
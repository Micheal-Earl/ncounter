class Client {
    static socket = io.connect();

    static askNewPlayer() {
        this.socket.emit('newplayer');
    }

    static sendClick(x, y) {
        this.socket.emit('click', {x:x, y:y});
    }
}

Client.socket.on('newplayer', function(data) {
    Game.addNewPlayer(data.id,data.x,data.y);
});

Client.socket.on('allplayers', function(data) {
    console.log(data);
    for(var i = 0; i < data.length; i++) {
        Game.addNewPlayer(data[i].id,data[i].x,data[i].y);
    }
});

Client.socket.on('remove', function(id) {
    Game.removePlayer(id);
});

Client.socket.on('move',function(data){
    Game.movePlayer(data.id,data.x,data.y);
});
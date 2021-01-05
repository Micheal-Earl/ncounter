"use strict";

class Client {
    static testVar = "woo";

    constructor() {
        this.socket = io.connect();
    }

    static askNewPlayer() {
        this.socket.emit('newplayer');
    }

    static sendClick(x, y) {
        this.socket.emit('click', {x:x, y:y});
    }
}
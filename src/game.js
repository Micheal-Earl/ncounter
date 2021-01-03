"use strict";

let config = {
    type: Phaser.AUTO,
    width: 800,
    height: 600,
    physics: {
        default: 'arcade',
        arcade: {
            gravity: { y: 300 },
            debug: false
        }
    },
    scene: {
        init: init,
        preload: preload,
        create: create,
        update: update
    },
    render: {
        antialiasGL: false,
        pixelArt: true
    }
};


let game = new Phaser.Game(config);
let controls;
let playerMap;

function init() {
    this.disableVisibilityChange = true;
}

function preload() {
    // Map
    this.load.image('tiles', '/assets/2DMagicLandsDungeon/mainlevbuild.png');
    this.load.tilemapTiledJSON('map', '/assets/world.json');

    // Other
    this.load.image('player', '/assets/ScifiCharacter/idle.png');
}

function create() {
    // Map stuff
    const map = this.make.tilemap({key: 'map'});
    console.log(map);
    const tileset = map.addTilesetImage('2DMagicLandsDungeon', 'tiles');
    const floor = map.createLayer(0, tileset, 0, 0);
    const wall = map.createLayer(1, tileset, 0, 0);

    // socket io stuff
    Client.askNewPlayer();
    playerMap = {};
    floor.events.onInputUp.add(getCoordinates, this);
    floor.inputEnabled = true;

    // Controls
    this.cameras.main.setBounds(0, 0, map.widthInPixels, map.heightInPixels);
    var cursors = this.input.keyboard.createCursorKeys();
    var controlConfig = {
        camera: this.cameras.main,
        left: cursors.left,
        right: cursors.right,
        up: cursors.up,
        down: cursors.down,
        speed: 0.5
    };
    controls = new Phaser.Cameras.Controls.FixedKeyControl(controlConfig);
}

function update(time, delta) {
    controls.update(delta);
}

function addNewPlayer(id, x, y) {
    playerMap[id] = game.add.sprite(x, y, 'player');
}

function removePlayer(id) {
    playerMap[id].destroy();
    delete Game.playerMap[id];
};

function getCoordinates(layer, pointer) {
    Client.sendClick(pointer.worldX,pointer.worldY);
};

function movePlayer(id, x, y) {
    var player = playerMap[id];
    var distance = Phaser.Math.distance(player.x,player.y,x,y);
    var duration = distance*10;
    var tween = game.add.tween(player);
    tween.to({x:x,y:y}, duration);
    tween.start();
};
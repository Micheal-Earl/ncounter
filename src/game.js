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
let mouseCoordText;

function preload() {
    // Map
    this.load.image('tiles', '/assets/2DMagicLandsDungeon/mainlevbuild.png');
    this.load.tilemapTiledJSON('map', '/assets/world.json');
    // Other
    this.load.image('player', '/assets/ScifiCharacter/idle.png');
}

function create() {
    // Socket io?
    // Make a new client object
    let client = new Client();
    // Map stuff
    const map = this.make.tilemap({key: 'map'});
    const tileset = map.addTilesetImage('2DMagicLandsDungeon', 'tiles');
    const floor = map.createLayer(0, tileset, 0, 0);
    const wall = map.createLayer(1, tileset, 0, 0);
    
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

    // Text
    mouseCoordText = this.add.text(0, 0, 'x: ' + this.input.mousePointer.worldX + ' y: ' + this.input.mousePointer.worldY)
    mouseCoordText.setScrollFactor(0); // this keeps the text fixed to the camera
}

function update(time, delta) {
    controls.update(delta);
    mouseCoordText.setText('x: ' + this.input.mousePointer.worldX + ' y: ' + this.input.mousePointer.worldY);
    //console.log('x: ' + this.input.mousePointer.x + ' y: ' + this.input.mousePointer.y);
}
// Generated by CoffeeScript 1.9.0
var Punyverse, camera1, camera2, config, engine, punyverse,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __hasProp = {}.hasOwnProperty;

THREEx.Planets.baseURL = 'bower_components/threex.planets/';

THREEx.SpaceShips.baseUrl = 'bower_components/threex.spaceships/';

THREEx.TextureCube.baseUrl = "";

config = Config.get();

config.fillWindow();

engine = new Engine3D();

engine.renderer.setClearColor('black', 1);

camera1 = new THREE.PerspectiveCamera(60, config.width / config.height, 0.1, 10000);

camera1.position.y = 1;

camera1.position.z = 4;

camera2 = new THREE.PerspectiveCamera(60, config.width / config.height, 0.1, 10000);

engine.setCamera(camera1);

THREE.MOUSE = {
  LEFT: 0,
  MIDDLE: 1,
  RIGHT: 2
};

Punyverse = (function(_super) {
  __extends(Punyverse, _super);

  function Punyverse() {
    var light, mesh;
    Punyverse.__super__.constructor.call(this);
    this.loaded = false;
    this.timeSpeed = 1;
    this.currentTime = Date.now();
    light = new THREE.AmbientLight(0x888888);
    this.scene.add(light);
    this.scene.add(light);
    light = new THREE.DirectionalLight(0xcccccc, 1);
    light.position.set(5, 5, 5);
    this.scene.add(light);
    light.castShadow = true;
    light.shadowCameraNear = 0.01;
    light.shadowCameraFar = 15;
    light.shadowCameraFov = 45;
    light.shadowCameraLeft = -1;
    light.shadowCameraRight = 1;
    light.shadowCameraTop = 1;
    light.shadowCameraBottom = -1;
    light.shadowBias = 0.001;
    light.shadowDarkness = 0.2;
    light.shadowMapWidth = 1024;
    light.shadowMapHeight = 1024;
    mesh = THREEx.createSkymap('skybox');
    this.scene.add(mesh);
    this.earth = new Planet('earth', 10, 0, 'earthmap1k', 'cyan', 0);
    this.scene.add(this.earth.mesh);
    this.moon = new Planet('moon', 3, 25, 'moonmap1k', 'white', 0.001);
    this.moon.mesh.rotation.y = this.currentTime * this.moon.speed;
    this.scene.add(this.moon.mesh);
    this.mercury = new Planet('mercury', 0.5, 30, 'mercurymap', 'red', 0.003);
    this.mercury.mesh.rotation.y = this.currentTime * this.mercury.speed;
    this.scene.add(this.mercury.mesh);
    this.venus = new Planet('venus', 0.5, 45, 'venusmap', 'red', 0.004);
    this.venus.mesh.rotation.y = this.currentTime * this.venus.speed;
    this.scene.add(this.venus.mesh);
    this.sun = new Planet('sun', 40, 100, 'sunmap', 'yellow', 0.0005);
    this.sun.setDateRotation(this.currentTime);
    this.scene.add(this.sun.mesh);
    this.jupiter = new Planet('jupiter', 30, 200, 'jupitermap', 'orange', 0.006);
    this.jupiter.mesh.rotation.y = this.currentTime * this.jupiter.speed;
    this.scene.add(this.jupiter.mesh);
    this.saturn = new Planet('saturn', 20, 300, 'saturnmap', 'brown', 0.003);
    this.saturn.mesh.rotation.y = this.currentTime * this.saturn.speed;
    this.scene.add(this.saturn.mesh);
    THREEx.SpaceShips.loadSpaceFighter01((function(_this) {
      return function(object3d) {
        var f1, f2, f3, rX, ship, shipCtrl;
        _this.ship = new Ship('protoss', object3d);
        _this.ship.mesh.position.z = 100;
        _this.scene.add(_this.ship.mesh);
        _this.ship.mesh.add(camera1);
        _this.controls = new THREE.OrbitControls(camera1, engine.renderer.domElement);
        _this.controls.noPan = true;
        _this.controls.noKeys = true;
        _this.gui = new dat.GUI();
        shipCtrl = {
          rotation: {
            x: _this.ship.mesh.rotation.x,
            y: _this.ship.mesh.rotation.y,
            z: _this.ship.mesh.rotation.z
          }
        };
        f1 = _this.gui.addFolder('Dashboard');
        f1.add(_this.ship, 'name');
        f1.add(_this.ship.mesh.position, 'x').listen();
        f1.add(_this.ship.mesh.position, 'y').listen();
        f1.add(_this.ship.mesh.position, 'z').listen();
        f1.open();
        f2 = _this.gui.addFolder('Location');
        f2.add(_this.ship, 'acceleration', -4, 14);
        rX = f2.add(shipCtrl.rotation, 'x', -Math.PI * 2, Math.PI * 2);
        rX.listen();
        ship = _this.ship;
        rX.onFinishChange(function(value) {
          var originalX, tween;
          originalX = _this.ship.mesh.rotation.x;
          tween = new TWEEN.Tween({
            x: originalX
          }).to({
            x: value
          }, 1000).easing(TWEEN.Easing.Cubic.In);
          tween.onUpdate(function() {
            return ship.mesh.rotation.x = this.x;
          }).start();
          return tween.onComplete(function() {});
        });
        f2.add(_this.ship.mesh.rotation, 'y', -Math.PI * 4, Math.PI * 4);
        f2.add(_this.ship.mesh.rotation, 'z', -Math.PI * 4, Math.PI * 4);
        f2.open();
        f3 = _this.gui.addFolder('Time');
        f3.add(_this, 'timeSpeed');
        f3.add(_this, 'realCurrentTime').listen();
        f3.add(_this, 'currentTime').listen();
        f3.open();
        _this.loaded = true;
      };
    })(this));
    this.bullets = [];
    this.axes = new CoffeeAxes(10000000);
    this.scene.add(this.axes.mesh);
  }

  Punyverse.prototype.tick = function(tpf) {
    var bullet, _i, _len, _ref;
    this.tpf = tpf;
    this.realCurrentTime = Date.now();
    this.currentTime += tpf * 1000 * this.timeSpeed;
    this.earth.animateClouds(tpf * this.timeSpeed);
    this.moon.setDateRotation(this.currentTime);
    this.mercury.setDateRotation(this.currentTime);
    this.venus.setDateRotation(this.currentTime);
    this.sun.setDateRotation(this.currentTime);
    this.jupiter.setDateRotation(this.currentTime);
    this.saturn.setDateRotation(this.currentTime);
    if (!this.loaded) {
      return;
    }
    this.ship.rightDetonation.visible = this.ship.acceleration > 0;
    this.ship.leftDetonation.visible = this.ship.acceleration > 0;
    _ref = this.bullets;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      bullet = _ref[_i];
      bullet.translateZ(6 * tpf * this.timeSpeed);
    }
    return this.ship.mesh.translateZ(this.ship.acceleration * tpf * this.timeSpeed);
  };

  Punyverse.prototype.doMouseEvent = function(event, raycaster) {};

  Punyverse.prototype.doKeyboardEvent = function(event) {};

  return Punyverse;

})(BaseScene);

punyverse = new Punyverse();

engine.addScene(punyverse);

engine.render();
// Generated by CoffeeScript 1.9.0
var Engine2D,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Engine2D = (function() {
  function Engine2D(canvasId, width, height) {
    this.render = __bind(this.render, this);
    this.onDocumentKeyboardEvent = __bind(this.onDocumentKeyboardEvent, this);
    this.onDocumentMouseEvent = __bind(this.onDocumentMouseEvent, this);
    this.sceneManager = SceneManager.get();
    this.time = void 0;
    this.width = width;
    this.height = height;
    this.backgroundColor = '#FFFFFF';
    this.canvasId = canvasId;
    document.addEventListener("mousedown", this.onDocumentMouseEvent, false);
    document.addEventListener("mouseup", this.onDocumentMouseEvent, false);
    document.addEventListener("mousemove", this.onDocumentMouseEvent, false);
    document.addEventListener("keydown", this.onDocumentKeyboardEvent, false);
    document.addEventListener("keyup", this.onDocumentKeyboardEvent, false);
    this.canvas = document.getElementById(this.canvasId);
    this.canvas.width = width;
    this.canvas.height = height;
    this.context = this.canvas.getContext("2d");
  }

  Engine2D.prototype.onDocumentMouseEvent = function(event) {
    return this.sceneManager.currentScene().doMouseEvent(event);
  };

  Engine2D.prototype.onDocumentKeyboardEvent = function(event) {
    return this.sceneManager.currentScene().doKeyboardEvent(event);
  };

  Engine2D.prototype.clear = function() {
    this.context.fillStyle = this.backgroundColor;
    return this.context.fillRect(0, 0, this.width, this.height);
  };

  Engine2D.prototype.render = function() {
    var now, tpf;
    requestAnimationFrame(this.render);
    now = new Date().getTime();
    tpf = (now - (this.time || now)) / 1000;
    this.time = now;
    return this.sceneManager.tick(tpf);
  };

  return Engine2D;

})();
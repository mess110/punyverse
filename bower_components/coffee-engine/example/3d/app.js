// Generated by CoffeeScript 1.9.0
var LoadingScene, engine, loadingScene,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __hasProp = {}.hasOwnProperty;

engine = new Engine3D();

LoadingScene = (function(_super) {
  __extends(LoadingScene, _super);

  function LoadingScene() {
    LoadingScene.__super__.constructor.call(this);
  }

  LoadingScene.prototype.tick = function(tpf) {};

  LoadingScene.prototype.doMouseEvent = function(event, raycaster) {};

  LoadingScene.prototype.doKeyboardEvent = function(event) {};

  return LoadingScene;

})(BaseScene);

loadingScene = new LoadingScene();

engine.addScene(loadingScene);

engine.render();
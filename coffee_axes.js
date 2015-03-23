// Generated by CoffeeScript 1.9.0
var CoffeeAxes,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __hasProp = {}.hasOwnProperty;

CoffeeAxes = (function(_super) {
  __extends(CoffeeAxes, _super);

  function CoffeeAxes(length) {
    CoffeeAxes.__super__.constructor.call(this);
    this.mesh = this.buildAxes(length);
  }

  CoffeeAxes.prototype.buildAxes = function(length) {
    var axes;
    axes = new THREE.Object3D;
    axes.add(this.buildAxis(new THREE.Vector3(0, 0, 0), new THREE.Vector3(length, 0, 0), 0xFF0000, false));
    axes.add(this.buildAxis(new THREE.Vector3(0, 0, 0), new THREE.Vector3(-length, 0, 0), 0xFF0000, true));
    axes.add(this.buildAxis(new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, length, 0), 0x00FF00, false));
    axes.add(this.buildAxis(new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, -length, 0), 0x00FF00, true));
    axes.add(this.buildAxis(new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 0, length), 0x0000FF, false));
    axes.add(this.buildAxis(new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 0, -length), 0x0000FF, true));
    return axes;
  };

  CoffeeAxes.prototype.buildAxis = function(src, dst, colorHex, dashed) {
    var axis, geom, mat;
    geom = new THREE.Geometry;
    mat = null;
    if (dashed) {
      mat = new THREE.LineDashedMaterial({
        linewidth: 3,
        color: colorHex,
        dashSize: 3,
        transparent: true,
        opacity: 0.2,
        gapSize: 3
      });
    } else {
      mat = new THREE.LineBasicMaterial({
        linewidth: 3,
        transparent: true,
        opacity: 0.2,
        color: colorHex
      });
    }
    geom.vertices.push(src.clone());
    geom.vertices.push(dst.clone());
    geom.computeLineDistances();
    axis = new THREE.Line(geom, mat, THREE.LinePieces);
    return axis;
  };

  return CoffeeAxes;

})(BaseModel);
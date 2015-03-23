// Generated by CoffeeScript 1.9.0
var Polygon;

Polygon = (function() {
  function Polygon(points) {
    this.points = points;
    this.position = new Point(0, 0);
    this.color = "green";
  }

  Polygon.prototype.draw = function(context) {
    var i, l, oldWidth, v, worldPoints;
    oldWidth = context.lineWidth;
    context.beginPath();
    context.lineWidth = "5";
    context.strokeStyle = this.color;
    context.fillStyle = this.color;
    i = 0;
    l = this.points.length;
    worldPoints = this.getWorldPoints();
    while (i < l) {
      v = worldPoints[i];
      if (i === 0) {
        context.moveTo(v.x, v.y);
      }
      context.lineTo(v.x, v.y);
      context.stroke();
      context.fill();
      i++;
    }
    context.lineWidth = oldWidth;
  };

  Polygon.prototype.intersects = function(other) {
    var intersectionFound, point, _i, _j, _len, _len1, _ref, _ref1;
    intersectionFound = false;
    _ref = this.getWorldPoints();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      point = _ref[_i];
      if (point.isInside(other)) {
        intersectionFound = true;
        break;
      }
    }
    if (!intersectionFound) {
      _ref1 = other.getWorldPoints();
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        point = _ref1[_j];
        if (point.isInside(this)) {
          intersectionFound = true;
          break;
        }
      }
    }
    return intersectionFound;
  };

  Polygon.prototype.getWorldPoints = function() {
    var point, worldPoints, _i, _len, _ref;
    worldPoints = [];
    _ref = this.points;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      point = _ref[_i];
      worldPoints.push(new Point(point.x + this.position.x, point.y + this.position.y));
    }
    return worldPoints;
  };

  Polygon.prototype.getPolygonCenter = function() {
    var f, i, j, nPts, p1, p2, twicearea, x, y;
    twicearea = 0;
    x = 0;
    y = 0;
    nPts = this.points.length;
    p1 = void 0;
    p2 = void 0;
    f = void 0;
    i = 0;
    j = nPts - 1;
    while (i < nPts) {
      p1 = this.points[i];
      p2 = this.points[j];
      f = p1.x * p2.y - p2.x * p1.y;
      twicearea += f;
      x += (p1.x + p2.x) * f;
      y += (p1.y + p2.y) * f;
      j = i++;
    }
    f = twicearea * 3;
    return new Point(x / f + this.position.x, y / f + this.position.y);
  };

  return Polygon;

})();
// Generated by CoffeeScript 1.9.0
var Utils;

Utils = (function() {
  function Utils() {}

  Utils.rgbToHex = function(r, g, b) {
    if (r > 255 || g > 255 || b > 255) {
      throw "Invalid color component";
    }
    return ((r << 16) | (g << 8) | b).toString(16);
  };

  return Utils;

})();
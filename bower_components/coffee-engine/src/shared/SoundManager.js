// Generated by CoffeeScript 1.9.0
var SoundManager;

SoundManager = (function() {
  var PrivateClass, instance;

  function SoundManager() {}

  instance = null;

  PrivateClass = (function() {
    function PrivateClass() {
      this.sounds = {};
    }

    PrivateClass.prototype.add = function(key, url) {
      var audio, source;
      audio = document.createElement('audio');
      source = document.createElement('source');
      source.src = url;
      audio.appendChild(source);
      return this.sounds[key] = audio;
    };

    PrivateClass.prototype.play = function(key) {
      if (key in this.sounds) {
        return this.sounds[key].play();
      } else {
        return console.log('Sound with key: ' + key + ' not found!');
      }
    };

    PrivateClass.prototype.updateGlobalVolume = function(i) {
      var key;
      if (i < 0) {
        i = 0;
      }
      if (i > 1) {
        i = 1;
      }
      for (key in this.sounds) {
        this.sounds[key].volume = i;
      }
      return i;
    };

    return PrivateClass;

  })();

  SoundManager.get = function() {
    return instance != null ? instance : instance = new PrivateClass();
  };

  return SoundManager;

})();
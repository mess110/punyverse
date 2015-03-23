// Generated by CoffeeScript 1.9.0

/*
@author mrdoob / http://mrdoob.com/
@author marklundin / http://mark-lundin.com/
@author alteredq / http://alteredqualia.com/
 */
THREE.AnaglyphEffect = function(renderer, width, height) {
  var distanceBetweenGlyhs, eyeLeft, eyeRight, focalLength, mesh, _aspect, _camera, _cameraL, _cameraR, _far, _fov, _material, _near, _params, _renderTargetL, _renderTargetR, _scene;
  eyeRight = new THREE.Matrix4();
  eyeLeft = new THREE.Matrix4();
  distanceBetweenGlyhs = 30;
  focalLength = 125;
  _aspect = void 0;
  _near = void 0;
  _far = void 0;
  _fov = void 0;
  _cameraL = new THREE.PerspectiveCamera();
  _cameraL.matrixAutoUpdate = false;
  _cameraR = new THREE.PerspectiveCamera();
  _cameraR.matrixAutoUpdate = false;
  _camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
  _scene = new THREE.Scene();
  _params = {
    minFilter: THREE.LinearFilter,
    magFilter: THREE.NearestFilter,
    format: THREE.RGBAFormat
  };
  if (width === undefined) {
    width = 512;
  }
  if (height === undefined) {
    height = 512;
  }
  _renderTargetL = new THREE.WebGLRenderTarget(width, height, _params);
  _renderTargetR = new THREE.WebGLRenderTarget(width, height, _params);
  _material = new THREE.ShaderMaterial({
    uniforms: {
      mapLeft: {
        type: "t",
        value: _renderTargetL
      },
      mapRight: {
        type: "t",
        value: _renderTargetR
      }
    },
    vertexShader: ["varying vec2 vUv;", "void main() {", "\tvUv = vec2( uv.x, uv.y );", "\tgl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );", "}"].join("\n"),
    fragmentShader: ["uniform sampler2D mapLeft;", "uniform sampler2D mapRight;", "varying vec2 vUv;", "void main() {", "\tvec4 colorL, colorR;", "\tvec2 uv = vUv;", "\tcolorL = texture2D( mapLeft, uv );", "\tcolorR = texture2D( mapRight, uv );", "\tgl_FragColor = vec4( colorL.g * 0.7 + colorL.b * 0.3, colorR.g, colorR.b, colorL.a + colorR.a ) * 1.1;", "}"].join("\n")
  });
  mesh = new THREE.Mesh(new THREE.PlaneGeometry(2, 2), _material);
  _scene.add(mesh);
  this.setSize = function(width, height) {
    _renderTargetL = new THREE.WebGLRenderTarget(width, height, _params);
    _renderTargetR = new THREE.WebGLRenderTarget(width, height, _params);
    _material.uniforms["mapLeft"].value = _renderTargetL;
    _material.uniforms["mapRight"].value = _renderTargetR;
    return renderer.setSize(width, height);
  };
  this.setDistanceBetweenGlyphs = function(dist) {
    return distanceBetweenGlyhs = dist;
  };
  this.render = function(scene, camera) {
    var eyeSep, eyeSepOnProjection, hasCameraChanged, projectionMatrix, xmax, xmin, ymax;
    scene.updateMatrixWorld();
    if (camera.parent === undefined) {
      camera.updateMatrixWorld();
    }
    hasCameraChanged = (_aspect !== camera.aspect) || (_near !== camera.near) || (_far !== camera.far) || (_fov !== camera.fov);
    if (hasCameraChanged) {
      _aspect = camera.aspect;
      _near = camera.near;
      _far = camera.far;
      _fov = camera.fov;
      projectionMatrix = camera.projectionMatrix.clone();
      eyeSep = focalLength / distanceBetweenGlyhs * 0.5;
      eyeSepOnProjection = eyeSep * _near / focalLength;
      ymax = _near * Math.tan(THREE.Math.degToRad(_fov * 0.5));
      xmin = void 0;
      xmax = void 0;
      eyeRight.elements[12] = eyeSep;
      eyeLeft.elements[12] = -eyeSep;
      xmin = -ymax * _aspect + eyeSepOnProjection;
      xmax = ymax * _aspect + eyeSepOnProjection;
      projectionMatrix.elements[0] = 2 * _near / (xmax - xmin);
      projectionMatrix.elements[8] = (xmax + xmin) / (xmax - xmin);
      _cameraL.projectionMatrix.copy(projectionMatrix);
      xmin = -ymax * _aspect - eyeSepOnProjection;
      xmax = ymax * _aspect - eyeSepOnProjection;
      projectionMatrix.elements[0] = 2 * _near / (xmax - xmin);
      projectionMatrix.elements[8] = (xmax + xmin) / (xmax - xmin);
      _cameraR.projectionMatrix.copy(projectionMatrix);
    }
    _cameraL.matrixWorld.copy(camera.matrixWorld).multiply(eyeLeft);
    _cameraL.position.copy(camera.position);
    _cameraL.near = camera.near;
    _cameraL.far = camera.far;
    renderer.render(scene, _cameraL, _renderTargetL, true);
    _cameraR.matrixWorld.copy(camera.matrixWorld).multiply(eyeRight);
    _cameraR.position.copy(camera.position);
    _cameraR.near = camera.near;
    _cameraR.far = camera.far;
    renderer.render(scene, _cameraR, _renderTargetR, true);
    renderer.render(_scene, _camera);
  };
};
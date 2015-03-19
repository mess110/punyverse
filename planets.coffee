THREEx = THREEx or {}
THREEx.Planets = {}
THREEx.Planets.baseURL = 'bower_components/threex.planets/'
# from http://planetpixelemporium.com/

THREEx.Planets.createSun = ->
  geometry = new (THREE.SphereGeometry)(0.5, 32, 32)
  texture = THREE.ImageUtils.loadTexture(THREEx.Planets.baseURL + 'images/sunmap.jpg')
  material = new (THREE.MeshPhongMaterial)(
    map: texture
    bumpMap: texture
    bumpScale: 0.05)
  mesh = new (THREE.Mesh)(geometry, material)
  mesh

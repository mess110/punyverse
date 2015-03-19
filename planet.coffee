class Planet extends BaseModel
  constructor: (name, distanceFromOrigin, img, glowColorS) ->
    @mesh = new THREE.Object3D()

    geometry = new (THREE.SphereGeometry)(0.5, 32, 32)
    texture = THREE.ImageUtils.loadTexture(THREEx.Planets.baseURL + "images/#{img}.jpg")
    material = new (THREE.MeshPhongMaterial)(
      map: texture
      bumpMap: texture
      bumpScale: 0.05)
    @planet = new (THREE.Mesh)(geometry, material)
    @planet.position.x = distanceFromOrigin

    @mesh.add @planet

    glowColor= new THREE.Color(glowColorS)
    geometry = new (THREE.SphereGeometry)(0.5, 32, 32)
    geometry = @planet.geometry.clone()
    material = THREEx.createAtmosphereMaterial()
    material.uniforms.glowColor.value = glowColor
    @glow = new (THREE.Mesh)(geometry, material)
    @glow.scale.multiplyScalar 1.05
    @planet.add @glow

    @clouds = THREEx.Planets.createEarthCloud()
    @planet.add @clouds

    @ring = THREEx.Planets.createSaturnRing()
    @planet.add @ring

  animateClouds: (tpf) ->
    @clouds.rotation.y += 1/8 * tpf

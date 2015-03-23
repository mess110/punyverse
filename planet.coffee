class Planet extends BaseModel
  constructor: (name, radius, distanceFromOrigin, img, glowColorS, speed) ->
    @mesh = new THREE.Object3D()

    geometry = new (THREE.SphereGeometry)(radius, 32, 32)
    texture = THREE.ImageUtils.loadTexture(THREEx.Planets.baseURL + "images/#{img}.jpg")
    material = new (THREE.MeshPhongMaterial)(
      map: texture
      bumpMap: texture
      bumpScale: 0.05)
    @planet = new (THREE.Mesh)(geometry, material)
    @planet.position.x = distanceFromOrigin

    @mesh.add @planet

    glowColor= new THREE.Color(glowColorS)
    geometry = new (THREE.SphereGeometry)(radius, 32, 32)
    geometry = @planet.geometry.clone()
    material = THREEx.createAtmosphereMaterial()
    material.uniforms.glowColor.value = glowColor
    @glow = new (THREE.Mesh)(geometry, material)
    @glow.scale.multiplyScalar 1.05
    @planet.add @glow

    @clouds = THREEx.Planets.createEarthCloud()
    @clouds.geometry = new (THREE.SphereGeometry)(radius + 0.1, 32, 32)
    @planet.add @clouds

    @ring = THREEx.Planets.createSaturnRing()
    @ring.geometry = new THREEx.Planets._RingGeometry(1.55 * radius, 1.75 * radius, 64)

    @planet.add @ring
    @speed = speed

  setDateRotation: (time) ->
    @mesh.rotation.y = time * @speed / 100

  animateClouds: (tpf) ->
    @clouds.rotation.y += 1/8 * tpf

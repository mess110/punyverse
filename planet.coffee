class Cloud extends BaseModel
  constructor: (radius) ->
    @mesh = THREEx.Planets.createEarthCloud()
    @mesh.geometry = new (THREE.SphereGeometry)(radius + 0.1, 32, 32)

class Ring extends BaseModel
  constructor: (radius) ->
    @mesh = THREEx.Planets.createSaturnRing()
    @mesh.geometry = new THREEx.Planets._RingGeometry(1.55 * radius, 1.75 * radius, 64)

class PlanetGlow extends BaseModel
  constructor: (radius, glowColorS, mesh) ->
    glowColor= new THREE.Color(glowColorS)
    geometry = new (THREE.SphereGeometry)(radius, 32, 32)
    geometry = mesh.geometry.clone()
    material = THREEx.createAtmosphereMaterial()
    material.uniforms.glowColor.value = glowColor
    @mesh = new (THREE.Mesh)(geometry, material)
    @mesh.scale.multiplyScalar 1.05

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

    @glow = new PlanetGlow(radius, glowColorS, @planet)
    @glow.setVisible(false)
    @planet.add @glow.mesh

    @clouds = new Cloud(radius)
    @clouds.setVisible(false)
    @planet.add @clouds.mesh

    @ring = new Ring(radius)
    @ring.setVisible(false)
    @planet.add @ring.mesh

    @speed = speed

  setDateRotation: (time) ->
    @mesh.rotation.y = time * @speed / 100

  animateClouds: (tpf) ->
    @clouds.mesh.rotation.y += 1/8 * tpf

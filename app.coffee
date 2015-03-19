THREEx.Planets.baseURL = '/bower_components/threex.planets/'
THREEx.SpaceShips.baseUrl = '/bower_components/threex.spaceships/'

config = Config.get()
config.fillWindow()

engine = new Engine3D()
engine.renderer.setClearColor('black', 1)

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

class Punyverse extends BaseScene
  constructor: ->
    super()

    light = new (THREE.AmbientLight)(0x888888)
    @scene.add light

    @scene.add( light )
    light = new (THREE.DirectionalLight)(0xcccccc, 1)
    light.position.set 5, 5, 5
    @scene.add light
    light.castShadow = true
    light.shadowCameraNear = 0.01
    light.shadowCameraFar = 15
    light.shadowCameraFov = 45
    light.shadowCameraLeft = -1
    light.shadowCameraRight = 1
    light.shadowCameraTop = 1
    light.shadowCameraBottom = -1
    # light.shadowCameraVisible	= true
    light.shadowBias = 0.001
    light.shadowDarkness = 0.2
    light.shadowMapWidth = 1024
    light.shadowMapHeight = 1024

    mesh = THREEx.createSkymap('skybox')
    @scene.add mesh

    @earth = new Planet('earth', 0, 'earthmap1k', 'cyan')
    @scene.add @earth.mesh

    @moon = new Planet('moon', 1.5, 'moonmap1k', 'white')
    @scene.add @moon.mesh

    @mercury = new Planet('mercury', 3, 'mercurymap', 'red')
    @scene.add @mercury.mesh

    @venus = new Planet('venus', 4.5, 'venusmap', 'red')
    @scene.add @venus.mesh

    @sun = new Planet('sun', 6, 'sunmap', 'yellow')
    @scene.add @sun.mesh

    @jupiter = new Planet('jupiter', 7.5, 'jupitermap', 'orange')
    @scene.add @jupiter.mesh

    @saturn= new Planet('saturn', 9, 'saturnmap', 'brown')
    @scene.add @saturn.mesh

    THREEx.SpaceShips.loadSpaceFighter01 (object3d) =>
      # object3d is the loaded spacefighter
      # now we add it to the scene
      object3d.position.z = 8
      @ship = object3d
      @scene.add object3d

      return

  tick: (tpf) ->
    @tpf = tpf

    @earth.animateClouds(tpf)
    @moon.mesh.rotation.z += 0.001
    @mercury.mesh.rotation.z += 0.003
    @venus.mesh.rotation.z += 0.004
    @sun.mesh.rotation.z -= 0.0005

  doMouseEvent: (event, raycaster) ->

  doKeyboardEvent: (event) ->
    return if event.type != 'keydown'

    #tween = new (TWEEN.Tween)({x: @ship.position.x}).to({ x: @ship.position.x + 3}, 2000).easing(TWEEN.Easing.Elastic.In)
    #tween.onUpdate(->
      #punyverse.ship.position.x = @x
    #).start()



punyverse = new Punyverse()
engine.addScene(punyverse)
engine.camera.position.z = 12

engine.render()

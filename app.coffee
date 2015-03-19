THREEx.Planets.baseURL = '/bower_components/threex.planets/'
THREEx.SpaceShips.baseUrl = '/bower_components/threex.spaceships/'

config = Config.get()
config.fillWindow()

engine = new Engine3D()
engine.renderer.setClearColor('black', 1)

class Punyverse extends BaseScene
  constructor: ->
    super()

    @loaded = false

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
      @ship = new Ship('protoss', object3d)
      @ship.mesh.position.z = 2
      @scene.add @ship.mesh

      @controls = new THREE.FlyControls( @ship.mesh )
      @controls.movementSpeed = 1000
      @controls.domElement = engine.renderer.domElement
      @controls.rollSpeed = Math.PI / 6
      @controls.autoForward = false
      @controls.dragToLook = false

      engine.camera.position.y = 1
      engine.camera.position.z = 4
      @ship.mesh.add engine.camera

      @loaded = true
      return

  tick: (tpf) ->
    @tpf = tpf

    @earth.animateClouds(tpf)
    @moon.mesh.rotation.z += 0.001
    @mercury.mesh.rotation.z += 0.003
    @venus.mesh.rotation.z += 0.004
    @sun.mesh.rotation.z -= 0.0005

    return if !@loaded

    @controls.movementSpeed = 120.33 * tpf
    @controls.update( tpf )

    @ship.rightDetonation.visible = @controls.moveVector.z == -1
    @ship.leftDetonation.visible = @controls.moveVector.z == -1
    #@ship.mesh.position.x = engine.camera.position.x
    #@ship.mesh.position.y = engine.camera.position.y - 1
    #@ship.mesh.position.z = engine.camera.position.z - 3

  doMouseEvent: (event, raycaster) ->
    return if !@loaded

  doKeyboardEvent: (event) ->
    #return if !@loaded

    #tween = new (TWEEN.Tween)({x: @ship.position.x}).to({ x: @ship.position.x + 3}, 2000).easing(TWEEN.Easing.Elastic.In)
    #tween.onUpdate(->
      #punyverse.ship.position.x = @x
    #).start()



punyverse = new Punyverse()
engine.addScene(punyverse)

engine.render()

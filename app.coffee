THREEx.Planets.baseURL = 'bower_components/threex.planets/'
THREEx.SpaceShips.baseUrl = 'bower_components/threex.spaceships/'
THREEx.TextureCube.baseUrl = ""

config = Config.get()
config.preventDefaultMouseEvents = false
config.fillWindow()

engine = new Engine3D()
engine.renderer.setClearColor('black', 1)

camera1 = new THREE.PerspectiveCamera(60, config.width / config.height, 0.1, 10000)
camera1.position.y = 1
camera1.position.z = 4
camera2 = new THREE.PerspectiveCamera(60, config.width / config.height, 0.1, 10000)

engine.setCamera(camera1)

THREE.MOUSE = {LEFT: 0, MIDDLE: 1, RIGHT: 2}

class Punyverse extends BaseScene
  constructor: ->
    super()

    @loaded = false
    @timeSpeed = 1
    @currentTime = Date.now()

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

    mesh = THREEx.createSkymap(
      cubeW: 1500
      cubeH: 1500
      cubeD: 1500
      textureCube: THREEx.createTextureCube('skybox')
    )
    @scene.add mesh

    @earth = new Planet('earth', 10, 0, 'earthmap1k', 'cyan', 0)
    @scene.add @earth.mesh

    @moon = new Planet('moon', 3, 25, 'moonmap1k', 'white', 0.001)
    @moon.mesh.rotation.y = @currentTime * @moon.speed
    @scene.add @moon.mesh

    @mercury = new Planet('mercury', 0.5, 30, 'mercurymap', 'red', 0.003)
    @mercury.mesh.rotation.y = @currentTime * @mercury.speed
    @scene.add @mercury.mesh

    @venus = new Planet('venus', 0.5, 45, 'venusmap', 'red', 0.004)
    @venus.mesh.rotation.y = @currentTime * @venus.speed
    @scene.add @venus.mesh

    @sun = new Planet('sun', 40, 100, 'sunmap', 'yellow', 0.0005)
    @sun.setDateRotation(@currentTime)
    #@sun.mesh.rotation.y = @currentTime / (1000 * 60 * 60 * 24 * 365) * @sun.speed
    @scene.add @sun.mesh

    @jupiter = new Planet('jupiter', 30, 200, 'jupitermap', 'orange', 0.006)
    @jupiter.mesh.rotation.y = @currentTime * @jupiter.speed
    @scene.add @jupiter.mesh

    @saturn= new Planet('saturn', 20, 300, 'saturnmap', 'brown', 0.003)
    @saturn.mesh.rotation.y = @currentTime * @saturn.speed
    @scene.add @saturn.mesh


    #geometry = new (THREE.CylinderGeometry)(1, 1, 30, 32, 1, true)
    #@texture = THREE.ImageUtils.loadTexture('images/skybox/nx.jpg')
    #@texture.wrapT = THREE.RepeatWrapping
    #material = new (THREE.MeshLambertMaterial)(
      #color: 0xFFFFFF
      #map: @texture)
    #mesh = new (THREE.Mesh)(geometry, material)
    #mesh.rotation.x = Math.PI / 2
    #@scene.add mesh

    #mesh.flipSided = true

    THREEx.SpaceShips.loadSpaceFighter01 (object3d) =>
      @ship = new Ship('protoss', object3d)
      #@ship.mesh.rotation.x = Math.PI
      @ship.mesh.position.z = 100
      @scene.add @ship.mesh

      @ship.mesh.add camera1

      @controls = new THREE.OrbitControls( camera1, engine.renderer.domElement )
      @controls.noPan = true
      @controls.maxDistance = 1000
      @controls.noKeys = true

      @gui = new dat.GUI()

      shipCtrl =
        rotation:
          x: @ship.mesh.rotation.x
          y: @ship.mesh.rotation.y
          z: @ship.mesh.rotation.z

      f1 = @gui.addFolder('Dashboard')
      f1.add(@ship, 'name')
      f1.add(@ship.mesh.position, 'x').listen()
      f1.add(@ship.mesh.position, 'y').listen()
      f1.add(@ship.mesh.position, 'z').listen()
      f1.open()

      f2 = @gui.addFolder('Location')
      f2.add(@ship, 'acceleration', -4, 14)
      rX = f2.add(shipCtrl.rotation, 'x', -Math.PI * 2, Math.PI * 2)
      rX.listen()
      ship = @ship

      rX.onFinishChange (value) =>
        originalX = @ship.mesh.rotation.x
        tween = new (TWEEN.Tween)({x: originalX}).to({ x: value}, 1000).easing(TWEEN.Easing.Cubic.In)
        tween.onUpdate(->
          ship.mesh.rotation.x = @x
        ).start()
        tween.onComplete =>
          return

      f2.add(@ship.mesh.rotation, 'y', -Math.PI * 4, Math.PI * 4)
      f2.add(@ship.mesh.rotation, 'z', -Math.PI * 4, Math.PI * 4)
      f2.open()

      f3 = @gui.addFolder('Time')
      f3.add(@, 'timeSpeed')
      f3.add(@, 'realCurrentTime').listen()
      f3.add(@, 'currentTime').listen()
      f3.open()

      @loaded = true

      return
    @bullets = []

    @axes = new CoffeeAxes(10000000)
    @scene.add( @axes.mesh )


  tick: (tpf) ->
    #@texture.offset.y += 0.008
    #@texture.offset.y %= 1
    #@texture.needsUpdate = true

    @tpf = tpf
    @realCurrentTime = Date.now()
    @currentTime += tpf * 1000 * @timeSpeed

    @earth.animateClouds(tpf * @timeSpeed)
    @moon.setDateRotation(@currentTime)
    @mercury.setDateRotation(@currentTime)
    @venus.setDateRotation(@currentTime)
    @sun.setDateRotation(@currentTime)
    @jupiter.setDateRotation(@currentTime)
    @saturn.setDateRotation(@currentTime)

    return if !@loaded

    @ship.rightDetonation.visible = @ship.acceleration > 0
    @ship.leftDetonation.visible = @ship.acceleration > 0

    for bullet in @bullets
      bullet.translateZ(6 * tpf * @timeSpeed)

    @ship.mesh.translateZ(@ship.acceleration * tpf * @timeSpeed)

  doMouseEvent: (event, raycaster) ->
    #return if !@loaded

  doKeyboardEvent: (event) ->
    return if !@loaded
    return if event.type != 'keyup'

    if event.which == 32
      bullet = @ship.spawnBullet()
      @bullets.push bullet
      @scene.add bullet

    #tween = new (TWEEN.Tween)({x: @ship.position.x}).to({ x: @ship.position.x + 3}, 2000).easing(TWEEN.Easing.Elastic.In)
    #tween.onUpdate(->
      #punyverse.ship.position.x = @x
    #).start()



punyverse = new Punyverse()
engine.addScene(punyverse)

engine.render()

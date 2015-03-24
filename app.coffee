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

Math.RADIAN = 57.2957795

class Punyverse extends BaseScene
  constructor: ->
    super()

    @loaded = false
    @universeSize = 1500
    @timeSpeed = 1
    @currentTime = Date.now()

    light = new (THREE.AmbientLight)(0xFFFFFF)
    @scene.add light

    mesh = THREEx.createSkymap(
      cubeW: @universeSize
      cubeH: @universeSize
      cubeD: @universeSize
      textureCube: THREEx.createTextureCube('skybox')
    )
    @scene.add mesh

    @earth = new Planet('earth', 10, 0, 'earthmap1k', 'cyan', 0)
    @earth.clouds.setVisible(true)
    @scene.add @earth.mesh

    @moon = new Planet('moon', 3, 25, 'moonmap1k', 'white', 0.001)
    @moon.setDateRotation(@currentTime)
    @scene.add @moon.mesh

    @mercury = new Planet('mercury', 0.5, 30, 'mercurymap', 'red', 0.003)
    @mercury.setDateRotation(@currentTime)
    @scene.add @mercury.mesh

    @venus = new Planet('venus', 0.5, 45, 'venusmap', 'red', 0.004)
    @venus.ring.setVisible(true)
    @venus.setDateRotation(@currentTime)
    @scene.add @venus.mesh

    @sun = new Planet('sun', 40, 100, 'sunmap', 'yellow', 0.0005)
    @sun.glow.setVisible(true)
    @sun.setDateRotation(@currentTime)
    @scene.add @sun.mesh

    @jupiter = new Planet('jupiter', 30, 200, 'jupitermap', 'orange', 0.006)
    @jupiter.ring.setVisible(true)
    @jupiter.setDateRotation(@currentTime)
    @scene.add @jupiter.mesh

    @saturn= new Planet('saturn', 20, 300, 'saturnmap', 'brown', 0.003)
    @saturn.ring.setVisible(true)
    @saturn.setDateRotation(@currentTime)
    @scene.add @saturn.mesh

    THREEx.SpaceShips.loadSpaceFighter01 (object3d) =>
      @pivot = new THREE.Object3D()

      @ship = new Ship('protoss', object3d)
      @ship.mesh.position.z = 100
      @scene.add @ship.mesh

      @pivot.add camera1
      @ship.mesh.add @pivot

      #@controls = new THREE.OrbitControls( camera1, engine.renderer.domElement )
      #@controls.noPan = true
      #@controls.maxDistance = 1000
      #@controls.noKeys = true

      @flyControls = new THREE.FlyControls(@ship.mesh, engine.renderer.domElement)
      @flyControls.autoForward = false
      @flyControls.dragToLook = false

      @gui = new dat.GUI()

      f1 = @gui.addFolder('Position')
      f1.add(@ship.mesh.position, 'x').listen()
      f1.add(@ship.mesh.position, 'y').listen()
      f1.add(@ship.mesh.position, 'z').listen()
      f1.open()

      f2 = @gui.addFolder('Rotation')

      f2.add(@ship.mesh.rotation, 'x').step(0.001).listen()
      f2.add(@ship.mesh.rotation, 'y').step(0.001).listen()
      f2.add(@ship.mesh.rotation, 'z').step(0.001).listen()

      f2.open()

      f3 = @gui.addFolder('Time')
      f3.add(@, 'timeSpeed')
      f3.add(@, 'realCurrentTime').listen()
      f3.add(@, 'currentTime').listen()
      f3.open()

      @loaded = true

      return
    @bullets = []

    @axes = new CoffeeAxes(@universeSize / 2)
    @scene.add( @axes.mesh )


  tick: (tpf) ->
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

    @flyControls.update(tpf)
    @flyControls.movementSpeed = 2000 * tpf * @timeSpeed
    @flyControls.strafeSpeed = 1000 * tpf * @timeSpeed
    @flyControls.rollSpeed = Math.PI / 24 * 4 * @timeSpeed

    mv = @flyControls.moveVector
    b = !(mv.x == 0 and mv.y == 0 and mv.z == 0)
    @ship.rightDetonation.visible = b # @ship.acceleration > 0
    @ship.leftDetonation.visible = b # @ship.acceleration > 0

    for bullet in @bullets
      bullet.translateZ(-30 * tpf * @timeSpeed)

  doMouseEvent: (event, raycaster) ->
    return if !@loaded

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

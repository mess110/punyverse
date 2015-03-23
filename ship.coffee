class Ship extends BaseModel
  constructor: (name, model) ->
    @name = name

    @mesh = new THREE.Object3D()

    @ship = model
    @ship.rotation.y = -0.15  #+ Math.PI

    @fireLeft = true
    @acceleration = 0

    @mesh.add @ship

    @leftDetonation = new (THREEx.SpaceShips.Detonation)
    @leftDetonation.position.x = -0.55
    @leftDetonation.position.z = -0.57
    @mesh.add @leftDetonation

    @rightDetonation = new (THREEx.SpaceShips.Detonation)
    @rightDetonation.position.x = 0.55
    @rightDetonation.position.z = -0.57
    @mesh.add @rightDetonation

  spawnBullet: ->
    projectile = new THREEx.SpaceShips.Shoot()
    bullet = new THREE.Object3D()
    a = @mesh.position
    bullet.position.set a.x, a.y, a.z
    if @fireLeft
      bullet.position.x += 0.2
    else
      bullet.position.x -= 0.2
    #bullet.position.z += 1
    @fireLeft = !@fireLeft
    b = @mesh.rotation
    bullet.rotation.set b.x, b.y, b.z
    bullet.add(projectile)

class Ship extends BaseModel
  constructor: (name, model) ->
    @mesh = new THREE.Object3D()

    @ship = model
    @ship.rotation.y = -0.15 + Math.PI

    @mesh.add @ship

    @leftDetonation = new (THREEx.SpaceShips.Detonation)
    @leftDetonation.position.x = -0.55
    @leftDetonation.position.z = 0.7
    @mesh.add @leftDetonation

    @rightDetonation = new (THREEx.SpaceShips.Detonation)
    @rightDetonation.position.x = 0.55
    @rightDetonation.position.z = 0.7
    @mesh.add @rightDetonation

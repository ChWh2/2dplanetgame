extends Node2D

const noSpawnRadius = 1500
const spawnRadius = 2000

const initialCount = 100

const maxRotSpeed = 20.0
const minSpeed = 100.0
const maxSpeed = 200.0

const maxCount : int = 100

@export var asteroidTemplate : PackedScene
@export var follow : Node2D

var asteroids : Array[asteroid]

func _ready() -> void:
	for i in initialCount:
		spawn(true)

func spawn(_noRad : bool):
	if asteroids.size() < maxCount - 1:
		var newAsteroid = asteroidTemplate.instantiate()
		add_child(newAsteroid)
		if newAsteroid is asteroid:
			newAsteroid.crashed.connect(crashed)
			
			var theta = randf_range(0, 2 * PI)
			var rad = randf_range(noSpawnRadius, spawnRadius)

			var angularVelocity = randf_range(-maxRotSpeed, maxRotSpeed)
			
			newAsteroid.global_position = global_position + rad * Vector2(cos(theta), sin(theta))
			
			var velocity = randf_range(minSpeed, maxSpeed)
			
			newAsteroid.angVel = angularVelocity
			newAsteroid.linVel = velocity
			
			asteroids.append(newAsteroid)
		
func _physics_process(_delta: float) -> void:
	var offset = follow.global_position - global_position
	
	spawn(false)
	
	global_position = follow.global_position
	for i in asteroids:
		i.offset(offset)
		
		if i.position.length() > spawnRadius:
			crashed(i)

func crashed(obj : asteroid):
	var i = asteroids.find(obj) + 1
	print(get_children().size())
	if i:
		asteroids.remove_at(i - 1)
	
	obj.queue_free()

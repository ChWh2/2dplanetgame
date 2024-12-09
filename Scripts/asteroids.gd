extends Node2D

const noSpawnRadius = 1500
const spawnRadius = 2000

const initialCount = 100

const maxRotSpeed = 20.0
const minSpeed = 100.0
const maxSpeed = 200.0

@export var asteroidTemplate : PackedScene
@export var follow : Node2D

var asteroids : Array[asteroid]

#func _ready() -> void:
	#for i in initialCount:
		#spawn()

func _on_timer_timeout() -> void:
	spawn()

func spawn():
	var newAsteroid = asteroidTemplate.instantiate()
	add_child(newAsteroid)
	if newAsteroid is asteroid:
		
		newAsteroid.crashed.connect(crashed)
		
		var theta = randf_range(0, 2 * PI)
		var rad = randf_range(noSpawnRadius, spawnRadius)
		var angularVelocity = randf_range(-maxRotSpeed, maxRotSpeed)
		
		newAsteroid.global_position = global_position + rad * Vector2(cos(theta), sin(theta))
		
		var velocity = Vector2(1,1) * randf_range(minSpeed, maxSpeed)
		
		newAsteroid.angular_velocity = angularVelocity
		newAsteroid.linear_velocity = velocity
		
		asteroids.append(newAsteroid)
		
func _physics_process(_delta: float) -> void:
	global_position = follow.global_position
	for i in asteroids:
		if i.position.length() > spawnRadius:
			crashed(i)

func crashed(obj : asteroid):
	var i = asteroids.find(obj)
	if asteroids[i]:
		asteroids.remove_at(i)
	obj.queue_free()

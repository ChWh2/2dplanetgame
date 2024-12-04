extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -4.0

var rawPosition : Vector2

@onready var sprite_2d = $Sprite2D

func setPhysicsProcess(b : bool):
	set_physics_process(b)

func _physics_process(delta: float) -> void:
	
	#look at closest attractor
	var closestAttractor = Vector2.INF
	for i in get_tree().get_nodes_in_group("Gravity Attractors"):
		if closestAttractor.distance_to(global_position) > i.global_position.distance_to(global_position):
			closestAttractor = i.global_position
	
	var lookatVector = Vector3(0,0,-1).cross(Vector3(closestAttractor.x - global_position.x, closestAttractor.y - global_position.y, 0.0).normalized())
	print(lookatVector)
	look_at(Vector2(lookatVector.x, lookatVector.y) + global_position)
	
	#movement
	var direction := Input.get_axis("Left", "Right")
	if direction:
		sprite_2d.animation = "run"
		
		if direction > 0:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h = false
		
		var velVector = direction * SPEED * Vector2(cos(rotation), sin(rotation))
		var velDir = velVector.normalized()
		
		velocity.x = move_toward(velocity.x, velVector.x, SPEED/20.0)
		velocity.y = move_toward(velocity.y, velVector.y, SPEED/20.0)
	else:
		sprite_2d.animation = "default"
		velocity.x = move_toward(velocity.x, 0.0, SPEED/2.0)
		velocity.y = move_toward(velocity.y, 0.0, SPEED/2.0)
	move_and_slide()
	
	#stick to floor
	if $ReGround.get_collision_point():
		var point : Vector2 = $ReGround.get_collision_point()
		point += (point.direction_to(global_position)).normalized() * 15.0
		
		global_position = point

extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var rawPosition : Vector2

var supposedToBeGrounded : bool = false

func onFloor() -> bool:
	return $GroundCast.is_colliding()

func _physics_process(delta: float) -> void:
	
	var gravity = Vector2.ZERO
	for i in get_tree().get_nodes_in_group("Gravity Attractors"):
		if i is GravAttractor:
			gravity += i.getGravity(global_position)
			
	if !onFloor():
		velocity += gravity * delta
	else:
		velocity += gravity.normalized() * delta
		
	var gravityDir = gravity.normalized() * 30.0
	
	if gravity.length() > 1.0:
		look_at(Vector2(gravityDir.y, -gravityDir.x) + global_position)
	
	if supposedToBeGrounded == false and onFloor():
		print("Set grounded")
		supposedToBeGrounded = true
	
	# Handle jump.
	if Input.is_action_pressed("ui_accept") and onFloor():
		velocity += JUMP_VELOCITY * gravityDir
		print("Deset grounded")
		supposedToBeGrounded = false
		
	if supposedToBeGrounded:
		print("resetPos")
		position = $ReGround.get_collision_point() + $ReGround.get_collision_normal() * 12.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and onFloor():
		velocity += direction * SPEED * delta * Vector2(cos(rotation), sin(rotation))
	move_and_slide()

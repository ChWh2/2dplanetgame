extends CharacterBody2D
class_name player

const SPEED = 300.0
const JUMP_VELOCITY = -4.0

var rawPosition : Vector2

@onready var sprite_2d = $Sprite2D
@onready var camera_2d: Camera2D = $Camera2D

@export var currentPlanet : planet

var materials : int = 0

var hasStormShields = false
var hasFloatationDevice = false
var hasHoloDisruptor = false

func _ready() -> void:
	camera_2d.make_current()

func _physics_process(_delta: float) -> void:
	#look at planet
	var lookatVector = Vector2(currentPlanet.global_position.y - global_position.y, global_position.x - currentPlanet.global_position.x)
	look_at(lookatVector + global_position)
	
	#movement
	var direction := Input.get_axis("Left", "Right")
	if direction:
		sprite_2d.animation = "run"
		
		if direction > 0:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h = false
		
		var velVector = direction * SPEED * Vector2(cos(rotation), sin(rotation))
		
		if velocity == velVector:
			velocity.x = move_toward(velocity.x, velVector.x, SPEED/2.0)
			velocity.y = move_toward(velocity.y, velVector.y, SPEED/2.0)
		else:
			velocity.x = move_toward(velocity.x, velVector.x, SPEED/20.0)
			velocity.y = move_toward(velocity.y, velVector.y, SPEED/20.0)
	else:
		sprite_2d.animation = "default"
		velocity.x = move_toward(velocity.x, 0.0, SPEED/2.0)
		velocity.y = move_toward(velocity.y, 0.0, SPEED/2.0)
	move_and_slide()
	
	#stick to floor
	
	
	var stickDir = currentPlanet.global_position.direction_to(global_position)
	
	$GroundCast.force_raycast_update()
	global_position = stickDir * 16 + $GroundCast.get_collision_point()

func addMaterial(i : int):
	materials += i

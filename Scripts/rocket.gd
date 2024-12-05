extends Area2D
class_name rocket

var plr : player

var flying = false
var tookOff = false

const SPEED = 300.0
const ROTSPEED = 3.0

var velocity = 0.0
var angularVelocity = 0.0

@onready var camera_2d: Camera2D = $Camera2D
@onready var take_off: Timer = $takeOff

@export var currentPlanet : planet

func _ready():
	land()

func land() -> void:
	velocity = 0.0
	angularVelocity = 0.0
	
	var lookatVector = Vector2(currentPlanet.global_position.y - global_position.y, global_position.x - currentPlanet.global_position.x)
	look_at(lookatVector + global_position)
	
	var stickDir = currentPlanet.global_position.direction_to(global_position)
	global_position = currentPlanet.global_position + stickDir * (currentPlanet.radius * 2.0)

func fly(delta : float):
	var direction := Input.get_axis("Left", "Right")
	angularVelocity = move_toward(angularVelocity, ROTSPEED, ROTSPEED/200.0)
	if direction:
		rotate(direction * delta * angularVelocity)
	
	velocity = move_toward(velocity, SPEED, SPEED/200.0)
	position += delta * velocity * Vector2(sin(rotation), -cos(rotation))

func _physics_process(delta: float) -> void:
	if flying and tookOff:
		fly(delta)
	
	elif Input.is_action_just_pressed("Interact") and plr and not flying:
		$Label.visible = false
		plr.set_physics_process(false)
		plr.visible = false
		camera_2d.make_current()
		flying = true
		take_off.start()


func _on_body_entered(body: Node2D) -> void:
	if body is player and not flying:
		$Label.visible = true
		plr = body
	elif flying and body is planet:
		$Label.visible = true
		currentPlanet = body
		
		flying = false
		tookOff = false
		land()
		
		plr.currentPlanet = body
		
		plr.global_position = global_position
		plr.velocity = Vector2.ZERO
		plr.visible = true
		
		plr.camera_2d.make_current()
		plr.camera_2d.reset_smoothing()
		
		plr.set_physics_process(true)
		
		plr = null

func _on_body_exited(body: Node2D) -> void:
	if body is player and not flying:
		$Label.visible = false
		plr = null
		


func _on_take_off_timeout() -> void:
	tookOff = true
	$CPUParticles2D.restart()

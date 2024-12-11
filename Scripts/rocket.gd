extends Area2D
class_name rocket

var plr : player

var flying = false
var tookOff = false

var velocity = 0.0
var angularVelocity = 0.0

@onready var camera_2d: Camera2D = $Camera2D
@onready var take_off: Timer = $takeOff

@export var currentPlanet : planet
var planets : Array[planet]

@export var arrowTemplate : PackedScene

@export var asteroidSpawner : Node2D

var arrows : Array[arrow]

var oxygenvalue : int = 0
var speedvalue : int = 0

const startingOxygen = 20.0
const oxygenMultiplier = 2.0

const startingSpeed = 300.0
const speedMultiplier = 10.0
const startingRotSpeed = 3.0
const rotSpeedMultiplier = 0.1

func _ready():
	for i in $"../Planets".get_children():
		if i is planet:
			planets.append(i)
	
	land()
	
	for i in planets:
		var newArrow = arrowTemplate.instantiate()
		newArrow.lookAt = i
		newArrow.modulate = i.color
		$ArrowHolder.add_child(newArrow)
		arrows.append(newArrow)

func land() -> void:
	velocity = 0.0
	angularVelocity = 0.0
	
	var lookatVector = Vector2(currentPlanet.global_position.y - global_position.y, global_position.x - currentPlanet.global_position.x)
	look_at(lookatVector + global_position)
	
	var stickDir = currentPlanet.global_position.direction_to(global_position)
	global_position = currentPlanet.global_position + stickDir * (currentPlanet.radius * 2.0)

func fly(delta : float):
	var calculatedVelocity = startingSpeed + (speedvalue * speedMultiplier)
	var calculatedRotVelocity = startingRotSpeed + (speedvalue * rotSpeedMultiplier)
	
	$CanvasLayer/ProgressBar.value -= delta
	
	if $CanvasLayer/ProgressBar.value <= 0:
		Constants.die("You ran out of oxygen and suffocated")
	
	var direction := Input.get_axis("Left", "Right")
	angularVelocity = move_toward(angularVelocity, calculatedRotVelocity, calculatedRotVelocity/200.0)
	if direction:
		rotate(direction * delta * angularVelocity)
	
	velocity = move_toward(velocity, calculatedVelocity, calculatedVelocity/200.0)
	position += delta * velocity * Vector2(sin(rotation), -cos(rotation))

func _physics_process(delta: float) -> void:
	if flying and tookOff:
		fly(delta)
	
	elif Input.is_action_just_pressed("Interact") and plr and not flying:
		$Label.visible = false
		$UpgradeUI.visible = false
		plr.set_physics_process(false)
		plr.visible = false
		camera_2d.make_current()
		flying = true
		take_off.start()
		$ArrowHolder.visible = true
		
		$CanvasLayer.visible = true
		
		var calculatedOxygen = startingOxygen + (oxygenMultiplier * oxygenvalue)
		
		$CanvasLayer/ProgressBar.max_value = calculatedOxygen
		$CanvasLayer/ProgressBar.value = calculatedOxygen


func _on_body_entered(body: Node2D) -> void:
	if body is player and not flying:
		$Label.visible = true
		$UpgradeUI.visible = true
		plr = body
	elif body is planet and flying:
		if !body.requirements.find(body.requirement.stormShields) and !plr.hasStormShields:
			Constants.die("The storm causes you to crash")
		if !body.requirements.find(body.requirement.floatationDevice) and !plr.hasFloatationDevice:
			Constants.die("You plunge into the ocean, run out of air, and suffocate")
		if !body.requirements.find(body.requirement.holoDisruptor) and !plr.hasHoloDisruptor:
			Constants.die("You strangely fly through the planet and crash")
		
		$Label.visible = true
		$UpgradeUI.visible = true
		currentPlanet = body
		
		flying = false
		tookOff = false
		
		$CPUParticles2D.emitting = false
		
		$ArrowHolder.visible = false
		$CanvasLayer.visible = false
		
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
		$UpgradeUI.visible = false
		plr = null
		


func _on_take_off_timeout() -> void:
	$CPUParticles2D.restart()
	
	tookOff = true


func _on_area_entered(area: Area2D) -> void:
	if area is asteroid and flying:
		area.tellCrash()
		plr.addMaterial(1)

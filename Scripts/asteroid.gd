extends Area2D
class_name asteroid

signal crashed(object: asteroid)

var linVel : float
var angVel : float

var working = true

func _physics_process(delta: float) -> void:
	if working:
		position += Vector2(1,1).normalized() * linVel * delta
		rotation += angVel * delta 

func tellCrash():
	crashed.emit(self)
	queue_free()

func _on_body_entered(_body: Node) -> void:
	working = false
	$Kaboom.start()
	$StartStopping.start()
	
	$CPUParticles2D.restart()
	$Sprite2D.visible = false


func _on_kaboom_timeout() -> void:
	crashed.emit(self)

func offset(xy : Vector2):
	position -= xy


func _on_start_stopping_timeout() -> void:
	$CPUParticles2D.emitting = false
	

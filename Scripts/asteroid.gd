extends RigidBody2D
class_name asteroid

signal crashed(object: asteroid)

func tellCrash():
	$Kaboom.start()
	$CPUParticles2D.restart()
	$Sprite2D.visible = false
	call_deferred("Freeze")
	
	crashed.emit(self)

func _on_body_entered(_body: Node) -> void:
	$Kaboom.start()
	$CPUParticles2D.restart()
	$Sprite2D.visible = false
	call_deferred("Freeze")

	crashed.emit(self)


func _on_kaboom_timeout() -> void:
	$Kaboom.stop()
	queue_free()

func Freeze():
	freeze = true

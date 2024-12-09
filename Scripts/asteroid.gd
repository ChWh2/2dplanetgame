extends RigidBody2D
class_name asteroid

signal crashed(object: asteroid)

func tellCrash():
	crashed.emit(self)

func _on_body_entered(_body: Node) -> void:
	crashed.emit(self)

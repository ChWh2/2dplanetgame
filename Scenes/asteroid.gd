extends RigidBody2D
class_name asteroid

signal crashed(object: asteroid)

func _on_body_entered(_body: Node) -> void:
	crashed.emit(self)

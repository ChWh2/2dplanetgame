extends Sprite2D
class_name arrow

var lookAt : Node2D

func _process(_delta: float) -> void:
	look_at(lookAt.global_position)
	$Label.text = str(lookAt.global_position.distance_to(global_position)/100).pad_decimals(0)

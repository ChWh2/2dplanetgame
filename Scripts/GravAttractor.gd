extends Node2D
class_name GravAttractor

@export var mass : float
@export var massPow : int
@export var radius : float

func getGravity(attractedPosition : Vector2) -> Vector2:
	var r = attractedPosition.distance_to(global_position)
	var gravity = mass * Constants.gravityConst * pow(10.0, massPow + Constants.gravityConstPow)
	gravity = gravity/r
		
	return attractedPosition.direction_to(global_position).normalized() * gravity
	

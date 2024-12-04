extends Area2D

func _physics_process(delta):
	var closestAttractor = Vector2.INF
	for i in get_tree().get_nodes_in_group("Gravity Attractors"):
		if closestAttractor.distance_to(global_position) > i.global_position.distance_to(global_position):
			closestAttractor = i.global_position
	
	var lookatVector = Vector3(0,0,-1).cross(Vector3(closestAttractor.x - global_position.x, closestAttractor.y - global_position.y, 0.0).normalized())
	print(lookatVector)
	look_at(Vector2(lookatVector.x, lookatVector.y) + global_position)
	
	if $ReGround.get_collision_point():
		var point : Vector2 = $ReGround.get_collision_point()
		point += (point.direction_to(global_position)).normalized()
		
		global_position = point

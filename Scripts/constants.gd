extends Node

var deathMessage : String

func die(message : String):
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/death_screen.tscn")
	deathMessage = message
func startGame():
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/space.tscn")

extends Control

@onready var rocketOBJ: rocket = $".."

@onready var oxygen: Button = $Oxygen
@onready var speed: Button = $Fuel
@onready var oxygenlabel: Label = $Oxygenlabel
@onready var speedlabel: Label = $Fuellabel

var oxygenvalue : int = 1
var speedvalue : int = 1


func _process(_delta: float) -> void:
	oxygenlabel.text = str(oxygenvalue)
	speedlabel.text = str(speedvalue)


func _on_oxygen_pressed() -> void:
	if rocketOBJ.plr.materials > 0:
		oxygenvalue += 1
		rocketOBJ.oxygenvalue += 1
		rocketOBJ.plr.addMaterial(-1)

func _on_fuel_pressed() -> void:
	if rocketOBJ.plr.materials > 0:
		speedvalue += 1
		rocketOBJ.speedvalue += 1
		rocketOBJ.plr.addMaterial(-1)

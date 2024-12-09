extends StaticBody2D
class_name planet

@export var radius : float
@export var color : Color

enum requirement{stormShields, floatationDevice, holoDisruptor}

@export var requirements : Array[requirement]

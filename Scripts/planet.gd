@tool

extends StaticBody2D
class_name planet

@export var radius : float

@export var maxRadChange : float

@onready var noiseSeed = randf()

@export var color : Color

@export var texture : Texture2D

enum requirement{stormShields, floatationDevice, holoDisruptor}

@export var requirements : Array[requirement]

func _ready() -> void:
	var points : Array[Vector2]
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = noiseSeed
	
	for theta in 360:
		var noiseVal = noise.get_noise_1d(abs(theta - 180))
		
		var point = (radius + noiseVal * 10 * maxRadChange) * Vector2(cos(deg_to_rad(theta)), sin(deg_to_rad(theta)))
		points.append(point)
	
	var polygon = Polygon2D.new()
	polygon.set_polygon(points)
	polygon.texture = texture
	add_child(polygon)
	
	var collisionPolygon = CollisionPolygon2D.new()
	collisionPolygon.set_polygon(points)
	add_child(collisionPolygon)

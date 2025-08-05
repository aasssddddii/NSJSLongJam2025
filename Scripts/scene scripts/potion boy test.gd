extends Node2D

@onready var player_prefab = preload("res://Prefabs/player_cam.tscn")
@onready var player_spawn = $player_spawn

@onready var house_prefab = preload("res://Prefabs/house_template.tscn")
@onready var house_layer = $"house layer"
var next_house_position:Vector2 = Vector2(300,0)
const house_offset:Vector2 = Vector2(500,0)

func _ready():
	create_level()
	
	
func create_level():
	#spawn houses
	spawn_houses()
	#spawn player
	spawn_player()
	#start game
	



func spawn_houses():
	for i in 10:
		var next_house = house_prefab.instantiate()
		house_layer.add_child(next_house)
		next_house.global_position =  next_house_position
		next_house.rotation = deg_to_rad(45)
		next_house_position += house_offset
	
	
func spawn_player():
	var next_player = player_prefab.instantiate()
	add_child(next_player)
	next_player.rotation = deg_to_rad(45)
	next_player.global_position = player_spawn.global_position
	

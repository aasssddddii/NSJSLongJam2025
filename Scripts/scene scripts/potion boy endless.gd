extends Node2D

var game_manager = GameManager

@onready var player_prefab = preload("res://Prefabs/player_cam.tscn")
@onready var player_spawn = $player_spawn

@onready var house_prefab = preload("res://Prefabs/house_template.tscn")
@onready var hut_prefab = preload("res://Prefabs/witch_hut_template.tscn")
@onready var castle_prefab = preload("res://Prefabs/castle_template.tscn")
@onready var house_layer = $"house layer"
@onready var level_up_checker = $stage_end
#@onready var oob_detector = $"OOB Detector"
#@onready var tile_map = $TileMap
@onready var map_spawn = $map_spawn
const stage_end_offset:Vector2 = Vector2(-600,0)
var next_house_position:Vector2 = Vector2(820,0)
const house_offset:Vector2 = Vector2(1200,0)
const level_position_offset:Vector2 = Vector2(1000,0)
const castle_offset:Vector2 = Vector2(0,-40)

var endless_level:int

#var deliveries_made:int
#var company_profits:int

func _ready():
	create_level()
#	oob_detector.body_entered.connect(remove_oob_potion)
	
	
func create_level():
	#spawn player
	spawn_player()
	#spawn houses
	spawn_houses()

func spawn_next_level():
	#update endless level
	endless_level +=1
	#clear old tilemap
	clear_map()
	#clear houses
	clear_houses()
	#Spawn next level VVVV
	#leverage next house position
	next_house_position += level_position_offset
	var next_level_tilemap = game_manager.endless_tile_spawn.instantiate()
	#setup edless tile
	#spawn endless tile
	map_spawn.add_child(next_level_tilemap)
	next_level_tilemap.global_position = next_house_position + Vector2(0,-271)
	#Spawn new houses
	spawn_houses()
	


func spawn_houses():
	#var customer_refab 
	var offset:Vector2
	var spawnable_houses = []
	#make able to spawn random houses
	match endless_level:
		0:
			#customer_refab = house_prefab
			spawnable_houses.append_array([house_prefab])
		1:
			#customer_refab = hut_prefab
			spawnable_houses.append_array([house_prefab,hut_prefab])
		_:
			#customer_refab = castle_prefab
			spawnable_houses.append_array([house_prefab,hut_prefab,castle_prefab])
			offset = castle_offset
			
	var house_amount:int = 10
	for i in house_amount:
		var picked_index:int
		#pick house based on level
		match endless_level:
			0:
				picked_index = 0
			1:
				if game_manager.rng.randi_range(1,20)>14:
					picked_index = 1
				else:
					picked_index = 0
			2:
				if game_manager.rng.randi_range(1,20)>=10:
					if game_manager.rng.randi_range(1,20)>14:
						picked_index = 2
					else:
						picked_index = 1
				else:
					picked_index = 0
			2:
				if game_manager.rng.randi_range(1,20)>=10:
					if game_manager.rng.randi_range(1,20)>10:
						picked_index = 2
					else:
						picked_index = 1
				else:
					picked_index = 0
			4:
				if game_manager.rng.randi_range(1,20)>14:
					picked_index = 2
				else:
					picked_index = 1
			_:
				picked_index = game_manager.rng.randi_range(0,2)
		var picked_house = spawnable_houses[picked_index]
		
		
		var next_house = picked_house.instantiate()
		house_layer.call_deferred("add_child",next_house)
		#splicing adding house type
		match picked_index:
			0:
				next_house.house_type = "house"
			1:
				next_house.house_type = "hut"
			2:
				next_house.house_type = "castle"
		next_house.global_position =  next_house_position + offset
		next_house.rotation = deg_to_rad(45)
		next_house_position += house_offset
		next_house.customer_result.connect(resolve_house_result)
	level_up_checker.global_position = next_house_position + stage_end_offset
	
func clear_houses():
	for house in house_layer.get_children():
		house.queue_free()
	
func clear_map():
	map_spawn.get_child(0).queue_free()
	
	
func spawn_player():
	var next_player = player_prefab.instantiate()
	add_child(next_player)
	next_player.rotation = deg_to_rad(45)
	next_player.global_position = player_spawn.global_position
	
func resolve_house_result(is_happy:bool,reward_amount:int):
	#print("customer, recieved potion? ", is_happy, " reward amount is so: ", reward_amount)
	if is_happy:
		game_manager.deliveries_made += 1
		game_manager.company_profits += reward_amount
	
func finish_endless():
	if !game_manager.endless_mode:
		for house in house_layer.get_children():
			house.turn_off_endless_monitoring()
		
#func remove_oob_potion(area):
#	if area.is_in_group("potion"):
#		print("removing potion")
#		game_manager.level_splatters += 1
#		area.queue_free()
	
	
#func tilemap_transposer():
#	var used_cells = tile_map.get_used_cells(0)
#	for cell in used_cells:
#		#print("cell coords: ", tile_map.get_cell_atlas_coords(0,cell))
#		tile_map.set_cell(0,cell,0,get_transposed_tile(tile_map.get_cell_atlas_coords(0,cell)))
	
func get_transposed_tile(atlas_coord:Vector2):
	var new_atlas
	match game_manager.game_level:
		1:
			return atlas_coord
		2,3:
			new_atlas = atlas_coord + Vector2(0,3)
			return new_atlas
		4,5:
			new_atlas = atlas_coord + Vector2(0,6)
			return new_atlas
		6,7:
			new_atlas = atlas_coord + Vector2(0,9)
			return new_atlas
	
	

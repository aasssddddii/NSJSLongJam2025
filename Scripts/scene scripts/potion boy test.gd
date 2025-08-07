extends Node2D

var game_manager = GameManager

@onready var player_prefab = preload("res://Prefabs/player_cam.tscn")
@onready var player_spawn = $player_spawn

@onready var house_prefab = preload("res://Prefabs/house_template.tscn")
@onready var hut_prefab = preload("res://Prefabs/witch_hut_template.tscn")
@onready var castle_prefab = preload("res://Prefabs/castle_template.tscn")
@onready var house_layer = $"house layer"
@onready var stage_end_checker = $stage_end
@onready var oob_detector = $"OOB Detector"
const stage_end_offset:Vector2 = Vector2(-600,0)
var next_house_position:Vector2 = Vector2(600,0)
const house_offset:Vector2 = Vector2(1200,0)
const house_amount:int = 6
const castle_offset:Vector2 = Vector2(0,-40)

#var deliveries_made:int
#var company_profits:int

func _ready():
	create_level()
	oob_detector.body_entered.connect(remove_oob_potion)
	
	
func create_level():
	#spawn houses
	spawn_houses()
	
	#spawn player
	spawn_player()
	#start game
	



func spawn_houses():
	var customer_refab 
	var offset:Vector2
	match game_manager.game_level:
		1,2,3:
			customer_refab = house_prefab
		4,5:
			customer_refab = hut_prefab
		6,7:
			customer_refab = castle_prefab
			offset = castle_offset
	for i in house_amount:
		var next_house = customer_refab.instantiate()
		house_layer.add_child(next_house)
		next_house.global_position =  next_house_position + offset
		next_house.rotation = deg_to_rad(45)
		next_house_position += house_offset
		next_house.customer_result.connect(resolve_house_result)
	stage_end_checker.global_position = next_house_position + stage_end_offset
	
	
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
	print("company profits: ", game_manager.company_profits, " happy customers so far: ", game_manager.deliveries_made)
	
func remove_oob_potion(area):
	if area.is_in_group("potion"):
		print("removing potion")
		game_manager.level_splatters += 1
		area.queue_free()
	
	
	

extends Node


enum PotionType {
	NONE,
	BLUE,
	RED,
	YELLOW,
	GREEN,
	ORANGE,
	PURPLE,
	BLACK
}
@onready var potion_prefab = preload("res://Prefabs/potion.tscn")
@onready var splatter_prefab = preload("res://Prefabs/splatter.tscn")
@onready var start_screen = preload("res://Scenes/start screen.tscn")
@onready var level_select_screen = preload("res://Scenes/level_select.tscn")

@onready var potion_boy_scene = preload("res://Scenes/potion boy test.tscn")
var requestable_potions:Array[PotionType] = [PotionType.BLUE,PotionType.RED,PotionType.YELLOW,PotionType.GREEN,PotionType.ORANGE,PotionType.PURPLE,PotionType.BLACK]
var splatter_textures:Array[String] = ["res://Sprites/splatter1.png","res://Sprites/splatter2.png","res://Sprites/splatter3.png"]
var rng = RandomNumberGenerator.new()

var company_profits:int
var deliveries_made:int
var level_splatters:int

#var unlocked_overtime:bool


var potion_selector_prefab = preload("res://Prefabs/potion_template.tscn")

var game_level:int# = 1

func get_new_potion_request(level:int):
	var rng_potion_index_low:int
	var rng_potion_index_high:int = 6
	var required_amount_low:int = 1
	var required_amount_high:int = 3
	var returned_request:Array[PotionType]
	match level:
		1:
			rng_potion_index_high = 2
			required_amount_high = 1
		2,3:
			rng_potion_index_high = 5
			required_amount_high = 2
		4,5:
			required_amount_high = 3
			
	#pick how many potions required
	for i in rng.randi_range(required_amount_low,required_amount_high):
		#pick which potion is next
		returned_request.append(requestable_potions[rng.randi_range(rng_potion_index_low,rng_potion_index_high)])
	return returned_request

func change_scene(from_scene,to_scene):
	var next_scene = to_scene.instantiate()
	add_child(next_scene)
	from_scene.queue_free()
	

extends Sprite2D

signal customer_result(happy:bool, reward:int)

var house_data:Dictionary
@onready var door_submission_area = $Area2D
@onready var potion_box = $potion_box
@onready var potion_submission_area = $potion_box.potion_submission_area

@export var house_closed_texture:Texture

var game_manager = GameManager
var potion_requirements:Array[GameManager.PotionType]

@onready var request_container = $request_manager/request_container
@onready var bound_checker = $request_manager/bound_checker
@onready var request_move_spot = $request_move_spot
@onready var request_manager = $request_manager
@onready var request_bubble = $request_manager/request_bubble

@onready var ui_result = $ui_result
@onready var ui_face = $ui_result/ui_face
@onready var splatter_layer = $"splatter layer"

@export var negative_splatter_areas:Array[Area2D]

var potion_attempts:int = 3
var reward_money:int

var valid_house:bool = true

func _ready():
	ui_result.visible = false
	#set house type
	#set potion requirements
	potion_requirements = game_manager.get_new_potion_request(game_manager.game_level)
	#display potion requirements
	display_potion_requirements(potion_requirements)
	#setup negative splatter
	for area in negative_splatter_areas:
		area.body_entered.connect(setup_splatter)
	
	calculate_reward()
	door_submission_area.body_entered.connect(potion_recieved)
	potion_submission_area.body_entered.connect(potion_recieved)
	bound_checker.area_entered.connect(potion_display_out_of_bounds)
	
func potion_recieved(body:Node2D):
	#print("something recieved: ", body.name, " with potion type: ", body.potion_type, " checking against requirments: ", potion_requirements)
	#check if potion is correct
	if potion_requirements.find(body.potion_type) != -1:
		potion_requirements.remove_at(potion_requirements.find(body.potion_type))
		update_requirements()
		body.queue_free()
	else:
		setup_splatter(body)
	
	
func display_potion_requirements(requirements:Array[GameManager.PotionType]):
	for potion in requirements:
		var next_potion = game_manager.potion_selector_prefab.instantiate()
		request_container.add_child(next_potion)
		next_potion.setup_potion(potion)
	
func potion_display_out_of_bounds(area):
	request_manager.global_position = request_move_spot.global_position
	request_bubble.flip_v = false
	request_bubble.flip_h = true
	
func clear_requirements():
	for child in request_container.get_children():
		child.queue_free()
		
func update_requirements():
	clear_requirements()
	if potion_requirements != []:
		game_manager.play_sfx(game_manager.potion_accepted)
		display_potion_requirements(potion_requirements)
	else:
		requirement_finished(true)
	
func requirement_finished(potion_delivered:bool):
	setup_results(potion_delivered)
	close_house()
	customer_result.emit(potion_delivered,reward_money)
	request_manager.visible = false
	if !potion_delivered:
		#negative stuff
		
		game_manager.unhappy_customers += 1
		game_manager.play_sfx(game_manager.house_mad)
	else:
		game_manager.play_sfx(game_manager.house_happy)

func close_house():
	texture = house_closed_texture
	potion_box.texture = load("res://Sprites/potion box closed.png")
	
	
func setup_results(positive:bool):
	var result_texture:String
	
	if positive:
		result_texture = "res://Sprites/happy face.png"
	else:
		result_texture = "res://Sprites/mad face.png"
	
	ui_face.texture = load(result_texture)
	
	ui_result.visible = true
	turn_off_monitoring()
	
func show_splatter(splatter_position,potion_type:GameManager.PotionType):
	#print("generating splatter at: ", splatter_position)
	
	var next_splatter = game_manager.splatter_prefab.instantiate()
	next_splatter.texture = load(game_manager.splatter_textures.pick_random())
	next_splatter.setup_splatter(potion_type)
	splatter_layer.add_child(next_splatter)
	next_splatter.global_position = splatter_position
	if potion_attempts <=0:
		if valid_house:
			valid_house = false
			requirement_finished(false)
			game_manager.play_sfx(game_manager.house_mad)
		

func setup_splatter(body):
	game_manager.play_sfx(game_manager.splatter)
	game_manager.level_splatters += 1
	potion_attempts -=1
	show_splatter(body.global_position,body.potion_type)
	body.queue_free()

func turn_off_monitoring():
	potion_submission_area.set_deferred("monitoring",false)
	door_submission_area.set_deferred("monitoring",false)
func calculate_reward():
	const basic_reward:int = 20
	const mix_reward:int = 30
	const black_reward:int = 50
	for potion in potion_requirements:
		match potion:
			GameManager.PotionType.RED,GameManager.PotionType.BLUE,GameManager.PotionType.YELLOW:
				reward_money += basic_reward
			GameManager.PotionType.GREEN,GameManager.PotionType.ORANGE,GameManager.PotionType.PURPLE:
				reward_money += mix_reward
			GameManager.PotionType.BLACK:
				reward_money += black_reward


func _on_oob_area_entered(area):
	if area.name == "OOB" && request_manager.visible:
		requirement_finished(false)
		

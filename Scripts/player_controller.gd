extends CharacterBody2D
const SPEED = 300.0

var game_manager = GameManager
#enum PotionType {
#	BLUE,
#	RED,
#	YELLOW,
#	GREEN,
#	ORANGE,
#	PURPLE
#}

@onready var potion_prefab = preload("res://Prefabs/potion.tscn")
@onready var potion_spawn_node  = $potion_spawn

@onready var potion_selector = $"../ColorRect/potion_selector"
var selected_potion_index:int
var mix_station_index:int = -1
var potion_inventory:Array[GameManager.PotionType] = [GameManager.PotionType.BLUE,GameManager.PotionType.RED,GameManager.PotionType.YELLOW]
var selected_potion_type:GameManager.PotionType
var potion_mixer_type:GameManager.PotionType

@onready var potion_choices_parent = $"../ColorRect/potion_choices"
@onready var potion_mix_parent = $"../ColorRect/mix_stand/mix_container"

func _ready():
	setup_player_ui()

func _physics_process(delta):
	var direction = Input.get_vector("button_down","button_up","button_left", "button_right")
	#print("direction vector:", direction)
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("throw_item"):
		var next_potion = potion_prefab.instantiate()
		#print("setting up potion type: ", selected_potion_type)
		$"../..".add_child(next_potion)
		next_potion.setup_thrown_potion(selected_potion_type)
		next_potion.global_position = potion_spawn_node.global_position
	if event.is_action_pressed("potion_left"):
		#potion menu left
		change_selector("left")
	if event.is_action_pressed("potion_right"):
		#potion menu right
		change_selector("right")
	if event.is_action_pressed("potion_mix"):
		#send potion to mix station
		send_to_mixer(selected_potion_type)
	if event.is_action_pressed("potion_bank"):
		#bank potion in inventory
		pass
		
func setup_player_ui():
	for potion in potion_inventory:
		var next_selector_potion = game_manager.potion_selector_prefab.instantiate()
		next_selector_potion.setup_potion(potion)
		potion_choices_parent.add_child(next_selector_potion)
	set_potion_selector()
	
func set_potion_selector():
	if selected_potion_index != -1:
		potion_selector.global_position = potion_choices_parent.get_child(selected_potion_index).get_location()
		selected_potion_type = potion_choices_parent.get_child(selected_potion_index).potion_type
	else:
		selected_potion_type = potion_mixer_type
func change_selector(choice:String):
	match choice:
		"left":
			if selected_potion_index > 0 && selected_potion_index != -1:
				selected_potion_index -= 1 
			elif selected_potion_index == -1:
				selected_potion_index = potion_choices_parent.get_children().size()-1
			else:
				if mix_potion_checker():
					selected_potion_index = mix_station_index
					select_mixer_potion()
				else:
					selected_potion_index = potion_choices_parent.get_children().size()-1
		"right":
			if selected_potion_index <  potion_choices_parent.get_children().size()-1 && selected_potion_index != -1:
				selected_potion_index += 1
			elif selected_potion_index == -1:
				selected_potion_index = 0
			else:
				if mix_potion_checker():
					selected_potion_index = mix_station_index
					select_mixer_potion()
				else:
					selected_potion_index = 0
	
	set_potion_selector()
	
func mix_potion_checker():
	if potion_mix_parent.get_children().size() > 0:
		return potion_mix_parent.get_child(0).get_location()
	else:
		return false
	
func select_mixer_potion():
	potion_selector.global_position = mix_potion_checker()
	
func send_to_mixer(type:GameManager.PotionType):
	if potion_mixer_type == game_manager.PotionType.NONE:#setup new mix
		potion_mixer_type = type
		var mixer_potion = game_manager.potion_selector_prefab.instantiate()
		potion_mix_parent.add_child(mixer_potion)
		mixer_potion.setup_potion(potion_mixer_type)
	else:#mix the color
		var current_mix_potion = potion_mix_parent.get_child(0)
		match potion_mixer_type:
			GameManager.PotionType.RED:
				match type:
					GameManager.PotionType.RED:
						pass
					GameManager.PotionType.BLUE:
						potion_mixer_type = GameManager.PotionType.PURPLE
					GameManager.PotionType.YELLOW:
						potion_mixer_type = GameManager.PotionType.ORANGE
					_:
						potion_mixer_type = GameManager.PotionType.BLACK
			GameManager.PotionType.BLUE:
				match type:
					GameManager.PotionType.RED:
						potion_mixer_type = GameManager.PotionType.PURPLE
					GameManager.PotionType.BLUE:
						pass
					GameManager.PotionType.YELLOW:
						potion_mixer_type = GameManager.PotionType.GREEN
					_:
						potion_mixer_type = GameManager.PotionType.BLACK
			GameManager.PotionType.YELLOW:
				match type:
					GameManager.PotionType.RED:
						potion_mixer_type = GameManager.PotionType.ORANGE
					GameManager.PotionType.BLUE:
						potion_mixer_type = GameManager.PotionType.GREEN
					GameManager.PotionType.YELLOW:
						pass
					_:
						potion_mixer_type = GameManager.PotionType.BLACK
			GameManager.PotionType.GREEN:
				match type:
					GameManager.PotionType.GREEN:
						pass
					_:
						potion_mixer_type = GameManager.PotionType.BLACK
			GameManager.PotionType.ORANGE:
				match type:
					GameManager.PotionType.ORANGE:
						pass
					_:
						potion_mixer_type = GameManager.PotionType.BLACK
			GameManager.PotionType.PURPLE:
				match type:
					GameManager.PotionType.PURPLE:
						pass
					_:
						potion_mixer_type = GameManager.PotionType.BLACK
		current_mix_potion.setup_potion(potion_mixer_type)

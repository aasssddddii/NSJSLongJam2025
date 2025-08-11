extends CharacterBody2D
const SPEED = 110.0
const reverse_Speed:int = 200.0
const drag = 20

var game_manager = GameManager
var player_in_control:bool = true
#enum PotionType {
#	BLUE,
#	RED,
#	YELLOW,
#	GREEN,
#	ORANGE,
#	PURPLE
#}

const infinite_types:Array[GameManager.PotionType] = [GameManager.PotionType.BLUE,GameManager.PotionType.RED,GameManager.PotionType.YELLOW]
@onready var potion_spawn_node  = $potion_spawn

@onready var potion_selector = $"../ColorRect/potion_selector"
var selected_potion_index:int
var mix_station_index:int = -1
var potion_inventory:Array[GameManager.PotionType] = [GameManager.PotionType.BLUE,GameManager.PotionType.RED,GameManager.PotionType.YELLOW]
var selected_potion_type:GameManager.PotionType
var potion_mixer_type:GameManager.PotionType
var discard_potion_index:int

@onready var potion_choices_parent = $"../ColorRect/potion_choices"
@onready var potion_mix_parent = $"../ColorRect/mix_stand/mix_container"
@onready var ui_score = $"../deliveriesContainer/ui_score"
@onready var ui_day = $"../dayContainer/ui_day"

@onready var player_sprite = $player
var can_throw:bool = true
var throw_cooldown = .5 # +.3

func _ready():
	if !game_manager.endless_mode:
		var level_data_ref = game_manager.prep_lib.get_level_prep(game_manager.game_level)
		ui_day.text = level_data_ref["day"]
	else:
		ui_day.visible = false
	setup_player_ui()

func _physics_process(delta):
	if player_in_control:
		var direction = Input.get_vector("button_down","button_up","button_left", "button_right")
		print("direction vector:", direction)
		if direction:
			if velocity.x > 0:#moving forward
				velocity = direction * SPEED
			else:
				velocity = direction * reverse_Speed
		else:
			#if velocity.x > 0:
				#velocity.x = move_toward(velocity.x, 0, SPEED)
			#else:
			velocity.x = move_toward(velocity.x, -drag, reverse_Speed)
			velocity.y = move_toward(velocity.y, 0, SPEED)
		move_and_slide()
		ui_score.text = var_to_str(game_manager.deliveries_made)
	
func _input(event):
	if player_in_control:
		if event.is_action_pressed("throw_item") && can_throw:
			if selected_potion_type != GameManager.PotionType.NONE:
				game_manager.play_sfx(game_manager.player_throw)
				animate_player_throw()
				can_throw = false
				var next_potion = game_manager.potion_prefab.instantiate()
				#print("setting up potion type: ", selected_potion_type)
				$"../..".add_child(next_potion)
				next_potion.setup_thrown_potion(selected_potion_type)
				next_potion.global_position = potion_spawn_node.global_position
				if infinite_types.find(selected_potion_type) == -1 && selected_potion_index != -1:
					potion_inventory.remove_at(potion_inventory.find(selected_potion_type))
					refresh_player_ui()
					selected_potion_index = potion_inventory.size()-1
					set_potion_selector()
				elif selected_potion_index == -1:
					empty_mixer()
					
		if event.is_action_pressed("potion_left"):
			#potion menu left
			change_selector("left")
			game_manager.play_sfx(game_manager.select_down)
		if event.is_action_pressed("potion_right"):
			#potion menu right
			change_selector("right")
			game_manager.play_sfx(game_manager.select_up)
		if event.is_action_pressed("potion_mix"):
			#send potion to mix station
			if selected_potion_index != -1:
				discard_potion_index = selected_potion_index
				send_to_mixer(selected_potion_type)
				if infinite_types.find(potion_inventory[discard_potion_index]) == -1:
					if discard_potion_index != -1:
						potion_inventory.remove_at(discard_potion_index)
					refresh_player_ui()
					selected_potion_index = -1
					set_potion_selector()
		if event.is_action_pressed("potion_bank"):
			#bank potion in inventory
			if selected_potion_index == -1 && selected_potion_type != GameManager.PotionType.NONE && infinite_types.find(selected_potion_type) == -1 && potion_inventory.size() <5:
				getset_potion_inventory("add",selected_potion_type)
				empty_mixer()
		#if event.is_action_pressed("button_pause"):
			#game_manager.pause_game()
		
		
		
func setup_player_ui():
	for potion in potion_inventory:
		var next_selector_potion = game_manager.potion_selector_prefab.instantiate()
		potion_choices_parent.add_child(next_selector_potion)
		next_selector_potion.setup_potion(potion)
	set_potion_selector()
	
func clear_potion_ui():
	for potion in potion_choices_parent.get_children():
		potion.queue_free()
		
func refresh_player_ui():
	clear_potion_ui()
	setup_player_ui()
	
func set_potion_selector():
	if selected_potion_index != -1:
		potion_selector.global_position = potion_choices_parent.get_child(selected_potion_index).get_location()
		selected_potion_type = potion_choices_parent.get_child(selected_potion_index).potion_type
	else:
		potion_selector.global_position = potion_mix_parent.get_child(0).get_location()
		selected_potion_type = potion_mixer_type
		
func reset_potion_selector():
#	selected_potion_index = potion_choices_parent.get_children().size()-1
	set_potion_selector()
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
		game_manager.play_sfx(game_manager.mix_started)
		potion_mixer_type = type
		var mixer_potion = game_manager.potion_selector_prefab.instantiate()
		potion_mix_parent.add_child(mixer_potion)
		mixer_potion.setup_potion(potion_mixer_type)
	else:#mix the color
		game_manager.play_sfx(game_manager.mix_created)
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
		goto_mixer()

func empty_mixer():
	if potion_mix_parent.get_children().size() > 0:
		potion_mix_parent.get_child(0).queue_free()
		potion_mixer_type = game_manager.PotionType.NONE
		selected_potion_type = game_manager.PotionType.NONE
		selected_potion_index = 0
		reset_potion_selector()

func goto_mixer():
	selected_potion_index = -1
	set_potion_selector()
func getset_potion_inventory(choice:String,input):
	match choice:
		"add":
			potion_inventory.append(input)
			refresh_player_ui()
	
	
func animate_player_throw():
	player_sprite.texture = load("res://Sprites/player_throw.png")
	await get_tree().create_timer(.3).timeout
	player_sprite.texture = load("res://Sprites/player_bag.png")
	await get_tree().create_timer(throw_cooldown).timeout
	can_throw = true

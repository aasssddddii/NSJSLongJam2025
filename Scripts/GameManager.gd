extends Node

signal endless_over

const scroll_window_speed:int = 25

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
@onready var highscore_lib:Resource# = preload("res://Resources/Highscore_library.tres")
@onready var potion_prefab = preload("res://Prefabs/potion.tscn")
@onready var splatter_prefab = preload("res://Prefabs/splatter.tscn")
@onready var start_screen = preload("res://Scenes/start screen.tscn")
@onready var credits_screen = preload("res://Scenes/credit_screen.tscn")
@onready var game_over_screen = preload("res://Scenes/game over screen.tscn")
@onready var overtime_start_scene = preload("res://Scenes/overtime screen.tscn")
@onready var overtime_complete_scene = preload("res://Scenes/overtime complete screen.tscn")
@onready var level_select_screen = preload("res://Scenes/level_select.tscn")
@onready var intro_scene = preload("res://Scenes/intro screen.tscn")
@onready var prep_lib = preload("res://Resources/Prep_Library.tres")
@onready var potion_boy_scene = preload("res://Scenes/potion boy test.tscn")
@onready var transitioner_prefab = preload("res://Scenes/scene transitioner.tscn")
@onready var endless_mode_prefab = preload("res://Scenes/potion boy endless.tscn")
@onready var endless_tile_spawn = preload("res://Prefabs/endless_tile_spawn.tscn")
var requestable_potions:Array[PotionType] = [PotionType.BLUE,PotionType.RED,PotionType.YELLOW,PotionType.GREEN,PotionType.ORANGE,PotionType.PURPLE,PotionType.BLACK]
var splatter_textures:Array[String] = ["res://Sprites/splatter1.png","res://Sprites/splatter2.png","res://Sprites/splatter3.png"]
var rng = RandomNumberGenerator.new()
var save_path = "res://Saves/Highscores.tres"



var player_in_game:bool

#var shown_end_credits:bool#needs to be exported to level highscore for ease of saving
var show_end_splash:bool

#var level_5_complete:bool
#var shown_intro_scene:bool#needs to be exported to level highscore for ease of saving
#var shown_overtime_intro_scene:bool#needs to be exported to level highscore for ease of saving

#MUST RESETERS
var company_profits:int
var deliveries_made:int
var level_splatters:int
var unhappy_customers:int
var level_score:int


#var color_blind_mode:bool #= true

var ui_jukebox= AudioStreamPlayer2D.new()
var ui_sfx_generator = AudioStreamPlayer2D.new()

#var game_muted:bool#needs to be exported to level highscore for ease of saving
#var sfx_volume:int# = 0#needs to be exported to level highscore for ease of saving
#var music_volume:int#needs to be exported to level highscore for ease of saving

var transitioner
var transitioning:bool
var transition_timer:float = .8

var potion_selector_prefab = preload("res://Prefabs/potion_template.tscn")
var unpausable:bool
var game_level:int #= 5

var endless_mode:bool

func _ready():
	add_child(ui_jukebox)
	add_child(ui_sfx_generator)
	ui_jukebox.bus = "Music"
	ui_sfx_generator.bus = "SFX"
	
	ui_jukebox.volume_db = -10
	ui_sfx_generator.volume_db = -10
	#set proccessing mode for audio streams
	ui_jukebox.process_mode = Node.PROCESS_MODE_ALWAYS
	ui_sfx_generator.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if !get_saved_settings():
		#change to check for file when game saving
		setup_settings()
	
	transitioner = transitioner_prefab.instantiate()
	get_tree().root.add_child.call_deferred(transitioner)
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if !player_in_game:
		if event.is_action_pressed("button_up"):
			play_sfx(select_up)
		if event.is_action_pressed("button_down"):
			play_sfx(select_down)
		if event.is_action_pressed("button_right"):
			play_sfx(select_up)
		if event.is_action_pressed("button_left"):
			play_sfx(select_down)
		
		
	if event.is_action_pressed("button_pause"):
		if get_tree().paused && unpausable:
			unpause_game()
		else:
			pause_game()

func pickup_player_audio(parent:Node2D):
	ui_jukebox.reparent(parent)
	ui_sfx_generator.reparent(parent)
	
func return_player_audio():
	ui_jukebox.global_position = Vector2.ZERO
	ui_sfx_generator.global_position = Vector2.ZERO
	ui_jukebox.reparent(self)
	ui_sfx_generator.reparent(self)
	
	
func endless_check():
	if unhappy_customers >= 3 && endless_mode:
		print("endless over")
		endless_over.emit()
		
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
		2:
			rng_potion_index_high = 5
			required_amount_high = 1
		3:
			rng_potion_index_high = 5
			required_amount_high = 2
		4:
			required_amount_high = 3
		5:
			required_amount_low = 2
			required_amount_high = 3
		6:
			required_amount_low = 2
			required_amount_high = 3
		7:
			required_amount_low = 3
			required_amount_high = 3
	#pick how many potions required
	for i in rng.randi_range(required_amount_low,required_amount_high):
		#pick which potion is next
		returned_request.append(requestable_potions[rng.randi_range(rng_potion_index_low,rng_potion_index_high)])
	return returned_request

func get_endless_potion_request(house_type:String,endless_level:int):
	var rng_potion_index_low:int
	var rng_potion_index_high:int = 6
	var required_amount_low:int = 1
	var required_amount_high:int = 3
	var returned_request:Array[PotionType]
	
	match house_type:
		"house":
			rng_potion_index_high = 5 
			if endless_level >= 2:
				required_amount_high = 2
			else:
				required_amount_high = 1
		"hut":
			if endless_level >= 4:
				required_amount_high = 3
			else:
				required_amount_high = 2
		"castle":
			
			if endless_level > 2:
				required_amount_low = 3
			else:
				required_amount_low = 2
	
	#pick how many potions required
	for i in rng.randi_range(required_amount_low,required_amount_high):
		#pick which potion is next
		returned_request.append(requestable_potions[rng.randi_range(rng_potion_index_low,rng_potion_index_high)])
	return returned_request


func change_scene(from_scene,to_scene):
	#while scene transitioning dont change scene
	if !transitioning:
		transitioning = true
		await transistion_to_scene().timeout
		
		stop_music()
		var next_scene = to_scene.instantiate()
		if to_scene == level_select_screen && !highscore_lib.shown_intro_scene:
			next_scene = intro_scene.instantiate()
			highscore_lib.shown_intro_scene = true
			highscore_lib.values_set = true
			save_game()
		if to_scene == level_select_screen && !highscore_lib.shown_overtime_intro_scene && highscore_lib.shown_intro_scene && highscore_lib.level_5_complete:
			next_scene = overtime_start_scene.instantiate()
			highscore_lib.shown_overtime_intro_scene = true
			highscore_lib.values_set = true
			save_game()
		get_tree().root.add_child.call_deferred(next_scene)
		if to_scene == potion_boy_scene:
			player_in_game = true
			play_music(game_music)
		if to_scene == endless_mode_prefab:
			player_in_game = true
			play_music(game_music)
		if to_scene == credits_screen && show_end_splash:
			await get_tree().create_timer(.5).timeout
			next_scene.show_win_splash()
		from_scene.queue_free()
		transition_from_scene()
		
	
func finish_level_scene(level_node):
	play_sfx(button_select)
	await get_tree().create_timer(.5).timeout
	return_player_audio()
	#set highscore
	print("High score check: ", highscore_lib.get_level_highscore(game_level), " < ", deliveries_made)
	var level_highscore_ref = highscore_lib.get_level_highscore(game_level)
	if level_highscore_ref["deliveries_made"] < deliveries_made:
		level_highscore_ref["score"] = level_score
		level_highscore_ref["deliveries_made"] = deliveries_made
		level_highscore_ref["houses_hit"] = level_splatters
		level_highscore_ref["angry_clients"] = unhappy_customers
		level_highscore_ref["profit"] = company_profits
		
	var requirment_meet:bool
	var level_ref_data = prep_lib.get_level_prep(game_level)
	if deliveries_made >= level_ref_data["required"]:
		requirment_meet = true
#	match game_level:
#		1:
#			if deliveries_made > 0:
#				requirment_meet = true
#		2,3:
#			if deliveries_made > 2:
#				requirment_meet = true
#		4,5,6,7:
#			if deliveries_made > :
#				requirment_meet = true
			
	if requirment_meet:
		level_highscore_ref["completed"] = true
		
		
	if requirment_meet && game_level == 5:
		if !highscore_lib.shown_end_credits:
			print("Showing Game Over Win screen")
			highscore_lib.level_5_complete = true
			save_game()
			change_scene(level_node,game_over_screen)
			level_reset()
		else:
			#change scene
			change_scene(level_node,level_select_screen)
			#reset restters
			level_reset()
	elif requirment_meet && game_level == 7:
			print("Showing OVERTIME Game Over Win screen")
			if level_highscore_ref["deliveries_made"] < deliveries_made:
				level_highscore_ref["score"] = level_score
				level_highscore_ref["deliveries_made"] = deliveries_made
				level_highscore_ref["houses_hit"] = level_splatters
				level_highscore_ref["angry_clients"] = unhappy_customers
				level_highscore_ref["profit"] = company_profits
			change_scene(level_node,overtime_complete_scene)
			level_reset()
	else:
		#change scene
		change_scene(level_node,level_select_screen)
		#reset restters
		level_reset()
	save_game()


func finish_endless_scene(level_node):
	return_player_audio()
	change_scene(level_node,start_screen)
	level_reset()


func level_reset():
	company_profits = 0
	deliveries_made = 0
	level_splatters = 0
	unhappy_customers = 0
	level_score = 0
	
#sfx paths
var button_select = "res://Audio/SFX/button_select.ogg"
var house_happy = "res://Audio/SFX/house happy.ogg"
var house_mad = "res://Audio/SFX/house mad.ogg"
var mix_created = "res://Audio/SFX/mix created.ogg"
var mix_started = "res://Audio/SFX/mix started.ogg"
var player_throw = "res://Audio/SFX/player throw.ogg"
var potion_accepted = "res://Audio/SFX/potion accepted.ogg"
var splatter = "res://Audio/SFX/splatter.ogg"
var select_up = "res://Audio/SFX/select up.ogg"
var select_down = "res://Audio/SFX/select down.ogg"
var start_button_sfx = "res://Audio/SFX/start_button_select.ogg"
#music path
var game_music = "res://Audio/potion_boy theme.ogg"
	
func play_sfx(sfx_path:String):
	ui_sfx_generator.stream = load(sfx_path)
	ui_sfx_generator.play()
	
func play_music(music_path:String):
	ui_jukebox.stream = load(music_path)
	ui_jukebox.play()
	
func stop_music():
	ui_jukebox.stop()
	
func mute_audio():
	ui_sfx_generator.stop()
	ui_jukebox.stop()
	ui_sfx_generator.volume_db = -80
	ui_jukebox.volume_db = -80
	highscore_lib.game_muted = true
	highscore_lib.values_set = true
	#send to highscoure resource
	save_game()
	
func unmute_audio():
	ui_sfx_generator.volume_db = 0
	ui_jukebox.volume_db = 0
	highscore_lib.game_muted = false
	highscore_lib.values_set = true
	#send to highscoure resource
	save_game()

func transistion_to_scene():
	var animator:AnimationPlayer = transitioner.animator
	animator.play("bubble in")
	return get_tree().create_timer(transition_timer)
	
	
func transition_from_scene():
	var animator:AnimationPlayer = transitioner.animator
	await get_tree().create_timer(transition_timer).timeout
	animator.play("bubble out")
	transitioning = false
	
func pause_game():
	get_tree().paused = true
	await get_tree().create_timer(.2).timeout
	unpausable = true
	
func unpause_game():
	get_tree().paused = false
	unpausable = false
	#ui_jukebox.stream_paused = false
	

func setup_settings():
	match highscore_lib.fullscreen:
		0:#windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:#fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:#borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	highscore_lib.game_muted = highscore_lib.game_muted
	
	if highscore_lib.game_muted:
		mute_audio()
	else:
		unmute_audio()
	ui_jukebox.volume_db = highscore_lib.music_volume
	ui_sfx_generator.volume_db = highscore_lib.sfx_volume
	highscore_lib.values_set = true
	
func change_volume(bus:int,amount:int):
	print("CHANGING VOLUME BUS:", bus, " TO: ", amount)
	AudioServer.set_bus_volume_db(bus,amount)
	match  bus:
		1:
			highscore_lib.sfx_volume = amount
		2:
			highscore_lib.music_volume = amount
			
	highscore_lib.values_set = true
	save_game()
	
func save_game():
	var error = ResourceSaver.save(highscore_lib, save_path)
	if error != OK:
		print("Error saving resource: ", error)
		return error
	else:
		print("Resource saved successfully!")
		return true
func get_saved_settings():
	var loaded_highscores = ResourceLoader.load(save_path)
	if loaded_highscores:
		highscore_lib = loaded_highscores
		print("sanity check values set: ", highscore_lib.values_set)
		return true
	else:
		print("Error loading resource or file not found.")
		highscore_lib = preload("res://Resources/Highscore_library.tres")
		return false
		

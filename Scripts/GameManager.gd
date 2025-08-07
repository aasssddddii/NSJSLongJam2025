extends Node

var game_manager = GameManager

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
@onready var credits_screen = preload("res://Scenes/credit_screen.tscn")
@onready var game_over_screen = preload("res://Scenes/game over screen.tscn")
@onready var overtime_start_scene = preload("res://Scenes/overtime screen.tscn")
@onready var overtime_complete_scene = preload("res://Scenes/overtime complete screen.tscn")
@onready var level_select_screen = preload("res://Scenes/level_select.tscn")
@onready var intro_scene = preload("res://Scenes/intro screen.tscn")
@onready var prep_lib = preload("res://Resources/Prep_Library.tres")
@onready var potion_boy_scene = preload("res://Scenes/potion boy test.tscn")
@onready var transitioner_prefab = preload("res://Scenes/scene transitioner.tscn")
var requestable_potions:Array[PotionType] = [PotionType.BLUE,PotionType.RED,PotionType.YELLOW,PotionType.GREEN,PotionType.ORANGE,PotionType.PURPLE,PotionType.BLACK]
var splatter_textures:Array[String] = ["res://Sprites/splatter1.png","res://Sprites/splatter2.png","res://Sprites/splatter3.png"]
var rng = RandomNumberGenerator.new()





var shown_end_credits:bool
var show_end_splash:bool

var level_5_complete:bool
var shown_intro_scene:bool
var shown_overtime_intro_scene:bool

#MUST RESETERS
var company_profits:int
var deliveries_made:int
var level_splatters:int
var unhappy_customers:int
var level_score:int

@onready var highscore_lib:Resource = preload("res://Resources/Highscore_library.tres")

var color_blind_mode:bool #= true

var ui_jukebox= AudioStreamPlayer2D.new()
var ui_sfx_generator = AudioStreamPlayer2D.new()

var sfx_volume:int# = 0
var music_volume:int

var transitioner

var potion_selector_prefab = preload("res://Prefabs/potion_template.tscn")

var game_level:int #= 5

func _ready():
	add_child(ui_jukebox)
	add_child(ui_sfx_generator)
	ui_jukebox.bus = "Music"
	ui_sfx_generator.bus = "SFX"
	ui_jukebox.volume_db = 1
	ui_sfx_generator.volume_db = 1
	transitioner = transitioner_prefab.instantiate()
	get_tree().root.add_child.call_deferred(transitioner)
	


func pickup_player_audio(parent:Node2D):
	ui_jukebox.reparent(parent)
	ui_sfx_generator.reparent(parent)
	
func return_player_audio():
	ui_jukebox.global_position = Vector2.ZERO
	ui_sfx_generator.global_position = Vector2.ZERO
	ui_jukebox.reparent(self)
	ui_sfx_generator.reparent(self)
	
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
		4,5:
			required_amount_high = 3
			
	#pick how many potions required
	for i in rng.randi_range(required_amount_low,required_amount_high):
		#pick which potion is next
		returned_request.append(requestable_potions[rng.randi_range(rng_potion_index_low,rng_potion_index_high)])
	return returned_request

func change_scene(from_scene,to_scene):
	await transistion_to_scene().timeout
	stop_music()
	var next_scene = to_scene.instantiate()
	if to_scene == level_select_screen && !shown_intro_scene:
		next_scene = intro_scene.instantiate()
		shown_intro_scene = true
	if to_scene == level_select_screen && !shown_overtime_intro_scene && shown_intro_scene && level_5_complete:
		next_scene = overtime_start_scene.instantiate()
		shown_overtime_intro_scene = true
	get_tree().root.add_child.call_deferred(next_scene)
	if to_scene == potion_boy_scene:
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
	print("finishing for game level: ", game_level)
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
		if !shown_end_credits:
			print("Showing Game Over Win screen")
			level_5_complete = true
			change_scene(level_node,game_over_screen)
			level_reset()
		else:
			#change scene
			change_scene(level_node,level_select_screen)
			#reset restters
			level_reset()
	elif requirment_meet && game_level == 7:
			print("Showing OVERTIME Game Over Win screen")
			change_scene(level_node,overtime_complete_scene)
			level_reset()
	else:
		#change scene
		change_scene(level_node,level_select_screen)
		#reset restters
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
	
func unmute_audio():
	ui_sfx_generator.volume_db = 0
	ui_jukebox.volume_db = 0

func transistion_to_scene():
	var animator:AnimationPlayer = transitioner.animator
	animator.play("bubble out")
	return get_tree().create_timer(.8)
	
func transition_from_scene():
	var animator:AnimationPlayer = transitioner.animator
	await get_tree().create_timer(.8).timeout
	animator.play("bubble in")

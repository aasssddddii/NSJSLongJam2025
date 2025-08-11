extends Camera2D

var game_manager = GameManager



const regular_speed = Vector2(1.4,0)
const max_speed = Vector2(2.0,0)#Testing
const acceleration = Vector2(.2,0)#Testing
const deceleration = Vector2(.1,0)
const cam_speed = 100
@export var testing:bool

@onready var player_node = $CharacterBody2D

var scroll_speed:Vector2 = regular_speed
var speed_up:bool


func _ready():
	level_summary_background.visible = false
	game_manager.pickup_player_audio(self)
	$"potion oob detector".body_entered.connect(remove_oob_potion)
	if game_manager.endless_mode:
		game_manager.endless_over.connect(setup_level_summary)

func _process(delta):
	if speed_up && scroll_speed.x < max_speed.x:
		scroll_speed += acceleration
	elif !speed_up && scroll_speed.x > regular_speed.x:
		scroll_speed -= deceleration
	position += scroll_speed
	
	
	
		

func _input(event):
	if event.is_action_pressed("button_up"):
		#speed up
		speed_up = true
	if event.is_action_pressed("button_down"):
		#slow down
		speed_up = false
	elif event.is_action_released("button_up"):
		speed_up = false
	if testing:
		if event.is_action_pressed("debug_scroll_up"):
			zoom += Vector2(.1,.1)
		if event.is_action_pressed("debug_scroll_down"):
			zoom -= Vector2(.1,.1)
		if event.is_action_pressed("debug_up"):
			offset += Vector2.UP * cam_speed
		if event.is_action_pressed("debug_down"):
			offset += Vector2.DOWN * cam_speed
		if event.is_action_pressed("debug_left"):
			offset += Vector2.LEFT * cam_speed
		if event.is_action_pressed("debug_right"):
			offset += Vector2.RIGHT * cam_speed


func _on_level_end_check_area_entered(area):
	if !game_manager.endless_mode:
		if area.name == "stage_end":
			print("STAGE CLEAR")
			setup_level_summary()
	else:
		print("SPAWN NEXT HOUSE WAVE")
		get_parent().spawn_next_level()
		
		
		
##Level summary stuff
@onready var level_summary_background = $level_summary_background
@onready var ui_deliveries = $level_summary_background/level_complete_row/middleContainer/ui_deliveries
@onready var ui_splatters = $level_summary_background/level_complete_row/middleContainer/ui_splatters
@onready var ui_unhappy = $level_summary_background/level_complete_row/middleContainer/ui_unhappy
@onready var ui_profit = $level_summary_background/level_complete_row/rightContainer/ui_company_profit
@onready var ui_final_score = $level_summary_background/level_complete_row/rightContainer/MarginContainer2/ui_final_score

func setup_level_summary():
	player_node.player_in_control = false
	level_summary_background.visible = true
	ui_deliveries.text = var_to_str(game_manager.deliveries_made)+ " x"
	ui_splatters.text = var_to_str(game_manager.level_splatters)+ " x"
	ui_unhappy.text = var_to_str(game_manager.unhappy_customers)+ " x"
	ui_profit.text = "$" + var_to_str(game_manager.company_profits)
	var final_score = (game_manager.deliveries_made * 30)-((game_manager.level_splatters*5)+(game_manager.unhappy_customers * 15))
	game_manager.level_score = final_score
	ui_final_score.text = var_to_str(final_score)
	$level_summary_background/Button.grab_focus()


func _on_button_button_down():
	game_manager.play_sfx(game_manager.button_select)
	if !game_manager.endless_mode:
		game_manager.finish_level_scene(get_parent())
		game_manager.player_in_game = false
	else:
		#finish endless
		print("finishing ENDLESS")
		game_manager.finish_endless_scene(get_parent())
		game_manager.endless_mode = false
		game_manager.player_in_game = false
	



func remove_oob_potion(area):
	if area.is_in_group("potion"):
		print("removing potion")
		game_manager.level_splatters += 1
		area.queue_free()

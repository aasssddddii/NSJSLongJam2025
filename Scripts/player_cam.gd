extends Camera2D

var game_manager = GameManager

const regular_speed = Vector2(1,0)
const max_speed = Vector2(2,0)
const acceleration = Vector2(.01,0)
const deceleration = Vector2(.028,0)

@onready var player_node = $CharacterBody2D

var scroll_speed:Vector2 = regular_speed
var speed_up:bool


func _ready():
	level_summary_background.visible = false

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


func _on_level_end_check_area_entered(area):
	if area.name == "stage_end":
		print("STAGE CLEAR")
		setup_level_summary()
		
		
		
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
		


func _on_button_button_down():
	game_manager.finish_level_scene(get_parent())
	

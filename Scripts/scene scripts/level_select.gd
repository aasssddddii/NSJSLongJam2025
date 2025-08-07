extends Node2D

var game_manager = GameManager

var ui_level_1
var ui_level_2
var ui_level_3
var ui_level_4
var ui_level_5
var ui_level_6
var ui_level_7

@export var testing:bool
@onready var title = $Title
@onready var levels_grid = $GridContainer
@onready var back_button = $back
@onready var mission_prep_window = $"Mission Prep"
func _ready():
	#setup completion visuals

	#Display levels
	show_unlocked_levels()
	pass



func show_unlocked_levels():
	mission_prep_window.visible = false
	ui_level_1 = $GridContainer/ui_monday
	ui_level_2 = $GridContainer/ui_tuesday
	ui_level_3 = $GridContainer/ui_wednesday
	ui_level_4 = $GridContainer/ui_thursday
	ui_level_5 = $GridContainer/ui_friday
	ui_level_6 = $GridContainer/ui_saturday
	ui_level_7 = $GridContainer/ui_sunday
	var level_buttons = [ui_level_1,ui_level_2,ui_level_3,ui_level_4,ui_level_5,ui_level_6,ui_level_7]
	print("checking for completed levels")
	var level_check_index:int
	for level in game_manager.highscore_lib.levels:
		if level["completed"] && level_check_index+1 < level_buttons.size():
			var current_check_level_button = level_buttons[level_check_index]
			current_check_level_button.ui_deliveries_node.text = var_to_str(game_manager.deliveries_made)
			current_check_level_button.complete_star.visible = true
			level_buttons[level_check_index+1].visible = true
		elif testing:
			level_buttons[level_check_index].visible = true
		else:
			break
		level_check_index+=1

func _on_back_button_down():
	game_manager.change_scene(self,game_manager.start_screen)


func _on_ui_monday_button_down():
	game_manager.game_level = 1
	start_prep_window(game_manager.game_level)
func _on_ui_tuesday_button_down():
	game_manager.game_level = 2
	start_prep_window(game_manager.game_level)
func _on_ui_wednesday_button_down():
	game_manager.game_level = 3
	start_prep_window(game_manager.game_level)
func _on_ui_thursday_button_down():
	game_manager.game_level = 4
	start_prep_window(game_manager.game_level)
func _on_ui_friday_button_down():
	game_manager.game_level = 5
	start_prep_window(game_manager.game_level)
func _on_ui_saturday_button_down():
	game_manager.game_level = 6
	start_prep_window(game_manager.game_level)
func _on_ui_sunday_button_down():
	game_manager.game_level = 7
	start_prep_window(game_manager.game_level)

func start_prep_window(level:int):
	hide_level_select()
	mission_prep_window.setup_prep(game_manager.prep_lib.get_level_prep(level))#Prep data from library

func start_potion_boy(level:int):
	game_manager.game_level = level
	game_manager.change_scene(self,game_manager.potion_boy_scene)

func hide_level_select():
	title.visible = false
	levels_grid.visible = false
	back_button.visible = false

extends Sprite2D

var game_manager = GameManager

@onready var ui_street = $HBoxContainer/rightContainer/ui_street
@onready var ui_client = $HBoxContainer/rightContainer/ui_client
@onready var ui_requirement = $HBoxContainer/rightContainer/ui_requirement
@onready var ui_notes = $HBoxContainer/rightContainer/ui_notes
@onready var ui_title = $"title label"
@onready var client_label = $"HBoxContainer/LeftContainer/client label"
@onready var requirement_label = $"HBoxContainer/LeftContainer/requirement label"
var prep_data:Dictionary
#{
#	"street_name":"",
#	"clients":6,
#	"required":6,
#	"notes":["1", "2", "3"]
#}

func setup_prep(input_data:Dictionary):
	prep_data = input_data
	print("storing prep data: ", prep_data)
	#make pick random street name
	if typeof(prep_data["street_name"]) != TYPE_ARRAY:
		ui_street.text = prep_data["street_name"]
	else:
		ui_street.text = prep_data["street_name"].pick_random()
	
	ui_client.text = var_to_str(prep_data["clients"])
	ui_requirement.text = var_to_str(prep_data["required"])
	#check if endless to hide amounts 
	
	ui_notes.text = prep_data["notes"].pick_random()
	
	if prep_data["day"] != "Endless Mode":
		ui_title.text = prep_data["day"] + "'s Route"
	else:
		ui_title.text = prep_data["day"]
		endless_hide()
	visible = true
	
	
	
	$Button.call_deferred("grab_focus")

func endless_hide():
	ui_client.visible = false
	ui_requirement.visible = false
	client_label.visible = false
	requirement_label.visible = false
	

func _on_button_button_down():
	game_manager.play_sfx(game_manager.start_button_sfx)
	if prep_data["day"] != "Endless Mode":
		get_parent().start_potion_boy(game_manager.game_level)
	else:
		game_manager.change_scene(get_parent(),game_manager.endless_mode_prefab)


func _on_button_2_button_down() -> void:
	game_manager.play_sfx(game_manager.button_select)
	if prep_data["day"] != "Endless Mode":
		get_parent().show_level_select(true)
	else:
		game_manager.endless_mode = false
		get_parent().show_start_menu()
		get_parent().reset_focus()
		pass # Replace with function body.
	visible = false

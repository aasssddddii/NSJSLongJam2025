extends Sprite2D

var game_manager = GameManager

@onready var ui_street = $HBoxContainer/rightContainer/ui_street
@onready var ui_client = $HBoxContainer/rightContainer/ui_client
@onready var ui_requirement = $HBoxContainer/rightContainer/ui_requirement
@onready var ui_notes = $HBoxContainer/rightContainer/ui_notes

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
	
	ui_street.text = prep_data["street_name"]
	ui_client.text = var_to_str(prep_data["clients"])
	ui_requirement.text = var_to_str(prep_data["required"])
	ui_notes.text = prep_data["notes"].pick_random()
	
	visible = true
	


func _on_button_button_down():
	game_manager.play_sfx(game_manager.button_select)
	get_parent().start_potion_boy(game_manager.game_level)

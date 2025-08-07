extends TextureRect

var game_manager = GameManager

var potion_type:GameManager.PotionType
@onready var infinity_decal = $infinity
@onready var colorblind_label = $Label
@onready var colorblind_move = $colorblind_move

func setup_potion(input_type:GameManager.PotionType):
	var colorblind_preset = preload("res://Fonts/potion_template.tres")
	var colorblind_move = $colorblind_move
	potion_type = input_type
	#print("setting up potion with potion type: ", potion_type)
	var final_modulate:Color
	match potion_type:
		GameManager.PotionType.RED:
			final_modulate = Color.RED
		GameManager.PotionType.BLUE:
			final_modulate = Color.BLUE
		GameManager.PotionType.YELLOW:
			final_modulate = Color.YELLOW
		GameManager.PotionType.GREEN:
			final_modulate = Color.GREEN
		GameManager.PotionType.ORANGE:
			final_modulate = Color.ORANGE
		GameManager.PotionType.PURPLE:
			final_modulate = Color.PURPLE
		GameManager.PotionType.BLACK:
			final_modulate = Color.BLACK
	show_infinity()
	show_colorblind_label()
	self_modulate = final_modulate
	if get_parent().name == "request_container":
		colorblind_label.global_position = colorblind_move.global_position
		colorblind_preset.default_font_size = 15
	else:
		colorblind_preset.default_font_size = 25
	
func get_location():
	var location = $Node2D
	return location.global_position
func show_infinity():
	const primary_potions:Array[GameManager.PotionType] = [GameManager.PotionType.RED,GameManager.PotionType.BLUE,GameManager.PotionType.YELLOW]
	if primary_potions.find(potion_type) == -1 || get_parent().name == "request_container":
		infinity_decal.visible = false  
func show_colorblind_label():
	colorblind_label = $Label
	colorblind_label.visible = game_manager.color_blind_mode
	var colorblind_text:String = ""
	match potion_type:
		GameManager.PotionType.RED:
			colorblind_text = "R"
		GameManager.PotionType.BLUE:
			colorblind_text = "B"
		GameManager.PotionType.YELLOW:
			colorblind_text = "Y"
		GameManager.PotionType.GREEN:
			colorblind_text = "G"
		GameManager.PotionType.ORANGE:
			colorblind_text = "O"
		GameManager.PotionType.PURPLE:
			colorblind_text = "P"
		GameManager.PotionType.BLACK:
			colorblind_text = "Bl"
	colorblind_label.text = colorblind_text

extends CharacterBody2D

const throw_speed:Vector2 = Vector2(-200,-200)
const spin_speed:int = 5
var game_manager = GameManager

var potion_type:GameManager.PotionType
@onready var potion_sprite = $Sprite2D
@onready var colorblind_label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = throw_speed
	

func _process(delta):
	rotation += deg_to_rad(-spin_speed)
	move_and_slide()

func setup_thrown_potion(input_type:GameManager.PotionType):
	potion_type = input_type
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
			
	potion_sprite.modulate = final_modulate
	if game_manager.color_blind_mode:
		setup_colorblind()
	else:
		colorblind_label.text = ""
	
	
func setup_colorblind():
	var colorblind_text = ""
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
	

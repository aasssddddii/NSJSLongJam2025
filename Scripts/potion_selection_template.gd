extends TextureRect

var potion_type:GameManager.PotionType


func setup_potion(input_type:GameManager.PotionType):
	potion_type = input_type
	print("setting up potion with potion type: ", potion_type)
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
			
	self_modulate = final_modulate
	
func get_location():
	var location = $Node2D
	return location.global_position

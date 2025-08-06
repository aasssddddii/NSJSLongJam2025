extends Sprite2D


func setup_splatter(type:GameManager.PotionType):
	var final_modulate:Color
	match type:
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
	modulate = final_modulate

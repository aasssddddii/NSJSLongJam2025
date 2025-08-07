extends Node2D

var game_manager = GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	$OvertimeStarDisplay.visible = game_manager.level_5_complete


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_button_down():
	get_tree().quit()


func _on_start_button_down():
	game_manager.change_scene(self, game_manager.level_select_screen)


func _on_credits_button_down():
	game_manager.change_scene(self, game_manager.credits_screen)

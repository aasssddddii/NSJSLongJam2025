extends Node2D

var game_manager = GameManager




func _on_back_button_down():
	game_manager.change_scene(self,game_manager.start_screen)


func _on_ui_monday_button_down():
	game_manager.game_level = 1
	game_manager.change_scene(self,game_manager.potion_boy_scene)
func _on_ui_tuesday_button_down():
	game_manager.game_level = 2
	game_manager.change_scene(self,game_manager.potion_boy_scene)
func _on_ui_wednesday_button_down():
	game_manager.game_level = 3
	game_manager.change_scene(self,game_manager.potion_boy_scene)
func _on_ui_thursday_button_down():
	game_manager.game_level = 4
	game_manager.change_scene(self,game_manager.potion_boy_scene)
func _on_ui_friday_button_down():
	game_manager.game_level = 5
	game_manager.change_scene(self,game_manager.potion_boy_scene)
func _on_ui_saturday_button_down():
	game_manager.game_level = 6
	game_manager.change_scene(self,game_manager.potion_boy_scene)
func _on_ui_sunday_button_down():
	game_manager.game_level = 7
	game_manager.change_scene(self,game_manager.potion_boy_scene)

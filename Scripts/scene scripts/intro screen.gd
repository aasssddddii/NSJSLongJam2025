extends Node2D
var game_manager = GameManager
func _on_done_button_down():
	game_manager.play_sfx(game_manager.button_select)
	game_manager.change_scene(self,game_manager.level_select_screen)

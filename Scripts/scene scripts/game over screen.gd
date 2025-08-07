extends Node2D

var game_manager = GameManager
func _on_done_button_down():
	game_manager.play_sfx(game_manager.button_select)
	game_manager.show_end_splash = true
	game_manager.change_scene(self,game_manager.credits_screen)

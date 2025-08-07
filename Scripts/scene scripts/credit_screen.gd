extends Node2D

var game_manager = GameManager

@onready var game_win_message = $level5_win_message


func show_win_splash():
	game_win_message = $level5_win_message
	game_manager.shown_end_credits = true
	game_win_message.visible = true



func _on_done_button_down():
	game_manager.play_sfx(game_manager.button_select)
	game_manager.change_scene(self,game_manager.start_screen)

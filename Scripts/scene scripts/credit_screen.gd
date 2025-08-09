extends Node2D

var game_manager = GameManager

@onready var game_win_message = $level5_win_message
var done_button
var scroll_bar
func _ready():
	done_button = $done
	done_button.grab_focus()
	scroll_bar = $ScrollContainer/_v_scroll
	scroll_bar.focus_mode = Control.FOCUS_ALL
	scroll_bar.step = game_manager.scroll_window_speed
	done_button.focus_neighbor_left = NodePath(scroll_bar.get_path())
	scroll_bar.focus_neighbor_right = NodePath(done_button.get_path())
	

func show_win_splash():
	game_win_message = $level5_win_message
	game_manager.highscore_lib.shown_end_credits = true
	game_win_message.visible = true
	#$ScrollContainer.grab_focus()
	


func _on_done_button_down():
	game_manager.play_sfx(game_manager.button_select)
	game_manager.change_scene(self,game_manager.start_screen)
